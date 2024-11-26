using SMIS.Application.Services;
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Repositories;
using SMIS.Infraestructure.Data;

//SQL-Server
using Microsoft.EntityFrameworkCore;

//SMTP
using SMIS.Application.Services.Email; // Asegúrate de que exista este namespace

var builder = WebApplication.CreateBuilder(args);

/*
//Configuracion de LDAP-Server ----> 
builder.Services.Configure<LdapSettings>(builder.Configuration.GetSection("LdapSettings"));
builder.Services.AddScoped<ILdapServer, LdapService>(sp =>
{
    var ldapSettings = sp.GetRequiredService<IOptions<LdapSettings>>().Value;
    return new LdapService(ldapSettings.Server, ldapSettings.Domain, ldapSettings.User, ldapSettings.Password, ldapSettings.BaseDN);
});
// Ldap Controllers
builder.Services.AddControllers();
//----> 
*/

// Add services to the container.
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
    });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

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

builder.Services.AddScoped<Auth>();
builder.Services.AddScoped<CustomerService>();
builder.Services.AddScoped<OrderService>();
builder.Services.AddScoped<ProductService>();
builder.Services.AddScoped<RestockOrderService>();
builder.Services.AddScoped<SupplierService>();
builder.Services.AddScoped<UserService>();

//Current User Service
builder.Services.AddScoped<IUserService, UserService>();

//HttpContext Service
builder.Services.AddHttpContextAccessor();

/* ---- NUEVO: Configuración de SMTP ---- */
builder.Services.AddScoped<SmtpService>(); // Registrar el servicio SMTP

/* ---- Fin configuración SMTP ---- */

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
