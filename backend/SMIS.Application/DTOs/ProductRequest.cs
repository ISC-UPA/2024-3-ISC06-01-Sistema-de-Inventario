using SMIS.Core.Entities;

namespace SMIS.Application.DTOs
{
    public class ProductRequest
    {
        public Product? Product { get; set; }
        public Guid Id { get; set; }
    }

    public class StockRequest
    {
        public Guid ProductId { get; set; }
        public int total { get; set; }
    }
}
