using System.Net;
using System.Net.Mail;
using Microsoft.Extensions.Configuration;

namespace TuProyecto.Services
{
    public class SmtpService
    {
        private readonly IConfiguration _configuration;

        public SmtpService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task SendEmailAsync(string toEmail, string subject, string body)
        {
            var smtpSettings = _configuration.GetSection("SmtpSettings");

            using var smtpClient = new SmtpClient
            {
                Host = smtpSettings["Host"],
                Port = int.Parse(smtpSettings["Port"]),
                EnableSsl = bool.Parse(smtpSettings["EnableSSL"]),
                Credentials = new NetworkCredential(smtpSettings["UserName"], smtpSettings["Password"])
            };

            var mailMessage = new MailMessage
            {
                From = new MailAddress(smtpSettings["UserName"]),
                Subject = subject,
                Body = body,
                IsBodyHtml = true // Cambia a false si no necesitas HTML
            };

            mailMessage.To.Add(toEmail);

            await smtpClient.SendMailAsync(mailMessage);
        }
    }
}
