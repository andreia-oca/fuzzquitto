# Eclipse Mosquitto Docker Image
Containers built with this Dockerfile are optimized to be used in fuzzing campaigns.

## Mount Points
A docker mount point has been created in the image to be used for configuration.
```
/mosquitto/config
```

Two docker volumes have been created in the image to be used for persistent storage and logs.
```
/mosquitto/data
/mosquitto/log
```

## Running without a configuration file
Mosquitto 2.0 requires you to configure listeners and authentication before it
will allow connections from anything other than the loopback interface. In the
context of a container, this means you would normally need to provide a
configuration file with your settings.

If you wish to run mosquitto without any authentication, and without setting
any other configuration options, you can do so by using a configuration
provided in the container for this purpose:
```
docker run -it --name fuzzquitto_test -p 1883:1883 fuzzquitto:latest mosquitto -c /mosquitto.conf
```

## Configuration
When creating a container from the image, the default configuration values are used.
To use a custom configuration file, mount a **local** configuration file to `/mosquitto/config/mosquitto.conf`
```
docker run -it -p 1883:1883 -v <absolute-path-to-configuration-file>:/mosquitto/config/mosquitto.conf fuzzquitto:latest
```

Configuration can be changed to:

* persist data to `/mosquitto/data`
* log to `/mosquitto/log/mosquitto.log`

i.e. add the following to `mosquitto.conf`:
```
persistence true
persistence_location /mosquitto/data/

log_dest file /mosquitto/log/mosquitto.log
```

**Note**: For any volume used, the data will be persistent between containers.

## Build
Build and tag the docker image for a specific version:
```
docker build -t fuzzquito:latest  .
```

## Run
Run a container using the new image:
```
docker run -it --name fuzquitto_test -p 1883:1883 -v ./mosquitto.conf:/mosquitto/config/mosquitto.conf -v /mosquitto/data -v /mosquitto/log fuzzquito:latest 
```
