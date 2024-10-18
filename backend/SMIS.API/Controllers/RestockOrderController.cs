using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;

namespace SMIS.API.Controllers
{
        [ApiController]
        [Route("api/[controller]")]

    public class RestockOrderController
    {
        private readonly RestockOrderService _restockOrderService;
        public RestockOrderController(RestockOrderService restockOrderService)
        {
            _restockOrderService = restockOrderService;
        }

        [HttpGet]
        public async Task<IEnumerable<RestockOrder>> GetAllRestockOrdersAsync()
        {
            return await _restockOrderService.GetAllRestockOrdersAsync();
        }

        [HttpGet("{id}")]
        public async Task<RestockOrder> GetRestockOrderByIdAsync(Guid id)
        {
            return await _restockOrderService.GetRestockOrderByIdAsync(id);
        }

        [HttpPost]
        public async Task AddRestockOrderAsync(RestockOrder restockOrder)
        {
            await _restockOrderService.AddRestockOrderAsync(restockOrder);
        }

        [HttpPut]
        public async Task UpdateRestockOrderAsync(RestockOrder restockOrder)
        {
            await _restockOrderService.UpdateRestockOrderAsync(restockOrder);
        }
    }
}
