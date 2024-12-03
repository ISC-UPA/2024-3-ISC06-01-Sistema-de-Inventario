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

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            order.Created = localTime; // Set Created to local time

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateOrderAsync(Order order) {

            // Detach tracked entity if it exists to avoid conflicts
            var trackedEntity = _context.Orders.Local.FirstOrDefault(o => o.IdOrder == order.IdOrder);
            if (trackedEntity != null)
            {
                _context.Entry(trackedEntity).State = EntityState.Detached;
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            order.Updated = localTime; // Set Updated to local time

            order.Created = trackedEntity.Created;
            order.CreatedBy = trackedEntity.CreatedBy;

            _context.Orders.Update(order);
            await _context.SaveChangesAsync();
        }

        public async Task DeletedOrderAsync(Guid id)
        {
            var order = await _context.Orders.FindAsync(id);
            if (order != null)
            {
                order.Status = EnumOrderStatus.Closed;
                
                var utcNow = DateTime.UtcNow;
                var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
                var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
                order.Updated = localTime;

                _context.Orders.Update(order);
                await _context.SaveChangesAsync();
            }
        }
    }
}