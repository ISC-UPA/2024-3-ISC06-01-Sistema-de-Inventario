using SMIS.Core.Entities;

namespace SMIS.Application.DTOs
{
    public class ProductRequest
    {
        public Product? Product { get; set; }
        public Guid Id { get; set; }
    }
}
