using SMIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Core.Interfaces
{
    public interface ISupplierRepository
    {
        Task<IEnumerable<Supplier>> GetAllAsync();

        Task<IEnumerable<Supplier>> GetById(int id);

        Task AddAsync(Supplier supplier);

        Task UpdateAsync(Supplier supplier);
    }
}
