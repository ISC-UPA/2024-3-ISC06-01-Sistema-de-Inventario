using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMIS.Core.Entities
{
    public class Customer
    {
        [Key]
        public required Guid Id { get; set; }
        [StringLength(100)]
        public string Name { get; set; }
        [StringLength(100)]
        public string Email { get; set; }

        //Log
        public DateTime Created { get; set; }

        [StringLength(100)]
        [ForeignKey("CreatedByUser")]
        public Guid? CreatedBy { get; set; }
        public DateTime? Update { get; set; }

        [StringLength(100)]
        [ForeignKey("UpdateByUser")]
        public Guid? UpdatedBy { get; set; }

       //Navegation properties
        public User CreatedByUser { get; set; }
        public User UpdatedByUser { get; set; }
    }
}