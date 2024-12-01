using SMIS.Core.Entities;

namespace SMIS.Application.DTOs
{
    public class RestockOrderRequest
    {
        public RestockOrder? RestockOrder { get; set; }
        public Guid Id { get; set; }
    }
}
