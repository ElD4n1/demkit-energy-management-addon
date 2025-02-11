# Use an official Python runtime as a parent image
#FROM arm64v8/python:3.7-alpine3.18
FROM amd64/python:3.7-alpine3.18

# Install packages
RUN apk update && \
    apk add --no-cache python3-dev \
    build-base \
    gfortran file binutils \
    openblas-dev \
    libstdc++ openblas \
    openssh \
    openssh-keygen \
    git \
    libzmq \
    zeromq-dev \
    hdf5-dev \
    jobs.crontab

# Install the requirements from Pipfile globally
COPY DEMKit/Pipfile /app/demkit/Pipfile
COPY pipfile2req.py /app/demkit/pipfile2req.py
WORKDIR /app/demkit
RUN pip install requirementslib pydantic==1.*
RUN python pipfile2req.py
RUN pip install cython==0.29.37 numpy pybind11 pythran pkgconfig
RUN apk add linux-headers libc-dev g++ alpine-sdk
RUN pip install -r requirements.txt --no-build-isolation

# Create an ssh key
RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub

WORKDIR /app/demkit

# Copy the sources that we require
COPY DEMKit/components /app/demkit/components
# TODO use usrconf.py instead of env variables
COPY DEMKit/conf /app/demkit/conf
COPY DEMKit/tmp /app/demkit/tmp
COPY DEMKit/tools /app/demkit/tools
COPY DEMKit/demkit.py /app/demkit/
COPY DEMKit/scripts /app/demkit/scripts
COPY DEMKit/example /app/demkit/example

RUN mkdir /zmq
RUN mkdir /app/workspace

# Set the default environment variables
ENV DEMKIT_COMPONENTS=/app/demkit/components/
ENV DEMKIT_INFLUXURL=http//influx
ENV DEMKIT_INFLUXPORT=8068
ENV DEMKIT_INFLUXDB=dem
ENV DEMKIT_INFLUXUSER=demkit

# Install the forecast weather library
COPY PVLib/forecast_weather /app/forecast_weather
COPY pipfile2req.py /app/forecast_weather/pipfile2req.py
WORKDIR /app/forecast_weather
RUN python pipfile2req.py && pip install -r requirements.txt && rm -f requirements.txt pipfile2req.py Pipfile
RUN sed 's|%INSTALL_PATH%|/app/forecast_weather|g' /etc/periodic/jobs.crontab

# Finally export everything
VOLUME /app/workspace
VOLUME /root/.ssh

RUN chmod +x ./scripts/autoexec.sh

CMD ["./scripts/autoexec.sh"]
