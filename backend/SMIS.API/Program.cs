using SMIS.Application.Services; // Usamos el namespace correcto para los servicios
using SMIS.Core.Interfaces;
using SMIS.Infraestructure.Repositories;
using SMIS.Infraestructure.Data;

// SQL-Server
using Microsoft.EntityFrameworkCore;

// SMTP
using SMIS.Application.Services; // Este es el espacio de nombres correcto para SmtpService

var builder = WebApplication.CreateBuilder(args);

// Configuración de LDAP-Server (comentado por si no lo necesitas)
//builder.Services.Configure<LdapSettings>(builder.Configuration.GetSection("LdapSettings"));
//builder.Services.AddScoped<ILdapServer, LdapService>(sp =>
//{
//    var ldapSettings = sp.GetRequiredService<IOptions<LdapSettings>>().Value;
//    return new LdapService(ldapSettings.Server, ldapSettings.Domain, ldapSettings.User, ldapSettings.Password, ldapSettings.BaseDN);
//});

// Ldap Controllers
//builder.Services.AddControllers();

// Agregar servicios al contenedor
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = System.Text.Json.Serialization.ReferenceHandler.IgnoreCycles;
    });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Configuración del DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Registrar servicios y repositorios
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

// Servicio de usuario actual
builder.Services.AddScoped<IUserService, UserService>();

// Servicio HttpContext
builder.Services.AddHttpContextAccessor();

// Configuración del servicio SMTP
builder.Services.AddScoped<SmtpService>(); // Registrar el servicio SMTP

var app = builder.Build();

// Configuración del pipeline de solicitud HTTP
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
