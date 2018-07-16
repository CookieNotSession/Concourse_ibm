FROM ibmjava:8-sfj
MAINTAINER IBM Java engineering at IBM Cloud

COPY target/twewcweightloss2018-1.0-SNAPSHOT.jar /app.jar

ENV JAVA_OPTS=""
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]
