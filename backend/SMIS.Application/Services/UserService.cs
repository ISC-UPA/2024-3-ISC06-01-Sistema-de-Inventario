using SMIS.Core.Entities;
using SMIS.Core.Interfaces;

namespace SMIS.Application.Services
{
    public class UserService{

        private readonly IUserRepository _userRepository;

        public async Task<IEnumerable<User>> GetAllUserAsync() { 
        
            return await _userRepository.GetAllAsync();   

        }

        public async Task<User> GetByIdUserAsync(Guid id) { 
        
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

    }
}
