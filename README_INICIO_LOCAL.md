# GRIP — Inicio automatico con MySQL local (Windows 11, sin Docker)

## Requisitos
- Windows 11, MySQL Server 8, JDK 25 y Node.js/npm.
- Una cuenta administrativa MySQL con permisos CREATE, CREATE USER y GRANT OPTION.
- MySQL Workbench es opcional.

## Primera ejecucion y reinicios
Abre PowerShell en la carpeta grip-backend y ejecuta:

```powershell
$env:GRIP_DB_HOST = "localhost"
$env:GRIP_DB_PORT = "3306"
$env:GRIP_DB_NAME = "grip_sneaker_store"
$env:GRIP_DB_ADMIN_USER = "root"
$env:GRIP_DB_ADMIN_PASSWORD = Read-Host 'Clave administrativa MySQL'
$env:GRIP_DB_PASSWORD = "12345678"
$env:GRIP_JWT_SECRET = "GRIP_SECRET_KEY_2026_FULLSTACK_EVALUACION_3"
$env:GRIP_ADMIN_PASSWORD = "12345678"
$env:GRIP_VENDEDOR_PASSWORD = "12345678"
.\mvnw.cmd spring-boot:run
```

El backend crea el esquema grip_sneaker_store, crea o actualiza el usuario grip_app y concede permisos solo sobre esa base. Luego Spring Boot inicia usando grip_app. Hibernate crea las tablas y se insertan ocho productos si la tabla productos esta vacia.

La cuenta administrativa necesita permisos CREATE, CREATE USER y GRANT OPTION. Si la universidad restringe estas operaciones, solicita a informatica una cuenta autorizada. No es posible omitir los permisos del servidor.

En otra ventana de PowerShell, dentro de sneaker-store:

```powershell
npm ci
npm run dev
```

Tienda: http://localhost:5173
Swagger: http://127.0.0.1:8080/swagger-ui/index.html

En los siguientes inicios, repite el bloque de backend y ejecuta npm run dev en frontend. No se requiere SQL manual ni se eliminan los datos.

Las claves 12345678 son solo para demostracion local. No publicar credenciales reales ni utilizarlas en produccion.
