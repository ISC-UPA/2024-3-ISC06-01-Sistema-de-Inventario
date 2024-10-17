using System.Data.SqlTypes;

namespace SMIS.Core.Entities
{
    public class RestockOrder
    {
        public Guid IdRestockOrder { get; set; }
        public Guid IdSupplier { get; set; }
        public Product Product { get; set; }
        public DateTime RestockOrderDate { get; set; }
        public int Quantity { get; set; }
        public SqlMoney TotalAmount { get; set; }
        public EnumRestockOrderStatus Status { get; set; }

        //Log
        public DateTime Created { get; set; }
        public User CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        public User UpdatedBy { get; set; }
    }

    public enum EnumRestockOrderStatus
    {
        Open,
        Pending,
        Canceled,
        Completed
    }
}
