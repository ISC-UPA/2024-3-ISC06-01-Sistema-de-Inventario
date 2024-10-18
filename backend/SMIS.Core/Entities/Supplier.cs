using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMIS.Core.Entities
{
    public class Supplier
    {
        [Key] 
        public required Guid IdSupplier { get; set; }
        [StringLength (100)]
        public string Name { get; set; }
        [StringLength (500)]
        public string Description { get; set; }

        //Log
        public DateTime Created { get; set; }
        [StringLength(100)]
        [ForeignKey("CreatedByUser")]
        public Guid? CreatedBy { get; set; }
        public DateTime? Update { get; set; }
        [StringLength(100)]
        [ForeignKey("UpdateByUser")]
        public Guid? UpdateBy { get; set; }
    }

    public enum SupplierStatus
    {
        Active,
        Inactive
    }
}
