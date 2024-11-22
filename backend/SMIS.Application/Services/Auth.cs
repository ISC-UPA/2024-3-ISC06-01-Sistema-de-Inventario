using Microsoft.EntityFrameworkCore;
using SMIS.Application.Helpers;
using SMIS.Core.Entities;
using SMIS.Infraestructure.Data;
using System.Runtime.Versioning;

namespace SMIS.Application.Services
{
    public class Auth
    {
        private readonly AppDbContext _context;
        private readonly LdapService _ldapService;
        public Auth(AppDbContext context, LdapService ldapService)
        {
            _context = context;
            _ldapService = ldapService;
        }

        //public async Task<User> LogIn(String Email, String Password)
        //{
        //    var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == Email && u. == Password);

        //    if (user != null)
        //    {
        //        return user;
        //    }
        //    throw new InvalidOperationException("Login failed");
        //}

        [SupportedOSPlatform("windows")]
        public async Task<User?> ValidateUserAsync(String username, String password)
        {
            try
            {
                bool isValid = _ldapService.ValidateUser(username, password);
                if (isValid)
                {
                    var user = await _context.Users.FirstOrDefaultAsync(u => u.UserName == username);

                    if (user != null)
                    {
                        return user;
                    }
                    else{ return null; }
                }
                else { return null; }
            }
            catch(Exception ex)
            {
                throw new Exception(string.Format("Unexpected error occurred while validating user {0}", username), ex);
                return null;
            }
        }

    }
}
