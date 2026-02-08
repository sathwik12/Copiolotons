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

# Copy the compiled JAR
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Run it
ENTRYPOINT ["java", "-jar", "app.jar"]
