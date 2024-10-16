using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Core.Entities
{
    public class Client
    {
        public Guid IdClient { get; set; }
        [StringLength(100)]
        public string ClientName { get; set; }
        [StringLength (100)]
        public string Email { get; set; }
        public DateTime Created { get; set; }
        [StringLength(100)]
        public User CreatedBy { get; set; }
        public DateTime? Update { get; set; }
        [StringLength(100)]
        public User UpdatedBy { get; set; }
    }
}