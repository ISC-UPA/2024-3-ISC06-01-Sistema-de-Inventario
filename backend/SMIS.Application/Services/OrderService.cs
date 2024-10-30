using Microsoft.EntityFrameworkCore;
using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;
using SMIS.Infraestructure.Repositories;


namespace SMIS.Application.Services
{
    public class OrderService
    {

        private readonly IOrderRepository _orderRepository;
        private readonly AppDbContext _context;

        public OrderService(IOrderRepository orderRepository, AppDbContext context)
        {
            _orderRepository = orderRepository;
            _context = context;
        }

        public async Task<IEnumerable<Order>> GetAllOrdersAsync()
        {

            return await _context.Orders.ToListAsync();
        }

        public async Task<Order?> GetOrderByIdAsync(Guid id) {

            return await _context.Orders.FindAsync(id);
        }

        public async Task AddOrderAsync(Order order) {

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateOrderAsync(Order order) {
            _context.Orders.Update(order);
            await _context.SaveChangesAsync();
        }

        public async Task DeletedOrderAsync(Guid id)
        {
            var order = await _context.Orders.FindAsync(id);
            if (order != null)
            {
                _context.Orders.Remove(order);
                await _context.SaveChangesAsync();
            }
        }
    }
}