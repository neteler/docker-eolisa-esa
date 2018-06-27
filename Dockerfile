FROM fedora:latest

# Install Oracle Java 8
ENV JAVA_VER 8
ENV JAVA_HOME /usr/java/latest

# Change every time Java and EOLISA are updated, see
# - https://www.java.com/en/download/
# - https://earth.esa.int/web/guest/eoli

ENV JAVA_RPM jre-8u171-linux-x64.rpm
ENV EOLISA   eoli-9.7.2-linux.rpm

# Store RPMs in current dir on local machine
COPY $JAVA_RPM /tmp/$JAVA_RPM
COPY $EOLISA /tmp/$EOLISA

RUN dnf update -y
RUN rpm -e --nodeps coreutils-single
RUN dnf install coreutils -y
RUN dnf install -y /tmp/$JAVA_RPM && rm -rf /tmp/$JAVA_RPM && java -version

# install EOLISA + dependencies
RUN dnf install -y /tmp/$EOLISA libXext libXrender libXtst libXxf86vm libXxf86vm-devel firefox
RUN eolisa --help

# Define default command.
CMD ["bash"]

### to run this:
# sudo xhost +local:docker
# find docker ID
# sudo docker ps -a
# ID=4819a1b79479
# sudo docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY $ID eolisa 
# sudo xhost -local:docker
