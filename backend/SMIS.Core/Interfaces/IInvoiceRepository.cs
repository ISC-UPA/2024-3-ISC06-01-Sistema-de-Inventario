using SMIS.Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Core.Interfaces
{
    public interface IInvoiceRepository{

        Task<IEnumerable<Invoice>> GetAllAsync();
        Task<Invoice> GetByIdAsync(int id);
        Task AddAsync(Invoice invoice);
        Task UpdateAsync(Invoice invoice);
    }
}
