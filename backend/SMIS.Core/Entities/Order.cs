using System;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Core.Entities
{
    public class Order{
        public Guid IdOrder { get; set; }
        public Guid IdCustomer { get; set; }
        public Product Product { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime DeliveryDate { get; set; }
        public SqlMoney TotalAmount { get; set; }
        public EnumOrderStatus Status { get; set; }
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
