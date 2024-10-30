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

            _context.RestockOrders.Add(restockOrder);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateRestockOrderAsync(RestockOrder restockOrder)
        {
            _context.RestockOrders.Update(restockOrder);
            await _context.SaveChangesAsync();
        }

        public async Task DeletedRestockOrderAsync(Guid id)
        {
            var restockOrder = await _context.RestockOrders.FindAsync(id);
            if (restockOrder != null)
            {
                _context.RestockOrders.Remove(restockOrder);
                await _context.SaveChangesAsync();
            }
        }

    }
}
