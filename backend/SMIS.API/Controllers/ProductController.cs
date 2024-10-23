using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;

namespace SMIS.API.Controllers
{
        [ApiController]
        [Route("api/[controller]")]

    public class ProductController
    {
        private readonly ProductService _productService;
        public ProductController(ProductService productService)
        {
            _productService = productService;
        }

        [HttpGet]
        public async Task<IEnumerable<Product>> GetAllProductsAsync()
        {
            return await _productService.GetAllProductsAsync();
        }

        [HttpGet("{id}")]
        public async Task<Product> GetProductByIdAsync(Guid id)
        {
            return await _productService.GetProductByIdAsync(id);
        }

        [HttpGet("{name},{category}")]
        public async Task<Product> GetProductByParams(string? name, EnumProductCategory? category)
        {
            return await _productService.GetProductByParamsAsync(name, category);
        }

        [HttpPost]
        public async Task AddProductAsync(Product product)
        {
            await _productService.AddProductAsync(product);
        }

        [HttpPut]
        public async Task UpdateProduct(Product product)
        {
            await _productService.UpdateProductAsync(product);
        }

        [HttpDelete]
        public async Task DeletedProductAsync(Guid id)
        {
            await _productService.DeletedProductAsync(id);
        }
    }
}
