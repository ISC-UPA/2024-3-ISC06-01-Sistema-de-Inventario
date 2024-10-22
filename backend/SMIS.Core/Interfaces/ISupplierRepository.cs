using SMIS.Core.Entities;

namespace SMIS.Core.Interfaces
{
    public interface ISupplierRepository
    {
        Task<IEnumerable<Supplier>> GetAllAsync();
        Task<Supplier> GetByIdAsync(Guid id);
        Task AddAsync(Supplier supplier);
        Task UpdateAsync(Supplier supplier);
        Task DeleteAsync(Guid id);
    }
}
