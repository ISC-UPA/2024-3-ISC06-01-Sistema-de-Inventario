using SMIS.Core.Entities;

using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

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
        //Customer Relations            ------------------------------------------------------------------------------------------------------------!!

            //To User (CreatedBy)
            modelBuilder.Entity<Customer>().HasOne(c => c.CreatedByUser)
                .WithMany().HasForeignKey(c => c.CreatedByUser).OnDelete(DeleteBehavior.Restrict);

            //To User (UpdatedBy)
            modelBuilder.Entity<Customer>().HasOne(c => c.UpdatedByUser)
                .WithMany().HasForeignKey(o => o.UpdatedByUser).OnDelete(DeleteBehavior.Restrict);

        //Order Relations               ------------------------------------------------------------------------------------------------------------!!

            //To Customer
            modelBuilder.Entity<Order>().HasOne(o => o.Customer)
                .WithMany().HasForeignKey(o => o.IdCustomer).OnDelete(DeleteBehavior.Restrict);

            //To Product
            modelBuilder.Entity<Order>().HasOne(o => o.Customer)
                .WithMany().HasForeignKey(o => o.IdProduct).OnDelete(DeleteBehavior.Restrict);

            //To User (CreatedBy)
            modelBuilder.Entity<Order>().HasOne(o => o.CreatedByUser)
                .WithMany().HasForeignKey(c => c.CreatedByUser).OnDelete(DeleteBehavior.Restrict);

            //To User (UpdatedBy)
            modelBuilder.Entity<Order>().HasOne(o => o.UpdatedByUser)
                .WithMany().HasForeignKey(o => o.UpdatedByUser).OnDelete(DeleteBehavior.Restrict);

        //Products Relations            ------------------------------------------------------------------------------------------------------------!!

            //To User (CreatedBy)
            modelBuilder.Entity<Product>().HasOne(p => p.CreatedByUser)
                .WithMany().HasForeignKey(p => p.CreatedByUser).OnDelete(DeleteBehavior.Restrict);

            //To User (UpdatedBy)
            modelBuilder.Entity<Product>().HasOne(p => p.UpdatedByUser)
                .WithMany().HasForeignKey(p => p.UpdatedByUser).OnDelete(DeleteBehavior.Restrict);

        //RestockOrder Relations        ------------------------------------------------------------------------------------------------------------!!

            //To Supplier
            modelBuilder.Entity<RestockOrder>().HasOne(ro => ro.Supplier)
                .WithMany().HasForeignKey(ro => ro.IdSupplier).OnDelete(DeleteBehavior.Restrict);

            //To product
            modelBuilder.Entity<RestockOrder>().HasOne(ro => ro.Product)
                .WithMany().HasForeignKey(ro => ro.IdProduct).OnDelete(DeleteBehavior.Restrict);

            //To User (CreatedBy)
            modelBuilder.Entity<RestockOrder>().HasOne(ro => ro.CreatedByUser)
                .WithMany().HasForeignKey(ro => ro.CreatedByUser).OnDelete(DeleteBehavior.Restrict);

            //To User (UpdatedBy)
            modelBuilder.Entity<RestockOrder>().HasOne(ro => ro.UpdatedByUser)
                .WithMany().HasForeignKey(ro => ro.UpdatedByUser).OnDelete(DeleteBehavior.Restrict);

        //Supplier Relations            ------------------------------------------------------------------------------------------------------------!!

            //To User (CreatedBy)
            modelBuilder.Entity<Supplier>().HasOne(s => s.CreatedByUser)
                .WithMany().HasForeignKey(s => s.CreatedByUser).OnDelete(DeleteBehavior.Restrict);

            //To User (UpdatedBy)
            modelBuilder.Entity<Supplier>().HasOne(s => s.UpdatedByUser)
                .WithMany().HasForeignKey(s => s.UpdatedByUser).OnDelete(DeleteBehavior.Restrict);

        //User Relations                ------------------------------------------------------------------------------------------------------------!!

            //To User (CreatedBy)
            modelBuilder.Entity<User>().HasOne(u => u.CreatedByUser)
                .WithMany().HasForeignKey(u => u.CreatedByUser).OnDelete(DeleteBehavior.Restrict);

            //To User (UpdatedBy)
            modelBuilder.Entity<User>().HasOne(u => u.UpdatedByUser)
                .WithMany().HasForeignKey(u => u.UpdatedByUser).OnDelete(DeleteBehavior.Restrict);
        }
    }
}
