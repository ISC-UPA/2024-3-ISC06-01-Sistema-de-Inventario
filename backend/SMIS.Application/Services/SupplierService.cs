using SMIS.Core.Entities;
using SMIS.Core.Interfaces;

namespace SMIS.Application.Services
{
    public class SupplierService{

        private readonly ISupplierRepository _supplierRepository;

        public SupplierService(ISupplierRepository supplierRepository){
        
            _supplierRepository = supplierRepository;
        }

        public async Task<IEnumerable<Supplier>> GetAllSuppliersAsync() { 
        
            return await _supplierRepository.GetAllAsync();
        
        }

        public async Task<Supplier?> GetSupplierByIdAsync(Guid id)
        {

            return await _supplierRepository.GetByIdAsync(id);
        }

        public async Task AddSupplierAsync(Supplier supplier)
        {

            await _supplierRepository.AddAsync(supplier);
        }

        public async Task UpdateSupplierAsync(Supplier supplier)
        {
            await _supplierRepository.UpdateAsync(supplier);
        }

    }
}
