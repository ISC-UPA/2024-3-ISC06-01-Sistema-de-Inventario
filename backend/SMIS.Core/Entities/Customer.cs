using System.ComponentModel.DataAnnotations;

namespace SMIS.Core.Entities
{
    public class Customer
    {
        public Guid Id { get; set; }
        [StringLength(100)]
        public string Name { get; set; }

        //Log
        [StringLength(100)]
        public string Email { get; set; }
        public DateTime Created { get; set; }
        [StringLength(100)]
        public User CreatedBy { get; set; }
        public DateTime? Update { get; set; }
        [StringLength(100)]
        public User UpdatedBy { get; set; }
    }
}
