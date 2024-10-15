using SMIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Core.Interfaces
{
    public interface ISupportCaseRepository{

        Task<IEnumerable<SupportCase>> GetAllAsync();
        Task<SupportCase> GetByIdAsync(int id);
        Task AddAsync(SupportCase supportCase);
        Task UpdateAsync(SupportCase supportCase);
    }
}
