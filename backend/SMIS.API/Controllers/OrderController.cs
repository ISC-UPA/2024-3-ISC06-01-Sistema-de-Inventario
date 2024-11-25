using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;

namespace SMIS.API.Controllers{
    [ApiController]
    [Route("api/[controller]")]

    public class OrderController
    {

        private readonly OrderService _orderService;
        public OrderController(OrderService orderService)
        {
            _orderService = orderService;
        }

        [HttpGet]
        public async Task<IEnumerable<Order>> GetAllOrdersAsync()
        {
            return await _orderService.GetAllOrdersAsync();
        }

        [HttpGet("{id}")]
        public async Task<Order?> GetOrderByIdAsync(Guid id)
        {
            return await _orderService.GetOrderByIdAsync(id);
        }


        [HttpPost]
        public async Task AddOrder(Order order)
        {
            await _orderService.AddOrderAsync(order);
        }

        [HttpPut]
        public async Task UpdateOrder(Order order)
        {
            await _orderService.UpdateOrderAsync(order);
        }

        [HttpDelete]
        public async Task DeletedOrderAsync(Guid id)
        {
            await _orderService.DeletedOrderAsync(id);
        }
    }
}
