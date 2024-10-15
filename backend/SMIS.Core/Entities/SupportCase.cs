using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Core.Entities
{
    public class SupportCase{

        public Guid IdSupportCase { get; set; }
        public Guid IdCustomer { get; set; }
        public Guid IdContact { get; set; }
        [StringLength(100)]
        public string Title { get; set; }
        [StringLength(100)]
        public string Description { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public EnumSupportCasePriority Priority { get; set; }
        public EnumSupportCaseStatus Status { get; set; }
        public DateTime Created { get; set; }
        public User CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        public User UpdatedBy { get; set; }
    }

    public enum EnumSupportCasePriority
    {
        Low,
        Medium,
        High
    }

    public enum EnumSupportCaseStatus
    {
        Open,
        Pending,
        Canceled,
        Closed
    }
}
