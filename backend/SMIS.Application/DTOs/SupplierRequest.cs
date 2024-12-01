using SMIS.Core.Entities;

namespace SMIS.Application.DTOs
{
    public class SupplierRequest
    {
        public Supplier? Supplier { get; set; }
        public Guid Id { get; set; }
    }
}
