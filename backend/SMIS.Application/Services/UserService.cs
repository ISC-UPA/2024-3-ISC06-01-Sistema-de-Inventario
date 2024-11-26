using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;
using SMIS.Infraestructure.Repositories;
using System.Security.Claims;

namespace SMIS.Application.Services
{
    public class UserService : IUserService
    {
        private readonly IHttpContextAccessor _httpContext;
        private readonly AppDbContext _context;

        public UserService(AppDbContext context, IHttpContextAccessor httpContext)
        {
            _context = context;
            _httpContext = httpContext;
        }

        public Guid GetCurrentUserId()
        {
            var userId = _httpContext.HttpContext?.User?.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;
            return userId != null ? Guid.Parse(userId) : Guid.Empty;
        }

        public async Task<User?> GetCurrentUserAsync()
        {
            var userId = GetCurrentUserId();
            return userId != Guid.Empty ? await _context.Users.FindAsync(userId) : null;
        }

        public async Task<IEnumerable<User>> GetAllUsersAsync()
        {
            return await _context.Users.Where(u => u.IsActive == true).ToListAsync();
        }

        public async Task<User?> GetUserByIdAsync(Guid id)
        {
            return await _context.Users.FindAsync(id);
        }

        public async Task AddUserAsync(User user)
        {
            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            user.Created = localTime; // Usar la hora local en lugar de UTC

            _context.Users.Add(user);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateUserAsync(User user)
        {
            // Buscar y eliminar cualquier instancia rastreada
            var trackedEntity = _context.Users.Local.FirstOrDefault(u => u.IdUser == user.IdUser);
            if (trackedEntity != null)
            {
                _context.Entry(trackedEntity).State = EntityState.Detached;
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            user.Updated = localTime;

            _context.Users.Update(user);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteUserAsync(Guid id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user != null)
            {
                user.IsActive = false;
                var utcNow = DateTime.UtcNow;
                var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
                var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
                user.Updated = localTime;

                _context.Users.Update(user);
                await _context.SaveChangesAsync();
            }
        }
    }
}
