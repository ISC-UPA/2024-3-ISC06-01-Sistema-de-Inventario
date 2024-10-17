using SMIS.Core.Entities;

namespace SMIS.Core.Interfaces
{
    public interface IUserRepository{
        Task<IEnumerable<User>> GetAllAsync();
        Task<User> GetByIdAsync(Guid id);
        Task AddAsync(User user);
        Task UpdateAsync(User user);
    }
}
