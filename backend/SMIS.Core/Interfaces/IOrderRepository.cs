﻿using SMIS.Core.Entities;

namespace SMIS.Core.Interfaces
{
    public interface IOrderRepository{

        Task<IEnumerable<Order>> GetAllAsync();
        Task<Order> GetByIdAsync(Guid id);
        Task AddAsync(Order order);
        Task UpdateAsync(Order order);

    }
}
