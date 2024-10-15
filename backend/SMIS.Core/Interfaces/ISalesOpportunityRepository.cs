using SMIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Core.Interfaces
{
    public interface ISalesOpportunityRepository{

        Task<IEnumerable<SalesOpportunity>> GetAllAsync();
        Task<SalesOpportunity> GetByIdAsync(int id);
        Task AddAsync(SalesOpportunity salesOportunity);
        Task UpdateAsync(SalesOpportunity salesOportunity);
    }
}
