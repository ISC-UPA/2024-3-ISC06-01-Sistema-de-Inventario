﻿using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;

namespace SMIS.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]

    public class UserController
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
        public async Task<User> GetUserByIdAsync(Guid id)
        {
            return await _userService.GetUserByIdAsync(id);
        }

        [HttpPost]
        public async Task AddUserAsync(User user)
        {
            await _userService.AddUserAsync(user);
            //return CreatedAtAction(nameof(GetUserByIdAsync), new { id = user.IdUser }, user); ??? Que es esto¿
        }

        [HttpPut]
        public async Task UpdateUserAsync(User user)
        {
            await _userService.UpdateUserAsync(user);
        }

        [HttpDelete]
        public async Task DeleteUserAsync(Guid id)
        {
            await _userService.DeleteUserAsync(id);
        }
    }
}
