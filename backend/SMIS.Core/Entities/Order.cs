using System.Data.SqlTypes;

namespace SMIS.Core.Entities
{
    public class Order{
        public Guid IdOrder { get; set; }
        public Guid IdCustomer { get; set; }
        public Product Product { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime DeliveryDate { get; set; }
        public int Quantity { get; set; }
        public SqlMoney TotalAmount { get; set; }
        public EnumOrderStatus Status { get; set; }

        //Log
        public DateTime Created { get; set; }
        public User CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        public User UpdatedBy { get; set; }
    }

    public enum EnumOrderStatus
    {
        Open,
        Pending,
        Canceled,
        Completed,
        Closed
    }
}
