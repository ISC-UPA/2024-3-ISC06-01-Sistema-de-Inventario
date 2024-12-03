using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;

using Microsoft.EntityFrameworkCore;

namespace SMIS.Infraestructure.Repositories
{
    public class ProductRepository : IProductRepository
    {
        private readonly AppDbContext _context;
        private readonly IUserService _userService;
        public ProductRepository(AppDbContext context, IUserService userService)
        {
            _context = context;
            _userService = userService;
        }

        public async Task<IEnumerable<Product>> GetAllAsync()
        {
            return await _context.Products.ToListAsync();
        }
        public async Task<Product> GetByIdAsync(Guid id)
        {
            return await _context.Products.FindAsync(id) ?? throw new InvalidOperationException("Product Not Found");
        }

        public async Task AddAsync(Product product)
        {
            var newProduct = product;
            newProduct.Created = DateTime.UtcNow;
            newProduct.CreatedBy = _userService.GetCurrentUserId();
            _context.Products.Add(product);

            _context.Products.Add(product);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Product product)
        {
            var existingProduct = await _context.Products.FindAsync(product.IdProduct);
            if (existingProduct != null)
            {

                existingProduct = product;
                existingProduct.Updated = DateTime.UtcNow;
                existingProduct.UpdatedBy = _userService.GetCurrentUserId();

                _context.Products.Update(product);
                await _context.SaveChangesAsync();
            }
            else
            {

                throw new InvalidOperationException("Product Not Found");


            }
        }

        public async Task DeleteAsync(Guid id)
        {

            var deletedProduct = await _context.Products.FindAsync(id);
            if (deletedProduct != null)
            {
                _context.Products.Remove(deletedProduct);
                await _context.SaveChangesAsync();
            }
            else
            {
                throw new InvalidOperationException("Product not found");
            }
        }

    }
}
