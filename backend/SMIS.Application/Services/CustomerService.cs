using Microsoft.EntityFrameworkCore;
using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;

namespace SMIS.Application.Services
{
    public class CustomerService
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly AppDbContext _context;

        public CustomerService(ICustomerRepository customerRepository, AppDbContext context)
        {
            _customerRepository = customerRepository;
            _context = context;
        }

        public async Task<IEnumerable<Customer>> GetAllCustomersAsync()
        {
            return await _context.Customers.Where(c => c.IsActive == true).ToListAsync();
        }

        public async Task<Customer?> GetCustomerByIdAsync(Guid id)
        {
            return await _context.Customers.FindAsync(id);
        }

        public async Task AddCustomerAsync(Customer customer)
        {
            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            customer.Created = localTime; // Set Created to local time

            _context.Customers.Add(customer);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateCustomerAsync(Customer customer)
        {
            // Detach tracked entity if it exists to avoid conflicts
            var trackedEntity = _context.Customers.Local.FirstOrDefault(c => c.IdCustomer == customer.IdCustomer);
            if (trackedEntity != null)
            {
                _context.Entry(trackedEntity).State = EntityState.Detached;
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            customer.Updated = localTime; // Set Updated to local time

            customer.Created = trackedEntity.Created;
            customer.CreatedBy = trackedEntity.CreatedBy;

            _context.Customers.Update(customer);
            await _context.SaveChangesAsync();
        }

        public async Task DeletedCustomerAsync(Guid id)
        {
            var customer = await _context.Customers.FindAsync(id);
            if (customer != null)
            {
                customer.IsActive = false;

                var utcNow = DateTime.UtcNow;
                var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
                var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
                customer.Updated = localTime;

                _context.Customers.Update(customer);
                await _context.SaveChangesAsync();
            }
        }
    }
}
