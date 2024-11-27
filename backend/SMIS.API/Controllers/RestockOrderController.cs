using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;
using SMIS.Application.DTOs;
using Microsoft.AspNetCore.Authorization;

namespace SMIS.API.Controllers
{
    [Authorize]
    [ApiController]
        [Route("api/[controller]")]

    public class RestockOrderController : ControllerBase
    {
        private readonly RestockOrderService _restockOrderService;
        private readonly UserService _userService;
        public RestockOrderController(RestockOrderService restockOrderService, UserService userService)
        {
            _restockOrderService = restockOrderService;
            _userService = userService;
        }

        [HttpGet]
        public async Task<IEnumerable<RestockOrder>> GetAllRestockOrdersAsync()
        {
            return await _restockOrderService.GetAllRestockOrdersAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<RestockOrder?>> GetRestockOrderByIdAsync(Guid id)
        {
            var restockOrder = await _restockOrderService.GetRestockOrderByIdAsync(id);
            if (restockOrder == null)
            {
                return NotFound($"RestockOrder with id {id} not found.");
            }
            return restockOrder;
        }

        [HttpPost]
        public async Task<IActionResult> AddRestockOrderAsync([FromBody] RestockOrderRequest request)
        {
            var restockOrder = request.RestockOrder;
            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            restockOrder.Created = localTime; // Usar la hora local en lugar de UTC

            restockOrder.CreatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _restockOrderService.AddRestockOrderAsync(restockOrder);

            return Ok("RestockOrder added successfully");
        }

        [HttpPut]
        public async Task<IActionResult> UpdateRestockOrderAsync([FromBody] RestockOrderRequest request)
        {
            var restockOrder = request.RestockOrder;
            if (restockOrder.IdRestockOrder == Guid.Empty)
            {
                return BadRequest("RestockOrder Id is required.");
            }

            var existingRestockOrder = await _restockOrderService.GetRestockOrderByIdAsync(restockOrder.IdRestockOrder);
            if (existingRestockOrder == null)
            {
                return NotFound($"RestockOrder with id {restockOrder.IdRestockOrder} not found.");
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            request.RestockOrder.Updated = localTime;

            request.RestockOrder.UpdatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _restockOrderService.UpdateRestockOrderAsync(restockOrder);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task DeletedRestockOrderAsync(Guid id)
        {
            await _restockOrderService.DeletedRestockOrderAsync(id);
        }
    }
}
