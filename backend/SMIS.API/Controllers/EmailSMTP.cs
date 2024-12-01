using Microsoft.AspNetCore.Mvc;
using YourProjectNamespace.Services;

[ApiController]
[Route("api/[controller]")]
public class EmailController : ControllerBase
{
    private readonly EmailService _emailService;

    // Inyectamos el servicio de Email
    public EmailController(EmailService emailService)
    {
        _emailService = emailService;
    }

    // Endpoint para enviar correos
    [HttpPost("send")]
    public IActionResult SendEmail(string to, string subject, string body)
    {
        try
        {
            _emailService.SendEmail(to, subject, body);
            return Ok("Correo enviado correctamente.");
        }
        catch (Exception ex)
        {
            return BadRequest($"Error al enviar el correo: {ex.Message}");
        }
    }
}
