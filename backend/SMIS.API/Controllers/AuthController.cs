using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;
using SMIS.Application.DTOs;

namespace SMIS.API.Controllers
{
    [AllowAnonymous]
    [ApiController]
    [Route("api/[controller]")]

    public class AuthController :ControllerBase
    {
        private readonly Auth _auth;
        private readonly IConfiguration _configuration;
        private readonly LdapService _ldapService;
        public AuthController(Auth auth, IConfiguration configuration, LdapService ldapService)
        {
            _auth = auth;
            _configuration = configuration;
            _ldapService = ldapService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> LogIn([FromBody] LoginRequest request)
        {
            var user = await _auth.ValidateUserAsync(request.Username, request.Password);
            if(user == null)
            {
                return Unauthorized();
            }
            var expirationTime = DateTime.UtcNow.AddHours(1);
            var token = GenerateJwtToken(user, expirationTime);
            return Ok(new { User = user, Token = token, Expiration = expirationTime });
        }

        private string GenerateJwtToken(User user, DateTime expirationDate)
        {
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.UserName),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(ClaimTypes.NameIdentifier, user.IdUser.ToString())
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:SecretKey"]));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: DateTime.Now.AddMinutes(30),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }

    public class LoginModel
    {
        public required string Username { get; set; }
        public required string Password { get; set; }
    }
}
