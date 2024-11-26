using Microsoft.EntityFrameworkCore;
using SMIS.Core.Entities;
using SMIS.Infraestructure.Data;

namespace SMIS.Application.Services
{
    public class Auth
    {
        private readonly AppDbContext _context;
        public Auth(AppDbContext context)
        {
            _context = context;
        }

        public async Task<User> LogIn(String Email, String Password)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == Email);

            if (user != null)
            {
                return user;
            }
            throw new InvalidOperationException("Login failed");
        }

    }
}
