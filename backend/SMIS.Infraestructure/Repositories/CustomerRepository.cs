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
            //Need to fix ------------------------------------------------------------------------------------------------------!!! 
            //var newCustomer = customer;
            //newCustomer.Created = DateTime.Now;
            //newCustomer.CreatedByUser = _userService.GetCurrentUserId();


            _context.Customers.Add(customer);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Customer customer)
        {
            _context.Customers.Update(customer);
            await _context.SaveChangesAsync();
        }
    }
}
