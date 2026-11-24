# GRIP — Inicio rápido con MySQL local (sin Docker)

Esta guía es para los computadores que ya tienen MySQL Server instalado. No requiere Docker.

## Primera vez en cada computador

1. Verificar que el servicio MySQL Server esté iniciado.
2. Abrir MySQL Workbench y conectarse con una cuenta administradora.
3. Abrir `sql/01_usuario_mysql.sql` y reemplazar `CAMBIAR_POR_CLAVE_PRIVADA` por la contraseña que utilizará la aplicación.
4. Ejecutar el script una sola vez. Crea el usuario `grip_app` y los permisos necesarios. No crea la base de datos.
5. Al iniciar Spring Boot, Connector/J crea automáticamente `grip_sneaker_store` si no existe; Hibernate crea las tablas y `ProductosIniciales` carga el catálogo si la tabla de productos está vacía.

## Iniciar backend

En PowerShell, dentro de la carpeta del backend:

```powershell
$env:GRIP_DB_HOST = "localhost"
$env:GRIP_DB_PORT = "3306"
$env:GRIP_DB_NAME = "grip_sneaker_store"
$env:GRIP_DB_USER = "grip_app"
$env:GRIP_DB_PASSWORD = Read-Host 'Clave MySQL grip_app'
$env:GRIP_JWT_SECRET = Read-Host 'Secreto JWT aleatorio de al menos 32 caracteres'
$env:GRIP_ADMIN_PASSWORD = Read-Host 'Clave inicial administrador (mínimo 8 caracteres)'
$env:GRIP_VENDEDOR_PASSWORD = Read-Host 'Clave inicial vendedor (mínimo 8 caracteres)'
.\mvnw.cmd spring-boot:run
```

Esperar el mensaje de inicio correcto. Swagger: http://127.0.0.1:8080/swagger-ui/index.html

## Iniciar frontend

En otra ventana de PowerShell, dentro de la carpeta del frontend:

```powershell
npm ci
npm run dev
```

Tienda: http://localhost:5173

## Siguientes ejecuciones

No volver a ejecutar el script SQL. Iniciar MySQL, backend y frontend. La base, las cuentas, las ventas y el inventario existentes se conservan. No eliminar la base desde Workbench si se desea mantener los datos.

## Consideraciones

- Si MySQL usa un puerto diferente, cambiar `GRIP_DB_PORT`.
- Si el usuario `grip_app` ya existe, `CREATE USER IF NOT EXISTS` no modifica su contraseña.
- El permiso global `CREATE` del usuario de aplicación se concede para facilitar la creación automática de la base en desarrollo local. No exponer ese usuario a Internet.
- Las cuentas iniciales de administrador y vendedor se crean solo si aún no existen y se proporcionan sus variables de contraseña.
- Cada computador mantiene una base local independiente.
