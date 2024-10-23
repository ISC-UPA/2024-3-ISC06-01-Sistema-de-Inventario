using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;

using Microsoft.EntityFrameworkCore;

namespace SMIS.Infraestructure.Repositories
{
    public class OrderRepository : IOrderRepository
    {
        private readonly AppDbContext _context;
        private readonly IUserService _userService;
        public OrderRepository(AppDbContext context, IUserService userService)
        {
            _context = context;
            _userService = userService;
        }

        public async Task<IEnumerable<Order>> GetAllAsync()
        {
            return await _context.Orders.ToListAsync();
        }

        public async Task<Order> GetByIdAsync(Guid id)
        {
            return await _context.Orders.FindAsync(id) ?? throw new InvalidOperationException("Order Not Found");
        }

        public async Task AddAsync(Order order)
        {
            var newOrder = order;
            newOrder.Created = DateTime.UtcNow;
            newOrder.CreatedBy = _userService.GetCurrentUserId();

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Order order)
        {
            var existingOrder = await _context.Orders.FindAsync(order.IdOrder);
            if (existingOrder != null)
            {

                existingOrder = order;
                existingOrder.Updated = DateTime.UtcNow;
                existingOrder.UpdatedBy = _userService.GetCurrentUserId();

                _context.Orders.Update(order);
                await _context.SaveChangesAsync();
            }
            else{

                throw new InvalidOperationException("Order Not Found");
            } 

        }

        public async Task DeleteAsync(Guid id)
        {

            var deletedOrder = await _context.Orders.FindAsync(id);
            if (deletedOrder != null)
            {
                _context.Orders.Remove(deletedOrder);
                await _context.SaveChangesAsync();
            }
            else
            {
                throw new InvalidOperationException("Order not found");
            }
        }

    }
}
