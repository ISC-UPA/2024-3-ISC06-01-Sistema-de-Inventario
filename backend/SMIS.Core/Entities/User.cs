using System.ComponentModel.DataAnnotations;

namespace SMIS.Core.Entities
{
    public class User {

        public Guid IdUser { get; set; }
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
        public User CreatedBy { get;set; }
        public DateTime? Update { get; set; }
        [StringLength(100)]
        public User UpdatedBy { get; set; }
    }


    public enum EnumUserRole
    { 
        Admin,
        Operator,
        User
    }
}
