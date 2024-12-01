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
    public class SupplierController : ControllerBase
    {
        private readonly SupplierService _supplierService;
        private readonly UserService _userService;
        public SupplierController(SupplierService supplierService, UserService userService)
        {
            _supplierService = supplierService;
            _userService = userService;
        }

        [HttpGet]
        public async Task<IEnumerable<Supplier>> GetAllSuppliersAsync()
        {
            return await _supplierService.GetAllSuppliersAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Supplier?>> GetSupplierByIdAsync(Guid id)
        {
            var supplier = await _supplierService.GetSupplierByIdAsync(id);
            if (supplier == null)
            {
                return NotFound($"Supplier with id {id} not found.");
            }
            return supplier;
        }

        [HttpPost]
        public async Task<IActionResult> AddSupplierAsync([FromBody] SupplierRequest request)
        {
            var supplier = request.Supplier;
            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            supplier.Created = localTime; // Usar la hora local en lugar de UTC

            supplier.CreatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _supplierService.AddSupplierAsync(supplier);

            return Ok("Supplier added successfully");
        }

        [HttpPut]
        public async Task<IActionResult> UpdateSupplierAsync([FromBody] SupplierRequest request)
        {
            var supplier = request.Supplier;
            if (supplier.IdSupplier == Guid.Empty)
            {
                return BadRequest("Supplier Id is required");
            }

            var existingSupplier = await _supplierService.GetSupplierByIdAsync(supplier.IdSupplier);
            if (existingSupplier == null)
            {
                return NotFound($"Supplier with id {supplier.IdSupplier} not found.");
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            supplier.Updated = localTime;

            supplier.UpdatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _supplierService.UpdateSupplierAsync(supplier);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task DeletedSupplierAsync(Guid id)
        {
            await _supplierService.DeletedSupplierAsync(id);
        }
    }
}
