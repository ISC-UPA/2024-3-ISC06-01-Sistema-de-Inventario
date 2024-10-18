using SMIS.Core.Entities;

using Microsoft.EntityFrameworkCore;

namespace SMIS.Infraestructure.Data
{
    public class AppDbContext:DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {

        }

        public DbSet<Customer> Customers { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<RestockOrder> RestockOrders { get; set; }
        public DbSet<Supplier> Suppliers { get; set; }
        public DbSet<User> Users { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
        //Customer Relations        ------------------------------------------------------!!

            //To User (CreatedBy)
            modelBuilder.Entity<Customer>().HasOne(c => c.CreatedByUser)
                .WithMany().HasForeignKey(c => c.CreatedByUser).OnDelete(DeleteBehavior.Restrict);

            //To User (UpdatedBy)

        //Order Relations           ------------------------------------------------------!!

        //Products Relations        ------------------------------------------------------!!

        //RestockOrder Relations    ------------------------------------------------------!!

        //Supplier Relations        ------------------------------------------------------!!

        //User Relations            ------------------------------------------------------!!
        }
    }
}
