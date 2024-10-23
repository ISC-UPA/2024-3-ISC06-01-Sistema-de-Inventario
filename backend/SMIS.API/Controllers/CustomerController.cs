using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;

namespace SMIS.API.Controllers
{
        [ApiController]
        [Route("api/[controller]")]

    public class CustomerController : ControllerBase
    {
        private readonly CustomerService _customerService;

        public CustomerController(CustomerService customerService)
        {
            _customerService = customerService;
        }

        [HttpGet]
        public async Task<IEnumerable<Customer>> GetAllCustomersAsync()
        {
            return await _customerService.GetAllCustomersAsync();
        }

        [HttpGet("{id}")]
        public async Task<Customer> GetCustomerById(Guid id)
        {
            return await _customerService.GetCustomerByIdAsync(id);
        }

        [HttpPost]
        public async Task AddCustomerAsync(Customer customer)
        {
            await _customerService.AddCustomerAsync(customer);
        }

        [HttpPut]
        public async Task UpdateCustomerAsync(Customer customer)
        {
            await _customerService.UpdateCustomerAsync(customer);
        }

        [HttpDelete]
        public async Task DeletedCustomerAsync(Guid id)
        {
            await _customerService.DeletedCustomerAsync(id);
        }
    }
}
