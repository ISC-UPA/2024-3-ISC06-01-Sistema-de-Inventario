using Microsoft.EntityFrameworkCore;
using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;
using SMIS.Infraestructure.Repositories;

namespace SMIS.Application.Services
{
    public class SupplierService{

        private readonly ISupplierRepository _supplierRepository;
        private readonly AppDbContext _context;

        public SupplierService(ISupplierRepository supplierRepository, AppDbContext context)
        {
            _supplierRepository = supplierRepository;
            _context = context;
        }

        public async Task<IEnumerable<Supplier>> GetAllSuppliersAsync() {

            return await _context.Suppliers.Where(s => s.IsActive == true).ToListAsync();
        }

        public async Task<Supplier?> GetSupplierByIdAsync(Guid id)
        {
            return await _context.Suppliers.FindAsync(id);
        }

        public async Task AddSupplierAsync(Supplier supplier)
        {
            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            supplier.Created = localTime;

            _context.Suppliers.Add(supplier);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateSupplierAsync(Supplier supplier)
        {
            var trackedEntity = _context.Suppliers.Local.FirstOrDefault(s => s.IdSupplier == supplier.IdSupplier);
            if (trackedEntity != null)
            {
                _context.Entry(trackedEntity).State = EntityState.Detached;
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            supplier.Updated = localTime;

            supplier.Created = trackedEntity.Created;
            supplier.CreatedBy = trackedEntity.CreatedBy;

            _context.Suppliers.Update(supplier);
            await _context.SaveChangesAsync();
        }

        public async Task DeletedSupplierAsync(Guid id)
        {
            var supplier = await _context.Suppliers.FindAsync(id);
            if (supplier != null)
            {
                supplier.IsActive = false;
                var utcNow = DateTime.UtcNow;
                var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
                var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
                supplier.Updated = localTime;

                _context.Suppliers.Update(supplier);
                await _context.SaveChangesAsync();
            }
        }
    }
}
