using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMIS.Core.Entities
{
    public class Supplier
    {
        [Key] 
        public Guid IdSupplier { get; set; }

        [StringLength (100)]
        public required string Name { get; set; }

        [StringLength (500)]
        public string Description { get; set; }

        public EnumSupplierStatus SupplierStatus { get; set; }

        //Log
        public DateTime? Created { get; set; }

        [ForeignKey("CreatedByUser")]
        public Guid? CreatedBy { get; set; }

        public DateTime? Updated { get; set; }

        [ForeignKey("UpdatedByUser")]
        public Guid? UpdatedBy { get; set; }

        //Navegation properties
        public User? CreatedByUser { get; set; }
        public User? UpdatedByUser { get; set; }
    }

    public enum EnumSupplierStatus
    {
        Active,
        Inactive
    }
}
