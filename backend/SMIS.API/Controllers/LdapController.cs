using Microsoft.AspNetCore.Mvc;
using SMIS.Core.Interfaces;
using SMIS.Application.Services;

namespace MyProject.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LdapController : ControllerBase
    {
        private readonly ILdapServer _ldapService;

        public LdapController(LdapService ldapService)
        {
            _ldapService = ldapService;
        }

        // Endpoint para probar la conexión a LDAP
        [HttpGet("test-connection")]
        public IActionResult TestLdapConnection()
        {
            try
            {
                _ldapService.ConnectToLpad();
                return Ok("Conexión a LDAP exitosa.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error en la conexión LDAP: {ex.Message}");
            }
        }
    }
}
