using SMIS.Core.Entities;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Core.Interfaces
{
    internal interface IClientRepository
    {
        Task<IEnumerable<Client>> GetAllAsync();
        Task<Client> GetById(Guid id);
        Task AddAsync(Client client);
        Task UpdateAsync(Client client);
    }
}
