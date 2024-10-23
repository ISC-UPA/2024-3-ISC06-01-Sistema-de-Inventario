using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;

using Microsoft.EntityFrameworkCore;

namespace SMIS.Infraestructure.Repositories
{
    public class CustomerRepository : ICustomerRepository
    {
        private readonly AppDbContext _context;
        private readonly IUserService _userService;
        public CustomerRepository(AppDbContext context, IUserService userService)
        {
            _context = context;
            _userService = userService;
        }

        public async Task<IEnumerable<Customer>> GetAllAsync()
        {
            return await _context.Customers.ToListAsync();
        }

        public async Task<Customer> GetByIdAsync(Guid id)
        {
            return await _context.Customers.FindAsync(id) ?? throw new InvalidOperationException("Customer not found");
        }

        public async Task AddAsync(Customer customer)
        {
            var newCustomer = customer;
            newCustomer.Created = DateTime.UtcNow;
            newCustomer.CreatedBy = _userService.GetCurrentUserId();
            _context.Customers.Add(newCustomer);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Customer customer)
        {
            var existingCustomer = await _context.Customers.FindAsync(customer.IdCustomer);
            if (existingCustomer != null)
            {
                existingCustomer = customer;
                existingCustomer.Update = DateTime.UtcNow;
                existingCustomer.UpdatedBy = _userService.GetCurrentUserId();

                _context.Customers.Update(existingCustomer);
                await _context.SaveChangesAsync();
            }else
            {
                throw new InvalidOperationException("Customer not found");
            }
        }

        public async Task DeleteAsync(Guid id) {

            var deletedCustomer = await _context.Customers.FindAsync(id);
            if (deletedCustomer != null)
            {
                _context.Customers.Remove(deletedCustomer);
                await _context.SaveChangesAsync();
            }
            else
            {
                throw new InvalidOperationException("Customer not found");
            }
        }
    }
}
