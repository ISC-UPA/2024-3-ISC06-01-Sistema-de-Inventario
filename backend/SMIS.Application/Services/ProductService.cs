using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Repositories;

namespace SMIS.Application.Services
{
    public class ProductService{

        private readonly IProductRepository _productRepository;

        public ProductService(IProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        public async Task<IEnumerable<Product>> GetAllProductsAsync()
        { 
            return await _productRepository.GetAllAsync();
        }

        public async Task<Product> GetProductByIdAsync(Guid id)
        { 
            return await _productRepository.GetByIdAsync(id);
        }

        public async Task <Product> GetProductByParamsAsync(string? name, EnumProductCategory? category)
        {
            return await _productRepository.GetByParamsAsync(name, category);
        }

        public async Task AddProductAsync(Product product)
        { 
            await _productRepository.AddAsync(product);
        }

        public async Task UpdateProductAsync(Product product)
        { 
        await _productRepository.UpdateAsync(product);
        }


        public async Task DeletedProductAsync(Guid id)
        {

            await _productRepository.DeleteAsync(id);
        }
    }
}
