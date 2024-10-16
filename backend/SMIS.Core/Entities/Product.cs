using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlTypes;

namespace SMIS.Core.Entities
{
    public class Product{

        public Guid IdProduct { get; set; }
        [StringLength(100)]
        public string Name { get; set; }
        [StringLength(100)]
        public string Description { get; set; }
        public SqlMoney Price { get; set; }
        public SqlMoney Cost { get; set; }
        public int Stock { get; set; }
        public EnumProductCategory Category { get; set; }
        public DateTime Created { get; set; }
        public User CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        public User UpdatedBy { get; set; }
    }

    public enum EnumProductCategory
    {
        ProductExample1,
        ProductExample2
    }
}
