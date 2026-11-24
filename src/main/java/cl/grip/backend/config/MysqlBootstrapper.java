package cl.grip.backend.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.regex.Pattern;

/** Prepara MySQL antes de que Spring Boot configure el DataSource. */
public final class MysqlBootstrapper {
    private static final Pattern IDENTIFIER = Pattern.compile("[A-Za-z0-9_]+");
    private static final String APP_USER = "grip_app";
    private static final String APP_HOST = "localhost";

    private MysqlBootstrapper() {}

    public static void initialize() {
        String host = env("GRIP_DB_HOST", "localhost");
        String port = env("GRIP_DB_PORT", "3306");
        String database = env("GRIP_DB_NAME", "grip_sneaker_store");
        String adminUser = required("GRIP_DB_ADMIN_USER");
        String adminPassword = required("GRIP_DB_ADMIN_PASSWORD");
        String appPassword = required("GRIP_DB_PASSWORD");

        if (!IDENTIFIER.matcher(database).matches()) {
            throw new IllegalStateException("GRIP_DB_NAME solo admite letras, numeros y guion bajo.");
        }

        String url = "jdbc:mysql://" + host + ":" + port
            + "/?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=America/Santiago";
        String schema = "`" + database + "`";
        String account = "'" + APP_USER + "'@'" + APP_HOST + "'";
        String password = escapeSqlLiteral(appPassword);

        System.out.println("[GRIP] Preparando esquema y usuario MySQL...");
        try (Connection connection = DriverManager.getConnection(url, adminUser, adminPassword);
             Statement statement = connection.createStatement()) {

            statement.execute("CREATE DATABASE IF NOT EXISTS " + schema
                + " CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
            statement.execute("CREATE USER IF NOT EXISTS " + account
                + " IDENTIFIED BY '" + password + "'");
            statement.execute("ALTER USER " + account + " IDENTIFIED BY '" + password + "'");
            statement.execute("GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, REFERENCES"
                + " ON " + schema + ".* TO " + account);

            System.out.println("[GRIP] Base de datos " + database + " preparada.");
            System.out.println("[GRIP] Usuario de aplicacion " + APP_USER + " preparado.");
        } catch (SQLException exception) {
            throw new IllegalStateException(
                "No se pudo preparar MySQL. La cuenta administrativa debe tener permisos CREATE, "
                + "CREATE USER y GRANT OPTION. Detalle: " + exception.getMessage(), exception);
        }
    }

    private static String env(String name, String defaultValue) {
        String value = System.getenv(name);
        return value == null || value.isBlank() ? defaultValue : value;
    }

    private static String required(String name) {
        String value = System.getenv(name);
        if (value == null || value.isBlank()) {
            throw new IllegalStateException("Falta la variable de entorno " + name + ".");
        }
        return value;
    }

    private static String escapeSqlLiteral(String value) {
        return value.replace("\\", "\\\\").replace("'", "''");
    }
}
