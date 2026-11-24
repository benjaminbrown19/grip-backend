package cl.grip.backend;

import cl.grip.backend.config.MysqlBootstrapper;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class GripBackendApplication {
    public static void main(String[] args) {
        // Preparar esquema y usuario antes de inicializar el DataSource de Spring.
        MysqlBootstrapper.initialize();
        SpringApplication.run(GripBackendApplication.class, args);
    }
}
