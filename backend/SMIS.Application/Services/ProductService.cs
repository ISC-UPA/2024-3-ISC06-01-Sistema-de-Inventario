using SMIS.Core.Entities;
using SMIS.Core.Interfaces;

namespace SMIS.Application.Services
{
    public class ProductService{

        private readonly IProductRepository _productRepository;

        public ProductService(IProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        public async Task<IEnumerable<Product>> GetAllProductsAsync() { 
        
            return await _productRepository.GetAllAsync();
        
        }

        public async Task<Product> GetProductByIdAsync(Guid id) { 
        
            return await _productRepository.GetByIdAsync(id);
        }

        public async Task <Product> GetProductByParamsAsync(Guid? id, string? name, EnumProductCategory? category){
        
            return await _productRepository.GetByParamsAsync(id, name, category);

        }

        public async Task AddProductAsync(Product product) { 
        
       
            await _productRepository.AddAsync(product);
        }

        public async Task UpdateProductAsync(Product product) { 
        
        await _productRepository.UpdateAsync(product);
        
        }


    }
}
