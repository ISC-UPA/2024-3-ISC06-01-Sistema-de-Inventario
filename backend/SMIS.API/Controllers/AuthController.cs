using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;
using SMIS.Application.DTOs;

namespace SMIS.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]

    public class AuthController :ControllerBase
    {
        private readonly Auth _auth;
        public AuthController(Auth auth)
        {
            _auth = auth;
        }

        [HttpPost]
        public async Task<User> LogIn([FromBody] LoginRequest request)
        {
            return await _auth.LogIn(request.Username, request.Password);
        }
    }
}
