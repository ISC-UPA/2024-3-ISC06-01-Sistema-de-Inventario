using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace SMIS.Core.Entities
{
    public class Activity{
        public Guid IdActivity { get; set; }
        public Guid IdCustomer { get; set; }
        public Guid IdContact { get; set; }
        public EnumActivityType Type { get; set; }
        public DateTime ActivityDate { get; set; }
        [StringLength(100)]
        public string Description { get; set; }
        public EnumActivityStatus Status { get; set; }
        public DateTime Created { get; set; }
        public User CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        public User UpdatedBy { get; set; }
    }

    public enum EnumActivityType
    {
        Call,
        Meeting,
        Email,
        Task
    }

    public enum EnumActivityStatus
    {
        Open,
        Pending,
        Canceled,
        Closed
    }
}

