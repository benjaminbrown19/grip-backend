# GRIP Sneaker Store — Backend

API REST para GRIP Sneaker Store, desarrollada con Java 25 y Spring Boot 3.5.8. Utiliza Spring Web, Spring Data JPA, MySQL, Spring Security, JWT y Swagger/OpenAPI (springdoc).

## Requisitos

- JDK 25.
- MySQL 8 en ejecución.
- PowerShell en Windows (los comandos de ejemplo usan \`mvnw.cmd\`).

## Preparar MySQL por primera vez

1. Abrir \`sql/01_usuario_mysql.sql\` con una cuenta administradora de MySQL.
2. Reemplazar \`CAMBIAR_POR_CLAVE_PRIVADA\` por una clave propia y ejecutar el script. Crea la base \`grip_sneaker_store\` y el usuario \`grip_app\` con permisos sobre esa base.
3. No subir a GitHub una copia del script que contenga la clave real.

## Variables de entorno e inicio

Desde PowerShell, en la carpeta \`grip-backend\`:

\`\`\`powershell
$env:GRIP_DB_PASSWORD = Read-Host 'Clave MySQL grip_app'
$env:GRIP_JWT_SECRET = Read-Host 'Secreto JWT aleatorio de al menos 32 caracteres'
$env:GRIP_ADMIN_PASSWORD = Read-Host 'Clave inicial administrador (mínimo 8 caracteres)'
$env:GRIP_VENDEDOR_PASSWORD = Read-Host 'Clave inicial vendedor (mínimo 8 caracteres)'
.\mvnw.cmd spring-boot:run
\`\`\`

Las cuentas iniciales se crean solo si sus variables de contraseña están definidas, cumplen la longitud mínima y el correo aún no existe. Si no se definen, el backend no crea esas cuentas automáticamente.

Hibernate utiliza \`spring.jpa.hibernate.ddl-auto=update\` para crear o actualizar las tablas al iniciar. Esta configuración no crea por sí sola la base de datos ni el usuario MySQL. Después del primer arranque, se puede ejecutar \`sql/02_productos_iniciales.sql\` para cargar el catálogo de demostración.

El servidor escucha en \`127.0.0.1:8080\`. Swagger está disponible en:

http://127.0.0.1:8080/swagger-ui/index.html

## Endpoints y permisos

Prefijo de la API: \`/api/v1\`.

| Método y ruta | Acceso |
| --- | --- |
| \`POST /auth/login\` | Público. |
| \`POST /auth/registro\` | Público; crea siempre una cuenta con rol cliente. |
| \`POST /auth/refresh\` | Público con refresh token válido. |
| \`GET /productos\`, \`GET /productos/{codigo}\` | Público. |
| \`POST /productos\`, \`PUT /productos/{codigo}\`, \`DELETE /productos/{codigo}\` | Solo administrador. |
| \`POST /ordenes/checkout\` | Público; el backend fuerza el canal \`online\`. |
| \`POST /ordenes\` | Administrador o vendedor; registra una venta interna. |
| \`GET /ordenes\`, \`GET /ordenes/{id}\` | Administrador o vendedor. |

Una venta presencial válida del vendedor debe poder registrarse mediante \`POST /api/v1/ordenes\`; no corresponde esperar HTTP 403 para ese rol. El checkout público utiliza el endpoint distinto \`POST /api/v1/ordenes/checkout\`.

## Seguridad

- Roles: \`administrador\`, \`vendedor\` y \`cliente\`.
- Las contraseñas se almacenan mediante BCrypt.
- JWT de acceso con vigencia de 15 minutos y refresh token con vigencia de 7 días.
- El backend vuelve a leer y validar el rol en cada solicitud protegida.
- No existe lista de revocación de refresh tokens. Cerrar sesión en el frontend elimina los tokens del navegador, pero no revoca un token ya emitido.
- En el flujo actual, los datos del vendedor se reciben como metadatos en el cuerpo de la venta; el backend no los deriva directamente del usuario autenticado. Para un entorno productivo se recomienda asociar el vendedor al sujeto del JWT en el servidor.

No subir contraseñas, secretos JWT, tokens ni archivos \`.env\` al repositorio.

## Reglas de órdenes e inventario

- El servidor utiliza precios y descuentos vigentes en MySQL; el navegador envía código de producto y cantidad.
- Se validan productos existentes, cantidades positivas, productos no duplicados y stock suficiente.
- El descuento de inventario se realiza dentro de una transacción y utiliza bloqueo de fila para reducir el riesgo de sobreventa concurrente.
- Cupones admitidos: \`GRIP10\` (10 %) y \`GRIP20\` (20 %).
- El retiro en tienda no tiene costo de envío. El despacho cuesta $3.990 cuando el subtotal es inferior a $50.000; desde $50.000 es gratuito.
- Los estados de orden, comprobantes y datos de autorización representan una simulación académica; no hay conexión con una pasarela bancaria real.

## Pruebas

\`\`\`powershell
.\mvnw.cmd clean test
\`\`\`

El conjunto actual contiene dos pruebas unitarias en \`ProductoServiceTest.java\`, enfocadas en escenarios de producto inexistente. No existe un reporte JaCoCo validado, por lo que no se declara un porcentaje de cobertura Java. Estas pruebas no constituyen una suite automatizada integral de órdenes, JWT o autorización por roles.

## Alcance actual y limitaciones

- MySQL local es el entorno de ejecución documentado.
- El repositorio no contiene actualmente \`Dockerfile\` ni \`docker-compose.yml\`.
- El backend persiste cuentas de autenticación, productos, órdenes y líneas de orden. Los módulos locales de categorías y usuarios del panel no corresponden a entidades REST persistidas.
