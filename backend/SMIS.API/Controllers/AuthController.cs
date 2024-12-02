using SMIS.Application.Services;
using SMIS.Application.Helpers;
using SMIS.Application.DTOs;

using SMIS.Core.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Text;

namespace SMIS.API.Controllers
{
    [AllowAnonymous]
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly Auth _auth;
        private readonly IConfiguration _configuration;
        private readonly LdapService _ldapService;

        private readonly UserService _userService;
        public AuthController(Auth auth, IConfiguration configuration, LdapService ldapService, UserService userService)
        {
            _auth = auth;
            _configuration = configuration;
            _ldapService = ldapService;
            _userService = userService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> LogIn([FromBody] LoginRequest request)
        {
            // Código original comentado para utilizar después
            // var user = await _auth.ValidateUserAsync(request.Username, request.Password);
            // if(user == null)
            // {
            //     return Unauthorized();
            // }


            Guid id = new Guid("D99B413F-B318-4A36-8AF8-EA969171040D");
            var user = await _userService.GetUserByIdAsync(id);

            var mexicoCityTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Central Standard Time (Mexico)");
            var expirationTime = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, mexicoCityTimeZone);
            //var expirationTime = DateTime.UtcNow;
            var token = GenerateJwtToken(user, expirationTime.AddDays(1));
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
                expires: expirationDate,
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
