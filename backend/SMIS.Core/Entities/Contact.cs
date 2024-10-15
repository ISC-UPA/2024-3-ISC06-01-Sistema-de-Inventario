using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace SMIS.Core.Entities
{
    public class Contact{

        public Guid IdContact { get; set; }
        public Guid IdCustomer { get; set; }
        [StringLength(100)]
        public string Name { get; set; }
        [StringLength(100)] 
        public string Position { get; set; }
        [StringLength(100)]
        public string Email { get; set; }
        [StringLength(15)]
        public string Phone { get; set; }
        [StringLength(500)]
        public string Notes { get; set; }
        public DateTime Created {  get; set; }
        [StringLength (100)]
        public User CreatedBy { get; set; }
        public DateTime? Update {  get; set; }
        [StringLength(100)]
        public User UpdateBy { get; set; }
    }
}
