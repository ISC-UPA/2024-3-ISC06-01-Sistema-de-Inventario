﻿using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.SqlTypes;

namespace SMIS.Core.Entities
{
    public class Order{
        [Key]
        public required Guid IdOrder { get; set; }
        [ForeignKey("Customer")]
        public Guid IdCustomer { get; set; }
        [ForeignKey("Product")]
        public Guid IdProduct { get; set; }
        public DateTime OrderDate { get; set; }
        public DateTime DeliveryDate { get; set; }
        public int Quantity { get; set; }
        public SqlMoney TotalAmount { get; set; }
        public EnumOrderStatus Status { get; set; }

        //Log
        public DateTime Created { get; set; }
        [ForeignKey("CreatedByUser")]
        public Guid? CreatedBy { get; set; }

        public DateTime? Updated { get; set; }
        [ForeignKey("UpdatedByUser")]
        public Guid? UpdatedBy { get; set; }
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
