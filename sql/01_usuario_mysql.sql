-- Ejecutar UNA SOLA VEZ en MySQL Workbench con una cuenta administradora.
-- Spring Boot crea grip_sneaker_store automaticamente al iniciar.
-- Reemplaza CAMBIAR_POR_CLAVE_PRIVADA por la misma clave de GRIP_DB_PASSWORD.
-- El permiso CREATE global permite a Connector/J crear la base si aun no existe.
-- Uso previsto: desarrollo/presentacion local. No expongas este usuario a Internet.

CREATE USER IF NOT EXISTS 'grip_app'@'localhost'
IDENTIFIED BY 'CAMBIAR_POR_CLAVE_PRIVADA';

GRANT CREATE ON *.* TO 'grip_app'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES
ON grip_sneaker_store.* TO 'grip_app'@'localhost';

FLUSH PRIVILEGES;
