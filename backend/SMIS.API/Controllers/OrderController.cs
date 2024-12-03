using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;
using SMIS.Core.Interfaces;
using SMIS.Application.DTOs;
using Microsoft.AspNetCore.Authorization;

namespace SMIS.API.Controllers{

    [Authorize]
    [ApiController]
    [Route("api/[controller]")]

    public class OrderController : ControllerBase
    {

        private readonly OrderService _orderService;
        private readonly UserService _userService;

        public OrderController(OrderService orderService, UserService userService)
        {
            _orderService = orderService;
            _userService = userService;
        }

        [HttpGet]
        public async Task<IEnumerable<Order>> GetAllOrdersAsync()
        {
            return await _orderService.GetAllOrdersAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Order?>> GetOrderByIdAsync(Guid id)
        {
            var order = await _orderService.GetOrderByIdAsync(id);
            if (order == null)
            {
                return NotFound($"Order with id {id} not found.");
            }
            return order;
        }


        [HttpPost]
        public async Task<IActionResult> AddOrder([FromBody] OrderRequest request)
        {
            var order = request.Order;
            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            order.Created = localTime; // Usar la hora local en lugar de UTC

            order.CreatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _orderService.AddOrderAsync(order);
            return Ok("Order added successfully");
        }

        [HttpPut]
        public async Task<IActionResult> UpdateOrder([FromBody] OrderRequest request)
        {
            var order = request.Order;
            if (order.IdOrder == Guid.Empty)
            {
                return BadRequest("Order Id is required");
            }

            var existingOrder = await _orderService.GetOrderByIdAsync(order.IdOrder);
            if (existingOrder == null)
            {
                return NotFound($"Order with id {order.IdOrder} not found.");
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            order.Updated = localTime;

            order.UpdatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _orderService.UpdateOrderAsync(order);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task DeletedOrderAsync(Guid id)
        {
            await _orderService.DeletedOrderAsync(id);
        }
    }
}
