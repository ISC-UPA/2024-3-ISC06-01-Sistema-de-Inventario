using Microsoft.EntityFrameworkCore;
using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;
using SMIS.Infraestructure.Repositories;

namespace SMIS.Application.Services
{
    public class ProductService{

        private readonly IProductRepository _productRepository;
        private readonly AppDbContext _context;

        public ProductService(IProductRepository productRepository, AppDbContext context)
        {
            _productRepository = productRepository;
            _context = context;
        }

        public async Task<IEnumerable<Product>> GetAllProductsAsync()
        {
            return await _context.Products.Where(p => p.IsActive == true).ToListAsync();
        }

        public async Task<Product?> GetProductByIdAsync(Guid id)
        {
            return await _context.Products.FindAsync(id);
        }

        public async Task AddProductAsync(Product product)
        {
            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            product.Created = localTime; // Usar la hora local en lugar de UTC

            _context.Products.Add(product);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateProductAsync(Product product)
        {
            // Buscar y eliminar cualquier instancia rastreada
            var trackedEntity = _context.Products.Local.FirstOrDefault(p => p.IdProduct == product.IdProduct);
            if (trackedEntity != null)
            {
                _context.Entry(trackedEntity).State = EntityState.Detached;
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            product.Updated = localTime;
            _context.Products.Update(product);
            await _context.SaveChangesAsync();
        }



        public async Task DeletedProductAsync(Guid id)
        {
            var product = await _context.Products.FindAsync(id);
            if (product != null)
            {
                product.IsActive = false;

                var utcNow = DateTime.UtcNow;
                var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
                var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
                product.Updated = localTime;

                _context.Products.Update(product);
                await _context.SaveChangesAsync();
            }
        }
    }
}
