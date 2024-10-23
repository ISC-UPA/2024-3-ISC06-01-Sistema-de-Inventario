using SMIS.Core.Entities;

namespace SMIS.Core.Interfaces
{
    public interface IProductRepository {

        Task<IEnumerable<Product>> GetAllAsync();
        Task<Product> GetByIdAsync(Guid id);
        Task<Product> GetByParamsAsync(string? name, EnumProductCategory? Category);
        Task AddAsync(Product product);
        Task UpdateAsync(Product product);
        Task DeleteAsync(Guid id);
    }
}
