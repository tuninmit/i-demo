FROM maven:3.9.6-eclipse-temurin-17-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy Maven configuration and dependencies
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Create a new stage with a minimal runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy the built JAR file from the build stage
COPY ./opentelemetry-javaagent.jar /app/opentelemetry-javaagent.jar
COPY --from=build /app/target/*.jar i.jar

# Expose the application's port (change as needed)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "i.jar"]
