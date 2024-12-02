using Microsoft.EntityFrameworkCore;
using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;
using SMIS.Infraestructure.Repositories;

namespace SMIS.Application.Services
{
    public class RestockOrderService{

        private readonly IRestockOrderRepository _restockOrderRepository;
        private readonly AppDbContext _context;

        public RestockOrderService(IRestockOrderRepository restockOrderRepository, AppDbContext context)
        {
            _restockOrderRepository = restockOrderRepository;
            _context = context;
        }

        public async Task<IEnumerable<RestockOrder>> GetAllRestockOrdersAsync() {

            return await _context.RestockOrders.ToListAsync();
        }

        public async Task<RestockOrder?> GetRestockOrderByIdAsync(Guid id) {

            return await _context.RestockOrders.FindAsync(id);
        }

        public async Task AddRestockOrderAsync(RestockOrder restockOrder) {

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            restockOrder.Created = localTime; // Usar la hora local en lugar de UTC

            _context.RestockOrders.Add(restockOrder);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateRestockOrderAsync(RestockOrder restockOrder)
        {
            var trackedEntity = _context.RestockOrders.Local.FirstOrDefault(r => r.IdRestockOrder == restockOrder.IdRestockOrder);
            if (trackedEntity != null)
            {
                _context.Entry(trackedEntity).State = EntityState.Detached;
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            restockOrder.Updated = localTime;

            restockOrder.Created = trackedEntity.Created;
            restockOrder.CreatedBy = trackedEntity.CreatedBy;

            _context.RestockOrders.Update(restockOrder);
            await _context.SaveChangesAsync();
        }

        public async Task DeletedRestockOrderAsync(Guid id)
        {
            var restockOrder = await _context.RestockOrders.FindAsync(id);
            if (restockOrder != null)
            {
                restockOrder.Status = EnumRestockOrderStatus.Canceled;

                var utcNow = DateTime.UtcNow;
                var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
                var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
                restockOrder.Updated = localTime;

                _context.RestockOrders.Update(restockOrder);
                await _context.SaveChangesAsync();
            }
        }

    }
}
