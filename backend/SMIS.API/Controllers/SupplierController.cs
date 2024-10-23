using SMIS.Application.Services;
using SMIS.Core.Entities;

using Microsoft.AspNetCore.Mvc;

namespace SMIS.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SupplierController
    {
        private readonly SupplierService _supplierService;
        public SupplierController(SupplierService supplierService)
        {
            _supplierService = supplierService;
        }

        [HttpGet]
        public async Task<IEnumerable<Supplier>> GetAllSuppliersAsync()
        {
            return await _supplierService.GetAllSuppliersAsync();
        }

        [HttpGet("{id}")]
        public async Task<Supplier> GetSupplierByIdAsync(Guid id)
        {
            return await _supplierService.GetSupplierByIdAsync(id);
        }

        [HttpPost]
        public async Task AddSupplierAsync(Supplier supplier)
        {
            await _supplierService.AddSupplierAsync(supplier);
        }

        [HttpPut]
        public async Task UpdateSupplierAsync(Supplier supplier)
        {
            await _supplierService.UpdateSupplierAsync(supplier);
        }

        [HttpDelete]
        public async Task DeletedSupplierAsync(Guid id)
        {
            await _supplierService.DeletedSupplierAsync(id);
        }
    }
}
