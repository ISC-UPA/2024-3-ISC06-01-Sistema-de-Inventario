using SMIS.Core.Entities;

namespace SMIS.Application.DTOs
{
    public class UserRequest
    {
        public User? User { get; set; }
        public Guid Id { get; set; }
    }
}
