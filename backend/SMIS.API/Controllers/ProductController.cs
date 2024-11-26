using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;

namespace SMIS.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductController : ControllerBase
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
        public async Task<ActionResult<Product>> GetProductByIdAsync(Guid id)
        {
            var product = await _productService.GetProductByIdAsync(id);
            if (product == null)
            {
                return NotFound($"Product with id {id} not found.");
            }
            return product;
        }

        [HttpPost]
        public async Task<IActionResult> AddProductAsync(Product product)
        {
            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            product.Created = localTime; // Usar la hora local en lugar de UTC

            await _productService.AddProductAsync(product);
            return CreatedAtAction(nameof(GetProductByIdAsync), new { id = product.IdProduct }, product);
        }

        [HttpPut]
        public async Task<IActionResult> UpdateProduct([FromBody] Product product)
        {
            if (product.IdProduct == Guid.Empty)
            {
                return BadRequest("Product ID cannot be empty.");
            }

            var existingProduct = await _productService.GetProductByIdAsync(product.IdProduct);
            if (existingProduct == null)
            {
                return NotFound($"Product with id {product.IdProduct} not found.");
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            product.Updated = localTime;

            await _productService.UpdateProductAsync(product);
            return NoContent();
        }



        [HttpDelete]
        public async Task DeletedProductAsync(Guid id)
        {
            await _productService.DeletedProductAsync(id);
        }
    }
}
