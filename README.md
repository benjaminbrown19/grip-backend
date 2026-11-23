# GRIP Sneaker Store - Backend

Spring Boot 3.5.8, Java 25, Spring Web, Spring Data JPA, MySQL, Spring Security, JWT y Swagger (springdoc).

## Variables necesarias (PowerShell, desde la carpeta grip-backend)

```powershell
$env:GRIP_DB_PASSWORD = Read-Host 'Clave MySQL grip_app'
$env:GRIP_JWT_SECRET = Read-Host 'Clave JWT aleatoria de 32 caracteres o mas'
$env:GRIP_ADMIN_PASSWORD = Read-Host 'Clave inicial admin (minimo 8 caracteres)'
$env:GRIP_VENDEDOR_PASSWORD = Read-Host 'Clave inicial vendedor (minimo 8 caracteres)'
.\mvnw.cmd spring-boot:run
```

Antes del primer arranque ejecutar `sql/01_usuario_mysql.sql` (reemplazando la clave). Después del primer arranque, `sql/02_productos_iniciales.sql` carga el catálogo.

Si `GRIP_ADMIN_PASSWORD` o `GRIP_VENDEDOR_PASSWORD` no están definidas (o tienen menos de 8 caracteres), esas cuentas no se crean. Las claves NO se suben a GitHub.

Swagger: http://localhost:8080/swagger-ui/index.html (botón Authorize: pegar el `accessToken` devuelto por login).

## Endpoints (prefijo `/api/v1`)

| Método y ruta | Acceso |
| --- | --- |
| POST `/auth/login`, `/auth/registro`, `/auth/refresh` | Público (el registro crea siempre rol cliente) |
| GET `/productos`, GET `/productos/{codigo}` | Público |
| POST `/productos`, PUT `/productos/{codigo}`, DELETE `/productos/{codigo}` | Administrador |
| POST `/ordenes/checkout` | Público (compra de tienda, canal siempre `online`) |
| POST `/ordenes` | Administrador o vendedor (registro de venta en tienda, canal `online` o `vendedor`) |
| GET `/ordenes`, GET `/ordenes/{id}` | Administrador o vendedor |

## Seguridad

- Contraseñas con BCrypt. Roles: `administrador`, `vendedor`, `cliente`.
- JWT de acceso (15 min) y de refresco (7 días), firmados con HMAC. El rol se vuelve a leer desde la base de datos en cada solicitud.
- `/auth/refresh` valida que el token sea de tipo `refresh` y emite un nuevo par de tokens. No hay lista de revocación: cerrar sesión elimina los tokens del cliente. En producción usar refresh revocable o cookies HttpOnly, TLS y gestión de secretos.

## Órdenes

La API calcula subtotales, descuento por cupón (`GRIP10`, `GRIP20`), envío y total con los precios guardados en MySQL; el cliente solo envía código y cantidad. La creación descuenta el stock dentro de una transacción con bloqueo de fila. El estado `registrada` o `pagada` no representa un cobro real. Las tablas `ordenes` y `orden_items` se crean con JPA (`ddl-auto=update`).

## Pruebas

```powershell
.\mvnw.cmd test
```
