using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlTypes;

namespace SMIS.Core.Entities
{
    public class SalesOpportunity{

        public Guid IdSalesOpportunity { get; set; }
        public Guid IdCustomer { get; set; }
        [StringLength(100)]
        public string Description { get; set; }
        public DateTime BeginingDate { get; set; }
        public DateTime EndDate { get; set; }
        public SqlMoney Amount { get; set; }
        public EnumOpportunityStatus Status { get; set; }
        public EnumOpportunityStage Stage { get; set; }
        public DateTime Created { get; set; }
        public User CreatedBy { get; set; }
        public DateTime? Updated { get; set; }
        public User UpdatedBy { get; set; }
    }

    public enum EnumOpportunityStatus
    {
        Open,
        Closed,
        Win,
        Lost
    }

    public enum EnumOpportunityStage
    {
        Discovery,
        Proposal,
        Negotiation,
        Closed
    }
}
