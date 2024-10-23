using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMIS.Core.Entities
{
    public class Customer
    {
        [Key]
        public required Guid IdCustomer { get; set; }

        [StringLength(100)]
        public string Name { get; set; }

        [StringLength(100)]
        public string Email { get; set; }

        //Log
        public DateTime Created { get; set; }

        [ForeignKey("CreatedByUser")]
        public Guid? CreatedBy { get; set; }

        public DateTime? Updated { get; set; }

        [ForeignKey("UpdatedByUser")]
        public Guid? UpdatedBy { get; set; }

        //Navegation properties
        public User? CreatedByUser { get; set; }
        public User UpdatedByUser { get; set; }
    }
}