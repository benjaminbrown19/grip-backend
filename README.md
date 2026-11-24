# GRIP Sneaker Store — Backend

API REST de GRIP desarrollada con Java 25 y Spring Boot 3.5.8, MySQL, Spring Security, JWT y Swagger.

## Requisitos
- JDK 25.
- MySQL Server 8 instalado y en ejecucion.
- Cuenta administrativa MySQL autorizada para CREATE, CREATE USER y GRANT OPTION.
- PowerShell en Windows.

MySQL Workbench es opcional para iniciar la aplicacion.

## Inicializacion automatica
Antes de iniciar Spring Boot, GRIP se conecta a MySQL con GRIP_DB_ADMIN_USER y GRIP_DB_ADMIN_PASSWORD. Crea el esquema grip_sneaker_store si no existe, crea o actualiza grip_app, y concede a ese usuario permisos unicamente sobre el esquema GRIP. Luego Spring Boot utiliza grip_app para operar. La cuenta administrativa no se utiliza en el pool JDBC de la aplicacion.

Hibernate crea o actualiza las tablas. ProductosIniciales carga los ocho productos solo cuando la tabla esta vacia. Los datos existentes no se eliminan al reiniciar.

La cuenta administrativa necesita permisos CREATE, CREATE USER y GRANT OPTION. Si el computador institucional restringe esas operaciones, solicita a informatica una cuenta autorizada.

## Inicio en PowerShell
Desde la carpeta grip-backend:

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

La clave administrativa se solicita de forma interactiva y no se guarda en Git. La contraseña de grip_app se sincroniza con GRIP_DB_PASSWORD en cada inicio. Las contraseñas simples del ejemplo son solo para demostracion local; no usarlas en produccion.

Swagger: http://127.0.0.1:8080/swagger-ui/index.html

## Reinicios
No es necesario ejecutar SQL manual ni abrir Workbench. Inicia MySQL y vuelve a ejecutar el bloque anterior. El inicializador verifica y prepara el esquema y usuario, pero no elimina datos.

## Pruebas
```powershell
.\mvnw.cmd clean test
```

No subir contraseñas, tokens ni secretos reales al repositorio.
