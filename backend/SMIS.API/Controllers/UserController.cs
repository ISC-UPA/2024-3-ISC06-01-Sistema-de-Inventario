using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;


namespace SMIS.API.Controllers
{
        [ApiController]
        [Route("api/[controller]")]

    public class UserController : ControllerBase
    {
        private readonly UserService _userService;

        public UserController(UserService userService)
        {
            _userService = userService;
        }

        [HttpGet]
        public async Task<IEnumerable<User>> GetAllUsersAsync()
        {
            return await _userService.GetAllUsersAsync();
        }

        [HttpGet("{id}")]
        public async Task<User> GetUserById(int id)
        {
            return await _userService.GetUserByIdAsync(id);
        }

        [HttpPost]
        public async Task AddUserAsync(User user)
        {
            await _userService.AddUserAsync(user);
        }

        [HttpPut]
        public async Task UpdateUserAsync(User user)
        {
            await _userService.UpdateUserAsync(user);
        }
    }
}
