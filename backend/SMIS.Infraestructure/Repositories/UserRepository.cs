using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;

using Microsoft.EntityFrameworkCore;

namespace SMIS.Infraestructure.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly AppDbContext _context;
        private readonly IUserService _userService;
        public UserRepository(AppDbContext context, IUserService userService)
        {
            _context = context;
            _userService = userService;
        }

        public async Task<IEnumerable<User>> GetAllAsync()
        {
            return await _context.Users.ToListAsync();
        }
       
        public async Task<User> GetByIdAsync(Guid id)
        {
            return await _context.Users.FindAsync(id) ?? throw new InvalidOperationException("User Not Found");
        }

        public async Task AddAsync(User user)
        {
            var newUser = user;
            newUser.Created = DateTime.UtcNow;
            newUser.CreatedBy = _userService.GetCurrentUserId();

            _context.Users.Add(user);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(User user)
        {

            var existingUser = await _context.Users.FindAsync(user.IdUser);
            if (existingUser != null)
            {
                existingUser = user;
                existingUser.Updated = DateTime.UtcNow;
                existingUser.UpdatedBy = _userService.GetCurrentUserId();

                _context.Users.Update(user);
                await _context.SaveChangesAsync();
            }
            else
            {
                throw new InvalidOperationException("User Not Found");
            }
        }

        public async Task DeleteAsync(Guid id)
        {

            var deletedUser = await _context.Users.FindAsync(id);
            if (deletedUser != null)
            {
                _context.Users.Remove(deletedUser);
                await _context.SaveChangesAsync();
            }
            else
            {
                throw new InvalidOperationException("User not found");
            }
        }
    }
}
