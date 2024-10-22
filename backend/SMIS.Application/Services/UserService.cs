using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;

using Microsoft.AspNetCore.Http;
using System.Security.Claims;
using SMIS.Infraestructure.Repositories;

namespace SMIS.Application.Services
{
    public class UserService: IUserService
    {

        private readonly IUserRepository _userRepository;
        private readonly IHttpContextAccessor _httpContext;
        private readonly AppDbContext _context;

        public UserService(IUserRepository userRepository, IHttpContextAccessor httpContext)
        {
            _userRepository = userRepository;
            _httpContext = httpContext;
        }


        public async Task<IEnumerable<User>> GetAllUsersAsync() { 
        
            return await _userRepository.GetAllAsync();   

        }

        public async Task<User> GetUserByIdAsync(Guid id) { 
        
            return await _userRepository.GetByIdAsync(id);

        }

        public async Task AddUserAsync(User user)
        {

            await _userRepository.AddAsync(user);
        }

        public async Task UpdateUserAsync(User user)
        {
            await _userRepository.UpdateAsync(user);
        }

        public async Task DeletedCustomerAsync(Guid id)
        {

            await _userRepository.DeleteAsync(id);
        }


        //User service Methods
        public Guid GetCurrentUserId()
        {
            var userId = _httpContext.HttpContext?.User?.Claims.FirstOrDefault(u => u.Type == ClaimTypes.NameIdentifier)?.Value;
            return userId != null ? Guid.Parse(userId) : Guid.Empty;
        }

        public async Task<User?> GetCurrentUserAsync()
        {
            var userId = GetCurrentUserId();
            return userId != Guid.Empty ? await _context.Users.FindAsync(userId) : null;
        }

        public async Task DeleteUserAsync(Guid id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user != null)
            {
                _context.Users.Remove(user);
                await _context.SaveChangesAsync();
            }
        }
    }
}
