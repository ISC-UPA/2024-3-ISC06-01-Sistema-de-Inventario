using SMIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Core.Interfaces
{
    public interface IActivityRepository{

        Task<IEnumerable<Activity>> GetAllAsync();
        Task<Activity> GetByIdAsync(int id);
        Task AddAsync(Activity activity);
        Task UpdateAsync(Activity activity);

    }
}
