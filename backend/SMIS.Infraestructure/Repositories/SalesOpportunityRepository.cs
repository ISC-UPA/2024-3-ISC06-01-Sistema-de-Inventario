using SMIS.Core.Entities;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Data;

using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SMIS.Infraestructure.Repositories
{
    public class SalesOpportunityRepository : ISalesOpportunityRepository
    {
        private readonly AppDbContext _context;
        public SalesOpportunityRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<SalesOpportunity>> GetAllAsync()
        {
            return await _context.SalesOpportunities.ToListAsync();
        }

        public async Task<SalesOpportunity?> GetByIdAsync(int id)
        {
            return await _context.SalesOpportunities.FindAsync(id);
        }

        public async Task AddAsync(SalesOpportunity salesOpportunity)
        {
            _context.SalesOpportunities.Add(salesOpportunity);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(SalesOpportunity salesOpportunity)
        {
            _context.SalesOpportunities.Update(salesOpportunity);
            await _context.SaveChangesAsync();
        }
    }
}
