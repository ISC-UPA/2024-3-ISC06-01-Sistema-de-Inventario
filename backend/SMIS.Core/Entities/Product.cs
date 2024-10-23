using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.SqlTypes;


namespace SMIS.Core.Entities
{
    public class Product{
        [Key]
        public required Guid IdProduct { get; set; }

        [StringLength(100)]
        public string Name { get; set; }

        [StringLength(100)]
        public string Description { get; set; }

        public SqlMoney Price { get; set; }

        public SqlMoney Cost { get; set; }

        public int Stock { get; set; }

        public EnumProductCategory Category { get; set; }

        //Log
        public DateTime Created { get; set; }

        [ForeignKey("CreatedByUser")]
        public Guid? CreatedBy { get; set; }

        public DateTime? Updated { get; set; }

        [ForeignKey("UpdatedByUser")]
        public Guid? UpdatedBy { get; set; }

        //Navegation properties
        public User CreatedByUser { get; set; }
        public User UpdatedByUser { get; set; }
    }

    public enum EnumProductCategory
    {
        ProductExample1,
        ProductExample2
    }
}
