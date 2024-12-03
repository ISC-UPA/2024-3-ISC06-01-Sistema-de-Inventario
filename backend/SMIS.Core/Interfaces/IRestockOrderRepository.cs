using SMIS.Core.Entities;

namespace SMIS.Core.Interfaces
{
    public interface IRestockOrderRepository
    {
        Task<IEnumerable<RestockOrder>> GetAllAsync();
        Task<RestockOrder> GetByIdAsync(Guid id);
        Task AddAsync (RestockOrder restockOrder);
        Task UpdateAsync (RestockOrder restockOrder);
        Task DeleteAsync(Guid id);
    }
}
