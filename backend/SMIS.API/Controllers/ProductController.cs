using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;
using SMIS.Application.DTOs;

namespace SMIS.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductController : ControllerBase
    {
        private readonly ProductService _productService;
        private readonly UserService _userService;
        public ProductController(ProductService productService, UserService userService)
        {
            _productService = productService;
            _userService = userService;
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
        public async Task<IActionResult> AddProductAsync([FromBody] ProductRequest request)
        {
            var product = request.Product;

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            product.Created = localTime; // Usar la hora local en lugar de UTC

            product.CreatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _productService.AddProductAsync(product);
            return Ok("Product added successfully");
        }

        [HttpPut]
        public async Task<IActionResult> UpdateProduct([FromBody] ProductRequest request)
        {
            var product = request.Product;

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

            product.UpdatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _productService.UpdateProductAsync(product);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task DeletedProductAsync(Guid id)
        {
            await _productService.DeletedProductAsync(id);
        }
    }
}
