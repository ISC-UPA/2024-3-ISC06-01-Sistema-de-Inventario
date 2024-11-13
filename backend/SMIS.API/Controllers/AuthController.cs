using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;

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
        public async Task<User> LogIn(String Email, String password)
        {
            return await _auth.LogIn(Email, password);
        }
    }
}
