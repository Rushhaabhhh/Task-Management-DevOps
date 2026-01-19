# ===============================
# Build stage
# ===============================
FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN apk add --no-cache maven && \
    mvn clean package -DskipTests


# ===============================
# Runtime stage
# ===============================
FROM eclipse-temurin:17-jre-alpine

# Metadata
LABEL maintainer="rushhaabhhh" \
      description="Secure Task Management API" \
      version="1.0"

# Create non-root user
RUN addgroup -g 1001 appgroup && \
    adduser -D -u 1001 -G appgroup appuser

WORKDIR /app

# Copy application JAR
COPY --from=builder --chown=appuser:appuser /app/target/*.jar app.jar

# Switch to non-root user
USER appuser

EXPOSE 8080

# Healthcheck (requires Spring Boot Actuator)
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# JVM container optimizations
ENV JAVA_OPTS="-XX:+UseContainerSupport \
               -XX:MaxRAMPercentage=75.0 \
               -XX:InitialRAMFraction=2 \
               -XX:MinRAMPercentage=50.0 \
               -XX:MaxGCPauseMillis=100 \
               -Djava.security.egd=file:/dev/./urandom"

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
