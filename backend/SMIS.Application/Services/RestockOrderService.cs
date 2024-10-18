using SMIS.Core.Entities;
using SMIS.Core.Interfaces;

namespace SMIS.Application.Services
{
    public class RestockOrderService{

        private readonly IRestockOrderRepository _restockOrderRepository;

        public RestockOrderService(IRestockOrderRepository restockOrderRepository)
        {
            _restockOrderRepository = restockOrderRepository;
        }

        public async Task<IEnumerable<RestockOrder>> GetAllRestockOrderAsync() { 
        
            return await _restockOrderRepository.GetAllAsync();
        }

        public async Task<RestockOrder?> GetByIdRestockOrderAsync(Guid id) { 
        
            return await _restockOrderRepository.GetByIdAsync(id);
        }

        public async Task AddRestockOrderAsync(RestockOrder restockOrder) { 
        
            await _restockOrderRepository.AddAsync(restockOrder);
        }

        public async Task UpdateRestockOrderAsync(RestockOrder restockOrder)
        {
            await _restockOrderRepository.UpdateAsync(restockOrder);
        }

    }
}
