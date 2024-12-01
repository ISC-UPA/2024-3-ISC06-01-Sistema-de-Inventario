using System;
using System.Net;
using System.Net.Mail;

namespace YourProjectNamespace.Services
{
    public class EmailService
    {
        private readonly string smtpHost = "192.168.0.10";
        private readonly int smtpPort = 25;
        private readonly string smtpUser = "Uprueba@midominio.local";
        private readonly string smtpPass = "Peresoso_10";

        public void SendEmail(string to, string subject, string body, bool isHtml = false)
        {
            try
            {
                
                using (SmtpClient smtpClient = new SmtpClient(smtpHost, smtpPort))
                {
                    smtpClient.Credentials = new NetworkCredential(smtpUser, smtpPass);
                    smtpClient.EnableSsl = false; 

                   
                    using (MailMessage mailMessage = new MailMessage())
                    {
                        mailMessage.From = new MailAddress(smtpUser);
                        mailMessage.To.Add(to);
                        mailMessage.Subject = subject;
                        mailMessage.Body = body;
                        mailMessage.IsBodyHtml = isHtml;

                        
                        smtpClient.Send(mailMessage);
                    }
                }
                Console.WriteLine("Correo enviado correctamente.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error al enviar el correo: {ex.Message}");
                throw; 
            }
        }
    }
}
