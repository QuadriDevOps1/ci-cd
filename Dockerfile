FROM tomcat:8-jre11

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/sscademy-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]








# FROM openjdk:8 AS BUILD_IMAGE
# RUN apt update && apt install maven -y && apt install git -y
# RUN git clone -b docker https://github.com/QuadriDevOps1/sscademy_devops.git
# RUN cd sscademy_devops && mvn install

# FROM tomcat:8-jre11
# RUN rm -rf /usr/local/tomcat/webapps/*
# COPY --from=BUILD_IMAGE sscademy_devops/target/sscademy-v2.war /usr/local/tomcat/webapps/ROOT.war
# EXPOSE 8080
# CMD ["catalina.sh", "run"]