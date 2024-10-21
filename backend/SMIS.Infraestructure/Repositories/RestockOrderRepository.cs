using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;

using Microsoft.EntityFrameworkCore;

namespace SMIS.Infraestructure.Repositories
{
    public class RestockOrderRepository : IRestockOrderRepository
    {
        private readonly AppDbContext _context;
        private readonly IUserService _userService;
        public RestockOrderRepository(AppDbContext context, IUserService userService)
        {
            _context = context;
            _userService = userService;
        }

        public async Task<IEnumerable<RestockOrder>> GetAllAsync()
        {
            return await _context.RestockOrders.ToListAsync();
        }

        public async Task<RestockOrder?> GetByIdAsync(Guid id)
        {
            return await _context.RestockOrders.FindAsync(id) ?? throw new InvalidOperationException("RestockOrder Not Found"); 
        }

        public async Task AddAsync (RestockOrder restockOrder)
        {
            var newRestockOrder = restockOrder;
            newRestockOrder.Created = DateTime.UtcNow;
            newRestockOrder.CreatedBy = _userService.GetCurrentUserId();

            _context.RestockOrders.Add(restockOrder);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(RestockOrder restockOrder)
        {
            var existingRestockOrder = await _context.RestockOrders.FindAsync(restockOrder.IdRestockOrder);
            if (existingRestockOrder != null)
            {

                existingRestockOrder = restockOrder;
                existingRestockOrder.Updated = DateTime.UtcNow;
                existingRestockOrder.UpdatedBy = _userService.GetCurrentUserId();

                _context.RestockOrders.Update(restockOrder);
                await _context.SaveChangesAsync();
            }
            else
            {

                throw new InvalidOperationException("RestockOrder Not Found");


            }
        }
    }
}
