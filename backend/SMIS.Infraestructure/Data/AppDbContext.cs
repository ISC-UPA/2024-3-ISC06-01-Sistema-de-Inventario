﻿using SMIS.Core.Entities;

using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace SMIS.Infraestructure.Data
{
    public class AppDbContext : DbContext
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
            //------------------------------------------------------------------------------------------!!      Guid AutoIncrements         !!

            modelBuilder.Entity<Customer>().Property(c => c.IdCustomer).ValueGeneratedOnAdd();

            modelBuilder.Entity<Order>().Property(o => o.IdOrder).ValueGeneratedOnAdd();

            modelBuilder.Entity<Product>().Property(p => p.IdProduct).ValueGeneratedOnAdd();

            modelBuilder.Entity<RestockOrder>().Property(ro => ro.IdRestockOrder).ValueGeneratedOnAdd();

            modelBuilder.Entity<Supplier>().Property(s => s.IdSupplier).ValueGeneratedOnAdd();

            modelBuilder.Entity<User>().Property(u => u.IdUser).ValueGeneratedOnAdd();

            //------------------------------------------------------------------------------------------!!      Customer Relations      !!

            //To User (CreatedBy)
            modelBuilder.Entity<Customer>().HasOne(c => c.CreatedByUser)
                .WithMany().HasForeignKey(c => c.CreatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //To User(UpdatedBy)
            modelBuilder.Entity<Customer>().HasOne(c => c.UpdatedByUser)
                .WithMany().HasForeignKey(c => c.UpdatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //------------------------------------------------------------------------------------------!!      Order Relations     !!

            //To Customer
            modelBuilder.Entity<Order>().HasOne(o => o.Customer)
                .WithMany().HasForeignKey(o => o.IdCustomer).OnDelete(DeleteBehavior.Restrict);

            //To User (CreatedBy)
            modelBuilder.Entity<Order>().HasOne(o => o.CreatedByUser)
                .WithMany().HasForeignKey(o => o.CreatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //To User (UpdatedBy)
            modelBuilder.Entity<Order>().HasOne(o => o.UpdatedByUser)
                .WithMany().HasForeignKey(o => o.UpdatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //------------------------------------------------------------------------------------------!!      Products Relations      !!

            //To User (CreatedBy)
            modelBuilder.Entity<Product>().HasOne(p => p.CreatedByUser)
                .WithMany().HasForeignKey(p => p.CreatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //To User (UpdatedBy)
            modelBuilder.Entity<Product>().HasOne(p => p.UpdatedByUser)
                .WithMany().HasForeignKey(p => p.UpdatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //------------------------------------------------------------------------------------------!!      RestockOrder Relations      !!

            //To Supplier
            modelBuilder.Entity<RestockOrder>().HasOne(ro => ro.Supplier)
                .WithMany().HasForeignKey(ro => ro.IdSupplier).OnDelete(DeleteBehavior.Restrict);

            //To product
            modelBuilder.Entity<RestockOrder>().HasOne(ro => ro.Product)
                .WithMany().HasForeignKey(ro => ro.IdProduct).OnDelete(DeleteBehavior.Restrict);

            //To Order
            modelBuilder.Entity<RestockOrder>().HasOne(ro => ro.Order)
                .WithMany().HasForeignKey(ro => ro.IdOrder).OnDelete(DeleteBehavior.Restrict);

            //To User (CreatedBy)
            modelBuilder.Entity<RestockOrder>().HasOne(ro => ro.CreatedByUser)
                .WithMany().HasForeignKey(ro => ro.CreatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //To User (UpdatedBy)
            modelBuilder.Entity<RestockOrder>().HasOne(ro => ro.UpdatedByUser)
                .WithMany().HasForeignKey(ro => ro.UpdatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //------------------------------------------------------------------------------------------!!      Supplier Relations      !!

            //To User (CreatedBy)
            modelBuilder.Entity<Supplier>().HasOne(s => s.CreatedByUser)
                .WithMany().HasForeignKey(s => s.CreatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //To User (UpdatedBy)
            modelBuilder.Entity<Supplier>().HasOne(s => s.UpdatedByUser)
                .WithMany().HasForeignKey(s => s.UpdatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //------------------------------------------------------------------------------------------!!      User Relations      !!

            //To User (CreatedBy)
            modelBuilder.Entity<User>().HasOne(u => u.CreatedByUser)
                .WithMany().HasForeignKey(u => u.CreatedBy).OnDelete(DeleteBehavior.ClientSetNull);

            //To User (UpdatedBy)
            modelBuilder.Entity<User>().HasOne(u => u.UpdatedByUser)
                .WithMany().HasForeignKey(u => u.UpdatedBy).OnDelete(DeleteBehavior.ClientSetNull);
        }
    }
}
