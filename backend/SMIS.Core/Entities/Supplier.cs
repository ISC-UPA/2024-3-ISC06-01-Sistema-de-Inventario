using System.ComponentModel.DataAnnotations;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Core.Entities
{
    public class Supplier
    {    
        public Guid IdSupplier { get; set; }
        [StringLength (100)]
        public string Name { get; set; }
        [StringLength (500)]
        public string Description { get; set; }
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
