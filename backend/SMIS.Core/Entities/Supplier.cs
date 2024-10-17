using System.ComponentModel.DataAnnotations;

namespace SMIS.Core.Entities
{
    public class Supplier
    {    
        public Guid IdSupplier { get; set; }
        [StringLength (100)]
        public string Name { get; set; }
        [StringLength (500)]
        public string Description { get; set; }

        //Log
        public DateTime Created { get; set; }
        [StringLength(100)]
        public User CreatedBy { get; set; }
        public DateTime? Update { get; set; }
        [StringLength(100)]
        public User UpdateBy { get; set; }
    }

    public enum SupplierStatus
    {
        Active,
        Inactive
    }
}
