# Step 1: Run SonarQube to check the code (SonarQube scanner)
FROM sonarsource/sonar-scanner-cli AS sonarqube

WORKDIR /app

# Copy the project files to the image
COPY . .

# Run SonarQube analysis 
RUN sonar-scanner -Dsonar.projectKey=sonarqubeProject \
    -Dsonar.sources=. \
    -Dsonar.host.url=http://localhost:9000 \
    -Dsonar.login=[![Quality Gate Status](http://localhost:9000/api/project_badges/measure?project=sonarqubeProject&metric=alert_status&token=sqb_b8244d7d892ca32462c6ab891507dc379f63f924)](http://localhost:9000/dashboard?id=sonarqubeProject)

# Step 2: Build the project with Maven
FROM maven:3.8.7-openjdk-18 AS builder

WORKDIR /app

# Copy all project files
COPY . .

# Make the mvnw file executable
RUN chmod +x ./mvnw  

# Run the Maven build to package the artifact
RUN ls -l ~
RUN ./mvnw package 

# Step 3: Create the final image with Java 8
FROM openjdk:8-jre AS runtime

WORKDIR /code

# Copy the JAR file from the Maven build step
COPY --from=builder /app/target/*.jar app.jar

# Set the default command to run the JAR
CMD ["java", "-jar", "app.jar"]
