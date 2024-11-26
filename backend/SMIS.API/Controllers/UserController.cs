using SMIS.Application.DTOs;
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
        public async Task<ActionResult<User?>> GetUserByIdAsync(Guid id)
        {
            var user = await _userService.GetUserByIdAsync(id);
            if (user == null)
            {
                return NotFound($"User with id {id} not found.");
            }
            return user;
        }

        [HttpPost]
        public async Task<IActionResult> AddUserAsync([FromBody] UserRequest request)
        {
            var user = request.User;
            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);

            Console.WriteLine($"UTC Time: {utcNow}, Local Time: {localTime}");

            user.Created = localTime; // Usar la hora local en lugar de UTC

            user.CreatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _userService.AddUserAsync(user);

            return Ok("User added successfully");
        }

        [HttpPut]
        public async Task<IActionResult> UpdateUser([FromBody] UserRequest request)
        {
            var user = request.User;
            if (user.IdUser == Guid.Empty)
            {
                return BadRequest("User ID cannot be empty.");
            }

            var existingUser = await _userService.GetUserByIdAsync(user.IdUser);
            if (existingUser == null)
            {
                return NotFound($"User with id {user.IdUser} not found.");
            }

            var utcNow = DateTime.UtcNow;
            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var localTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, mexicoCityTimeZone);
            user.Updated = localTime;

            user.UpdatedByUser = await _userService.GetUserByIdAsync(request.Id);

            await _userService.UpdateUserAsync(user);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task DeleteUserAsync(Guid id)
        {
            await _userService.DeleteUserAsync(id);
        }
    }
}