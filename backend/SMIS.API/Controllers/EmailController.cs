using Microsoft.AspNetCore.Mvc;
using SMIS.Application.Services;
using SMIS.Application.Models;  // Asegúrate de agregar el using para el modelo

namespace SMIS.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class EmailController : ControllerBase
    {
        private readonly SmtpService _smtpService;

        public EmailController(SmtpService smtpService)
        {
            _smtpService = smtpService;
        }

        [HttpPost("send-email")]
        public async Task<IActionResult> SendEmail([FromBody] EmailRequest request)  // Usamos EmailRequest aquí
        {
            try
            {
                await _smtpService.SendEmailAsync(request.ToEmail, request.Subject, request.Body);
                return Ok("Correo enviado correctamente.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al enviar correo: {ex.Message}");
            }
        }
    }
}
