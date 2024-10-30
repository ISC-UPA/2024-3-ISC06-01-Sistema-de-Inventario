using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.SqlTypes;

namespace SMIS.Core.Entities
{
    public class RestockOrder
    {
        [Key]
        public  Guid IdRestockOrder { get; set; }

        [ForeignKey("Supplier")]
        public required Guid IdSupplier { get; set; }

        [ForeignKey("Product")]
        public required Guid IdProduct { get; set; }

        public DateTime RestockOrderDate { get; set; }

        public required int Quantity { get; set; }

        [Precision(18, 2)]
        public required decimal TotalAmount { get; set; }

        public EnumRestockOrderStatus Status { get; set; }

        //Log
        public DateTime? Created { get; set; }

        [ForeignKey("CreatedByUser")]
        public Guid? CreatedBy { get; set; }

        public DateTime? Updated { get; set; }

        [ForeignKey("UpdatedByUser")]
        public Guid? UpdatedBy { get; set; }

        //Navegation properties
        public Supplier? Supplier { get; set; }
        public Product? Product { get; set; }
        public User? CreatedByUser { get; set; }
        public User? UpdatedByUser { get; set; }
    }

    public enum EnumRestockOrderStatus
    {
        Open,
        Pending,
        Canceled,
        Completed
    }
}
