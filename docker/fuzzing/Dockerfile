FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"

# Install common dependencies
RUN apt-get -y update && \
	apt-get -y upgrade && \
    apt-get install -y apt-utils && \
    apt-get install -y tzdata && \
    echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections

# Packages installed for minimal installation
RUN apt-get install -y build-essential cmake gcc make git wget \
	libcjson1 libcjson-dev libssl-dev mosquitto-clients

# Install ASan
RUN apt-get install -y libasan4

# Packages used for code coverage reports
RUN apt-get -y install python3 python3-pip
RUN python3 -m pip install gcovr

# Packages used for debugging (thiese are optional in a prod env)
# If you are using this container for debugging uncomment the line below
RUN apt-get -y install curl wget vim tmux net-tools host
# Also for debugging purposes install sudo 
RUN apt-get -y install sudo

# Switch to non-privileged user
# `mosquitto` is the default user in the `mosquitto.conf` file
ENV UID=1000
ENV GID=1000
ENV USER=mosquitto
ENV PASSWD=mosquitto

# Also for debugging purposes add `mosquitto` to the sudoers file
RUN useradd -m ${USER} --uid=${UID} && echo "${USER}:${PASSWD}" | chpasswd && adduser mosquitto sudo

USER mosquitto
WORKDIR /home/${USER}

# Clone and compile (minimal) Fuzzquitto with ASan
RUN git clone https://github.com/andreia-oca/fuzzquitto.git && \
    cd fuzzquitto && \
    CFLAGS="-g -O0 -fsanitize=address -fno-omit-frame-pointer" LDFLAGS="-g -O0 -fsanitize=address -fno-omit-frame-pointer" make clean all

RUN mkdir -p ./fuzzquitto/config ./fuzzquitto/data ./fuzzquitto/log

VOLUME ["/home/mosquitto/fuzzquitto/data", "/home/mosquitto/fuzzquitto/log"]

COPY --chown=mosquitto:mosquitto mosquitto.conf /home/mosquitto/fuzzquitto/config/mosquitto.conf
COPY docker-entrypoint.sh /
EXPOSE 1883

ENTRYPOINT ["/docker-entrypoint.sh"]
# Start mosquitto
CMD ./fuzzquitto/src/mosquitto -c /home/mosquitto/fuzzquitto/config/mosquitto.conf
