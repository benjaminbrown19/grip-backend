# GRIP Sneaker Store — Backend

API REST para GRIP Sneaker Store, desarrollada con Java 25 y Spring Boot 3.5.8. Utiliza Spring Web, Spring Data JPA, MySQL, Spring Security, JWT y Swagger/OpenAPI (springdoc).

## Requisitos

- JDK 25.
- MySQL 8 instalado y en ejecución.
- PowerShell en Windows (los comandos de ejemplo usan `mvnw.cmd`).

## Preparación de MySQL (una sola vez por computador)

1. Abrir `sql/01_usuario_mysql.sql` en MySQL Workbench con una cuenta administradora.
2. Reemplazar `CAMBIAR_POR_CLAVE_PRIVADA` por una contraseña propia y ejecutar el script una sola vez. Crea el usuario `grip_app` y los permisos necesarios; no crea manualmente la base.
3. El backend utiliza `createDatabaseIfNotExist=true`: al iniciar, crea `grip_sneaker_store` si todavía no existe. El usuario `grip_app` requiere el permiso global `CREATE` para esa operación.
4. No subir a GitHub una copia del script con una contraseña real.

El permiso global `CREATE` permite crear esquemas en esa instancia MySQL. Esta configuración está pensada para desarrollo y presentación local; no expongas este usuario a Internet ni lo utilices como cuenta administrativa general.

Si `grip_app` ya existe, `CREATE USER IF NOT EXISTS` no cambia su contraseña. En ese caso, conserva la contraseña configurada en MySQL o actualízala desde Workbench.

## Variables de entorno e inicio

Desde PowerShell, en la carpeta `grip-backend`:

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

Las cuentas iniciales se crean solo si sus variables de contraseña están definidas, cumplen la longitud mínima y el correo aún no existe. Si no se definen, el backend no crea esas cuentas automáticamente.

Hibernate utiliza `spring.jpa.hibernate.ddl-auto=update` para crear o actualizar las tablas al iniciar. La clase `ProductosIniciales` carga automáticamente los ocho productos de demostración cuando la tabla `productos` está vacía. No es necesario importar `sql/02_productos_iniciales.sql`.

Los datos existentes no se reinician al arrancar: el catálogo solo se inserta cuando la tabla está vacía. Las ventas, cuentas y cambios de stock se conservan mientras no se elimine la base de datos.

El servidor escucha en `127.0.0.1:8080`. Swagger está disponible en:

http://127.0.0.1:8080/swagger-ui/index.html

No subir contraseñas, secretos JWT, tokens ni archivos con credenciales a GitHub.

## Endpoints y permisos

Prefijo de la API: `/api/v1`.

| Método y ruta | Acceso |
| --- | --- |
| `POST /auth/login` | Público. |
| `POST /auth/registro` | Público; crea siempre una cuenta con rol cliente. |
| `POST /auth/refresh` | Público con refresh token válido. |
| `GET /productos`, `GET /productos/{codigo}` | Público. |
| `POST /productos`, `PUT /productos/{codigo}`, `DELETE /productos/{codigo}` | Solo administrador. |
| `POST /ordenes/checkout` | Público; el backend fuerza el canal `online`. |
| `POST /ordenes` | Administrador o vendedor; registra una venta interna. |
| `GET /ordenes`, `GET /ordenes/{id}` | Administrador o vendedor. |

Una venta presencial válida del vendedor debe poder registrarse mediante `POST /api/v1/ordenes`; no corresponde esperar HTTP 403 para ese rol. El checkout público utiliza el endpoint distinto `POST /api/v1/ordenes/checkout`.

## Seguridad

- Roles: `administrador`, `vendedor` y `cliente`.
- Las contraseñas se almacenan mediante BCrypt.
- JWT de acceso con vigencia de 15 minutos y refresh token con vigencia de 7 días.
- El backend vuelve a leer y validar el rol en cada solicitud protegida.
- No existe lista de revocación de refresh tokens. Cerrar sesión en el frontend elimina los tokens del navegador, pero no revoca un token ya emitido.
- En el flujo actual, los datos del vendedor se reciben como metadatos en el cuerpo de la venta; el backend no los deriva directamente del usuario autenticado. Para un entorno productivo se recomienda asociar el vendedor al sujeto del JWT en el servidor.

No subir contraseñas, secretos JWT, tokens ni archivos `.env` al repositorio.

## Reglas de órdenes e inventario

- El servidor utiliza precios y descuentos vigentes en MySQL; el navegador envía código de producto y cantidad.
- Se validan productos existentes, cantidades positivas, productos no duplicados y stock suficiente.
- El descuento de inventario se realiza dentro de una transacción y utiliza bloqueo de fila para reducir el riesgo de sobreventa concurrente.
- Cupones admitidos: `GRIP10` (10 %) y `GRIP20` (20 %).
- El retiro en tienda no tiene costo de envío. El despacho cuesta $3.990 cuando el subtotal es inferior a $50.000; desde $50.000 es gratuito.
- Los estados de orden, comprobantes y datos de autorización representan una simulación académica; no hay conexión con una pasarela bancaria real.

## Pruebas

```powershell
.\mvnw.cmd clean test
```

El conjunto actual contiene dos pruebas unitarias en `ProductoServiceTest.java`, enfocadas en escenarios de producto inexistente. No existe un reporte JaCoCo validado, por lo que no se declara un porcentaje de cobertura Java. Estas pruebas no constituyen una suite automatizada integral de órdenes, JWT o autorización por roles.

## Alcance actual y limitaciones

- MySQL local es el entorno de ejecución documentado.
- El backend persiste cuentas de autenticación, productos, órdenes y líneas de orden. Los módulos locales de categorías y usuarios del panel no corresponden a entidades REST persistidas.
