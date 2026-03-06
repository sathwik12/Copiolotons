# --- Stage 1: Build (The Factory) ---
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app

# 1. Install Maven manually on Alpine
RUN apk add --no-cache maven

# 2. Force-set the environment variables
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# 3. Copy and cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 4. Build the app
COPY src ./src
RUN mvn clean package -DskipTests

# --- Stage 2: Runtime (The Lightweight Car) ---
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# --- NEW: SECURITY (Non-Root User) ---
# We create a system group and user so the app doesn't run as root
RUN addgroup -S springgroup && adduser -S springuser -G springgroup

# Copy the compiled JAR and change ownership to our new user
COPY --from=build --chown=springuser:springgroup /app/target/*.jar app.jar

# Switch to the non-root user
USER springuser

# --- NEW: HEALTHCHECK ---
# Pings the app every 30s. If it fails 3 times, Docker marks it "unhealthy".
# We use 'wget' because it is built into Alpine (no need to install curl).
HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=40s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

EXPOSE 8080

# Run it
ENTRYPOINT ["java", "-jar", "app.jar"]
