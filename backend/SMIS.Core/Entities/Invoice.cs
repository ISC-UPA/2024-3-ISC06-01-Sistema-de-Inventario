using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlTypes;

namespace SMIS.Core.Entities
{
    public class Invoice{
        public Guid IdInvoice { get; set; }
        public Guid IdOrder { get; set; }
        public DateTime InvoiceDate { get; set; }
        public SqlMoney TotalAmount { get; set; }
        public EnumInvoiceStatus Status { get; set; }
        public DateTime Created { get; set; }
        public User CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        public User UpdatedBy { get; set; }
    }

    public enum EnumInvoiceStatus
    {
        Open,
        Pending,
        Canceled,
        Completed,
        Closed
    }

}

