using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;

using Microsoft.EntityFrameworkCore;

namespace SMIS.Infraestructure.Repositories
{
    public class SupplierRepository : ISupplierRepository
    {
        private readonly AppDbContext _context;
        private readonly IUserService _userService;
        public SupplierRepository(AppDbContext context, IUserService userService)
        {
            _context = context;
            _userService = userService;
        }

        public async Task<IEnumerable<Supplier>> GetAllAsync()
        {
            return await _context.Suppliers.ToListAsync();
        }

        public async Task<Supplier?> GetByIdAsync(Guid id)
        {
            return await _context.Suppliers.FindAsync(id) ?? throw new InvalidOperationException("Supplier Not Found");
        }

        public async Task AddAsync(Supplier supplier)
        {
            var newSupplier = supplier;
            newSupplier.Created = DateTime.UtcNow;
            newSupplier.CreatedBy = _userService.GetCurrentUserId();

            _context.Suppliers.Add(supplier);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Supplier supplier)
        {
            var existingSupplier = await _context.Suppliers.FindAsync(supplier.IdSupplier);
            if (existingSupplier != null)
            {

                existingSupplier = supplier;
                existingSupplier.Update = DateTime.UtcNow;
                existingSupplier.UpdateBy = _userService.GetCurrentUserId();

                _context.Suppliers.Update(supplier);
                await _context.SaveChangesAsync();
            }
            else
            {

                throw new InvalidOperationException("Supplier Not Found");


            }
        }

        public async Task DeleteAsync(Guid id)
        {

            var deletedSupplier = await _context.Suppliers.FindAsync(id);
            if (deletedSupplier != null)
            {
                _context.Suppliers.Remove(deletedSupplier);
                await _context.SaveChangesAsync();
            }
            else
            {
                throw new InvalidOperationException("Supplier not found");
            }
        }

    }
}
