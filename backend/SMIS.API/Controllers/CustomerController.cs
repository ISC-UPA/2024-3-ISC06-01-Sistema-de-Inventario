using SMIS.Application.Services;
using SMIS.Core.Entities;
using Microsoft.AspNetCore.Mvc;
using SMIS.Application.DTOs;
using SMIS.Core.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace SMIS.API.Controllers
{

    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class CustomerController : ControllerBase
    {
        private readonly CustomerService _customerService;
        private readonly UserService _userService;

        public CustomerController(CustomerService customerService, UserService userService)
        {
            _customerService = customerService;
            _userService = userService;
        }

        [HttpGet]
        public async Task<IEnumerable<Customer>> GetAllCustomersAsync()
        {
            return await _customerService.GetAllCustomersAsync();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Customer>> GetCustomerByIdAsync(Guid id)
        {
            var customer = await _customerService.GetCustomerByIdAsync(id);
            if (customer == null)
            {
                return NotFound($"Customer with id {id} not found.");
            }
            return customer;
        }

        [HttpPost]
        public async Task<IActionResult> AddCustomerAsync([FromBody] CustomerRequest request)
        {
            var customer = request.Customer;
            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            customer.Created = localTime; // Set the Created property to local time

            customer.CreatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _customerService.AddCustomerAsync(customer);
            return Ok("Customer added successfully");
        }

        [HttpPut]
        public async Task<IActionResult> UpdateCustomerAsync([FromBody] CustomerRequest request)
        {
            var customer = request.Customer;

            if (customer.IdCustomer == Guid.Empty)
            {
                return BadRequest("Customer ID cannot be empty.");
            }

            var existingCustomer = await _customerService.GetCustomerByIdAsync(customer.IdCustomer);
            if (existingCustomer == null)
            {
                return NotFound($"Customer with id {customer.IdCustomer} not found.");
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            customer.Updated = localTime; // Set the Updated property to local time

            customer.UpdatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _customerService.UpdateCustomerAsync(customer);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletedCustomerAsync(Guid id)
        {
            var existingCustomer = await _customerService.GetCustomerByIdAsync(id);
            if (existingCustomer == null)
            {
                return NotFound($"Customer with id {id} not found.");
            }

            await _customerService.DeletedCustomerAsync(id);
            return NoContent();
        }
    }
}
