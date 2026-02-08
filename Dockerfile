# Use the same image we know works
FROM public.ecr.aws/docker/library/maven:3.9.6-amazoncorretto-17 AS build

# Set the working directory
WORKDIR /app

# Copy your pom.xml and code INTO the image
COPY . .

# Build the application (skipping tests for speed)
RUN mvn clean package -DskipTests

# Run the app
CMD ["java", "-jar", "target/onsathwiklearning-1.0-SNAPSHOT.jar"]
