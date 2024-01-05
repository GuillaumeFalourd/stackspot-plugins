FROM gradle:8-jdk{{project_java_version}} as builder

RUN mkdir app
COPY . ./app

WORKDIR app
RUN gradle build

FROM openjdk:{{project_java_version}} as final
COPY --from=builder /home/gradle/app/build/libs/*-final.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
