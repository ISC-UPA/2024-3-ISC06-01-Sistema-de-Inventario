using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.SqlTypes;

namespace SMIS.Core.Entities
{
    public class Order{
        [Key]
        public Guid IdOrder { get; set; }

        [ForeignKey("Customer")]
        public required Guid IdCustomer { get; set; }

        [ForeignKey("Product")]
        public required Guid IdProduct { get; set; }

        public required DateTime OrderDate { get; set; }

        public DateTime? DeliveryDate { get; set; }

        public int? Quantity { get; set; }

        public decimal TotalAmount { get; set; }

        public EnumOrderStatus Status { get; set; }

        //Log
        public DateTime? Created { get; set; }

        [ForeignKey("CreatedByUser")]
        public Guid? CreatedBy { get; set; }

        public DateTime? Updated { get; set; }

        [ForeignKey("UpdatedByUser")]
        public Guid? UpdatedBy { get; set; }

        //Navegation properties
        public Customer? Customer { get; set; }
        public Product? Product { get; set; }
        public User? CreatedByUser { get; set; }
        public User? UpdatedByUser { get; set; }
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
