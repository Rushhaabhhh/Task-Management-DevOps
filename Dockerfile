# ============================================
# Multi-Stage Dockerfile for Spring Boot App
# ============================================

# Stage 1: Build Stage (Not used in CI, JAR built by Maven in pipeline)
FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN apk add --no-cache maven && \
    mvn clean package -DskipTests

# Stage 2: Runtime Stage (Optimized for production)
FROM eclipse-temurin:17-jre-alpine

# Metadata
LABEL maintainer="devops@example.com"
LABEL description="Secure Task Management API"
LABEL version="1.0.0"

# Create non-root user for security
RUN addgroup -g 1001 appuser && \
    adduser -D -u 1001 -G appuser appuser

# Set working directory
WORKDIR /app

# Copy JAR from target directory (built by CI pipeline)
COPY --chown=appuser:appuser target/*.jar app.jar

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# JVM optimization for containers
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

# Run application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]