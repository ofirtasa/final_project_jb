# Stage 1: SonarQube scan
FROM maven:3.8.4-jdk-8 AS sonarqube

# Install SonarQube Scanner
RUN mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar

# Copy the source code into the container
WORKDIR /app
COPY . .

# Run SonarQube scan
RUN mvn sonar:sonar

# Stage 2: Build the Maven project and create the artifact
FROM maven:3.8.4-jdk-8 AS build

# Copy the source code into the container
WORKDIR /app
COPY . .

# Run the Maven build to package the artifact
RUN ./mvnw package

# Stage 3: Create final image with Java 8 and run the JAR
FROM openjdk:8-jre-alpine AS runtime

# Create a directory for the JAR file
WORKDIR /code

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar /code/

# Set the CMD to run the JAR file
CMD ["sh", "-c", "java -jar /code/*.jar"]
