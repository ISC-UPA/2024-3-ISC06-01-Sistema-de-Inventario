using SMIS.Core.Entities;

namespace SMIS.Core.Interfaces
{
    public interface IUserService
    {
        Guid GetCurrentUserId();

        Task<User?> GetCurrentUserAsync();

        Task<IEnumerable<User>> GetAllUsersAsync(); 

        Task<User?> GetUserByIdAsync(Guid id);

        Task AddUserAsync(User user);

        Task UpdateUserAsync(User user);

        Task DeleteUserAsync(Guid id);
    }
}
