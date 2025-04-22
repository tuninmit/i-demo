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

# Copy the agent JAR files
COPY ./opentelemetry-javaagent.jar /app/opentelemetry-javaagent.jar
COPY ./pyroscope.jar /app/pyroscope.jar
COPY --from=build /app/target/*.jar i.jar

# Expose the application's port (change as needed)
EXPOSE 8080

# Set environment variables for OpenTelemetry
ENV OTEL_SERVICE_NAME=SimpleAPI
ENV OTEL_TRACES_EXPORTER=otlp
ENV OTEL_METRICS_EXPORTER=otlp
ENV OTEL_LOGS_EXPORTER=otlp
ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector-cluster-opentelemetry-collector:4317

# Set environment variables for Pyroscope
ENV PYROSCOPE_APPLICATION_NAME=SimpleAPI
ENV PYROSCOPE_SERVER_ADDRESS=http://pyroscope:4040

# Run the application with both agents
ENTRYPOINT ["java", \
            "-javaagent:/app/opentelemetry-javaagent.jar", \
            "-javaagent:/app/pyroscope.jar", \
            "-Dpyroscope.application.name=${PYROSCOPE_APPLICATION_NAME}", \
            "-Dpyroscope.server.address=${PYROSCOPE_SERVER_ADDRESS}", \
            "-Dpyroscope.format=jfr", \
            "-Dpyroscope.profiler.event=cpu", \
            "-jar", "i.jar"]
