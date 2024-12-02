# Sistema de Inventario con Autenticación y Reportes de Actividad vía Correo Electrónico


![Image](screenshot.png)


Este sistema de gestión de inventarios está diseñado para facilitar el manejo de productos, proporcionando autenticación segura mediante Active Directory (AD) y la automatización de reportes de inventario enviados por correo electrónico. Los usuarios podrán visualizar, agregar, modificar y eliminar elementos del inventario, además de recibir reportes periódicos sobre el estado del inventario.

## Funcionalidades

### 1. Gestión de Inventarios
- **Crear, editar y eliminar** elementos del inventario.
- Visualización de detalles clave del inventario, como cantidad, categoría, proveedor, y fechas de entrada/salida.
- Control de **movimientos de inventario**, registrando cada modificación (entradas, salidas, ajustes de stock).

### 2. Autenticación con Active Directory
- **Autenticación segura** utilizando **Active Directory**.
- Los usuarios deben autenticarse mediante AD para acceder al sistema.
- Gestión de roles y permisos a través de los grupos de AD (ejemplo: administrador, usuario estándar).

### 3. Reportes Automáticos
- **Generación automática** de reportes de inventario con detalles sobre el estado de los productos (cantidad disponible, productos críticos, etc.).
- Envío de reportes periódicos a usuarios específicos por **correo electrónico**.
- Configuración de un **servidor SMTP** para el envío programado de los reportes (diarios, semanales, mensuales).

### 4. Historial de Movimientos
- Registro de **todas las modificaciones** en el inventario, incluyendo información sobre quién realizó el cambio y cuándo ocurrió.
- Visualización de un **historial completo** de entradas, salidas y ajustes para auditorías.

## Estructura Técnica

### Frontend (Flutter)
- **Dashboard**: Visualización del inventario con filtros por categoría, cantidad disponible y fecha de modificación.
- **Formulario de Inventario**: Interfaz para agregar o editar productos, con campos para nombre del producto, cantidad, categoría, proveedor, fecha de ingreso, entre otros.
- **Historial de Movimientos**: Pantalla para ver el registro completo de todas las interacciones con el inventario.
- **Autenticación**: Pantalla de login para autenticación de usuarios mediante Active Directory.

### Backend (API REST en .NET/C#)
- **Inventario**: CRUD para gestionar el inventario.
- **Autenticación**: Endpoint para autenticar a los usuarios a través de Active Directory.
- **Reportes**: Endpoint para generar y enviar reportes de inventario automáticamente mediante un servidor SMTP.
- **Movimientos**: CRUD para registrar todos los movimientos de inventario, con auditoría de las acciones realizadas por los usuarios.

### Base de Datos (SQL Server)
- **Inventario**: Tabla que almacena todos los productos con sus detalles (nombre, cantidad, categoría, proveedor, etc.).
- **Movimientos**: Tabla que registra cada modificación realizada al inventario (entradas, salidas, ajustes) y quién realizó la acción.
- **Usuarios**: Almacena los usuarios del sistema y sus roles, sincronizado con Active Directory para la autenticación.

## Requisitos Previos
- **Flutter SDK** (para el frontend)
- **.NET Core** (para el backend)
- **SQL Server** (para la base de datos)
- **Active Directory** (para autenticación)
- **Servidor SMTP** (para enviar reportes automáticos)
