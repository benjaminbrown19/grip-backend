-- Ejecutar en Workbench con una conexion de administrador.
-- IMPORTANTE: reemplaza CAMBIAR_POR_CLAVE_PRIVADA antes de ejecutar.
-- Usa una clave propia y NO subas la version modificada a GitHub.
CREATE DATABASE IF NOT EXISTS grip_sneaker_store CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'grip_app'@'localhost' IDENTIFIED BY 'CAMBIAR_POR_CLAVE_PRIVADA';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES ON grip_sneaker_store.* TO 'grip_app'@'localhost';
