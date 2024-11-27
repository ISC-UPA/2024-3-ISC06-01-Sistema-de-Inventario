using SMIS.Core.Entities;

namespace SMIS.Application.DTOs
{
    public class CustomerRequest
    {
        public Customer? Customer { get; set; }
        public Guid Id { get; set; }
    }
}
