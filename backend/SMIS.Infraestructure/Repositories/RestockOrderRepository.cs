using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;

using Microsoft.EntityFrameworkCore;

namespace SMIS.Infraestructure.Repositories
{
    public class RestockOrderRepository : IRestockOrderRepository
    {
        private readonly AppDbContext _context;
        public RestockOrderRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<RestockOrder>> GetAllAsync()
        {
            return await _context.RestockOrders.ToListAsync();
        }

        public async Task<RestockOrder?> GetByIdAsync(Guid id)
        {
            return await _context.RestockOrders.FindAsync(id);
        }

        public async Task AddAsync (RestockOrder restockOrder)
        {
            _context.RestockOrders.Add(restockOrder);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(RestockOrder restockOrder)
        {
            _context.RestockOrders.Add(restockOrder);
            await _context.SaveChangesAsync();
        }
    }
}
