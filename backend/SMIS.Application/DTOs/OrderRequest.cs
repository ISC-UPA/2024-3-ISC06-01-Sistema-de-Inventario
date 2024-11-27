using SMIS.Core.Entities;

namespace SMIS.Application.DTOs
{
    public class OrderRequest
    {
        public Order? Order { get; set; }
        public Guid Id { get; set; }
    }
}
