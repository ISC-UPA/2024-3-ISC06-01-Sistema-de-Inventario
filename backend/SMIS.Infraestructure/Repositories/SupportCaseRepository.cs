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
    public class SupportCaseRepository : ISupportCaseRepository
    {
        private readonly AppDbContext _context;
        public SupportCaseRepository(AppDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<SupportCase>> GetAllAsync()
        {
            return await _context.SupportCases.ToListAsync();
        }

        public async Task<SupportCase?> GetByIdAsync(int id)
        {
            return await _context.SupportCases.FindAsync(id);
        }

        public async Task AddAsync(SupportCase supportCase)
        {
            _context.SupportCases.Add(supportCase);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(SupportCase supportCase)
        {
            _context.SupportCases.Update(supportCase);
            await _context.SaveChangesAsync();
        }
    }
}
