using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SMIS.Core.Entities
{
    public class User {
        [Key]
        public required Guid IdUser { get; set; }

        [StringLength(100)]
        public string UserName { get; set; }

        [StringLength(100)]
        public string UserDisplayName { get; set; }

        public EnumUserRole Role { get; set; }

        [StringLength(100)]
        public string Email { get; set; }

        [StringLength(100)]
        public string Password { get; set; }

        //Log
        public DateTime Created { get; set; }
        [StringLength(100)]

        [ForeignKey("CreatedByUser")]
        public Guid? CreatedBy { get;set; }

        public DateTime? Updated { get; set; }
        [StringLength(100)]

        [ForeignKey("UpdatedByUser")]
        public Guid? UpdatedBy { get; set; }

        //Navegation properties
        public User CreatedByUser { get; set; }
        public User UpdatedByUser { get; set; }
    }

    public enum EnumUserRole
    { 
        Admin,
        Operator,
        User
    }
}
