using Microsoft.AspNetCore.Mvc;
using TuProyecto.Services;

namespace TuProyecto.Controllers
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
        public async Task<IActionResult> SendEmail(string toEmail, string subject, string body)
        {
            try
            {
                await _smtpService.SendEmailAsync(toEmail, subject, body);
                return Ok("Correo enviado correctamente.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al enviar correo: {ex.Message}");
            }
        }
    }
}
