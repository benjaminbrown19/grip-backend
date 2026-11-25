# Imagen del backend GRIP (monolito Evaluacion 3).
# Etapa 1: compila el JAR con Maven y Java 25.
FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests package

# Etapa 2: imagen liviana que solo ejecuta el JAR.
FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/target/grip-backend-0.1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-Xmx512m", "-jar", "app.jar"]
