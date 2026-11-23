# GRIP Sneaker Store — Backend Etapa 2

Spring Boot 3.5.8, Java 25, Spring Web, Spring Data JPA, MySQL, Spring Security, JWT y Swagger.

## Variables necesarias (PowerShell, desde la carpeta grip-backend)

```powershell
$env:GRIP_DB_PASSWORD = Read-Host 'Clave MySQL grip_app'
$env:GRIP_JWT_SECRET = Read-Host 'Clave JWT aleatoria de 32 caracteres o mas'
$env:GRIP_ADMIN_PASSWORD = Read-Host 'Clave inicial admin (minimo 8 caracteres)'
$env:GRIP_VENDEDOR_PASSWORD = Read-Host 'Clave inicial vendedor (minimo 8 caracteres)'
.\mvnw.cmd spring-boot:run
```

Usuarios iniciales (solo al primer arranque): `ana.perez@duoc.cl` administrador, `carlos.soto@duoc.cl` vendedor. Las claves NO están incluidas en el ZIP ni en GitHub. Cliente: POST `/api/v1/auth/registro`.

Swagger: http://localhost:8080/swagger-ui/index.html

Endpoints: POST `/api/v1/auth/login`, `/registro`, `/refresh`; GET `/api/v1/productos`, GET `/{codigo}` (públicos); POST/PUT/DELETE productos (solo administrador con token Bearer).

JWT access caduca en 15 minutos; refresh en 7 días. El frontend debe renovar la sesión cuando sea necesario. Token de refresco generado y verificado, pero no hay lista de revocación: cerrar sesión elimina los tokens del cliente; para producción utilizar sesiones de refresh revocables / cookies HttpOnly, TLS y gestión de secretos.

La instalación se documenta directamente en el chat. No subir contraseñas ni secretos al repositorio. Esta etapa NO incluye API REST de órdenes ni pruebas de despliegue.


## Etapa 2B — órdenes (Anexo 1)

- `GET /api/v1/ordenes`: listado. Requiere JWT con rol **administrador** o **vendedor**.
- `GET /api/v1/ordenes/{id}`: detalle. Requiere JWT con rol **administrador** o **vendedor**.
- `POST /api/v1/ordenes`: registra una orden desde el servidor para pruebas/flujo de compra; requiere rol **administrador** o **cliente**.

Ejemplo de cuerpo JSON para POST (requiere que el producto `GRIP-PRUEBA` exista y tenga stock):

```json
{
  "cliente": {"nombre": "Cliente", "apellidos": "Prueba", "correo": "cliente.prueba@gmail.com"},
  "items": [{"codigo": "GRIP-PRUEBA", "cantidad": 1}]
}
```

La API calcula los subtotales y el total usando precios persistidos en MySQL. La creación
descuenta stock dentro de una transacción. La tabla `ordenes` y su detalle `orden_items`
se crearán mediante JPA al iniciar con `spring.jpa.hibernate.ddl-auto=update`.

**Pendiente de integración:** el frontend de la Etapa 3 todavía conserva `ordenesService`
con `localStorage`; no se considera integrado el checkout hasta actualizar ese módulo.
El estado `registrada` indica que la orden fue guardada; no representa un cobro real.
