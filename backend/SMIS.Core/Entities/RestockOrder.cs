﻿using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.SqlTypes;

namespace SMIS.Core.Entities
{
    public class RestockOrder
    {
        [Key]
        public required Guid IdRestockOrder { get; set; }
        [ForeignKey("Supplier")]
        public Guid IdSupplier { get; set; }
        [ForeignKey("Product")]
        public Guid IdProduct { get; set; }
        public DateTime RestockOrderDate { get; set; }
        public int Quantity { get; set; }
        public SqlMoney TotalAmount { get; set; }
        public EnumRestockOrderStatus Status { get; set; }

        //Log
        public DateTime Created { get; set; }
        [ForeignKey("CreatedByUser")]
        public Guid? CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        [ForeignKey("UpdateByUser")]
        public Guid? UpdatedBy { get; set; }
    }

    public enum EnumRestockOrderStatus
    {
        Open,
        Pending,
        Canceled,
        Completed
    }
}
