using SMIS.Application.Services;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Repositories;

using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using SMIS.Infraestructure.Data;
using Microsoft.Extensions.Options;
using SMIS.Application.Configuration;

var builder = WebApplication.CreateBuilder(args);

//Acceder a appsettings
builder.Services.Configure<LdapSettings>(builder.Configuration.GetSection("LdapSettings"));


// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddScoped<ILdapServer, LdapService>(sp =>
{
    var ldapSettings = sp.GetRequiredService<IOptions<LdapSettings>>().Value;
    return new LdapService(ldapSettings.Server, ldapSettings.Domain, ldapSettings.User, ldapSettings.Password, ldapSettings.BaseDN);
});

//Configure the DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

//Register services and repositories
builder.Services.AddScoped<ICustomerRepository, CustomerRepository>();
builder.Services.AddScoped<IOrderRepository, OrderRepository>();
builder.Services.AddScoped<IProductRepository, ProductRepository>();
builder.Services.AddScoped<IRestockOrderRepository, RestockOrderRepository>();
builder.Services.AddScoped<ISupplierRepository, SupplierRepository>();
builder.Services.AddScoped<IUserRepository, UserRepository>();

builder.Services.AddScoped<CustomerService>();
builder.Services.AddScoped<OrderService>();
builder.Services.AddScoped<ProductService>();
builder.Services.AddScoped<RestockOrderService>();
builder.Services.AddScoped<SupplierService>();
builder.Services.AddScoped<UserService>();

//Current Current User Sercvice
builder.Services.AddScoped<IUserService, UserService>();

//HttpContext Service
builder.Services.AddHttpContextAccessor();


// Ldap Controllers
builder.Services.AddControllers();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
    app.UseDeveloperExceptionPage();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run(); 