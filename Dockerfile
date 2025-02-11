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
    hdf5-dev

# Install the requirements from Pipfile globally
COPY DEMKit/Pipfile /app/Pipfile
COPY DEMKit/pipfile2req.py /app/pipfile2req.py
WORKDIR /app
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
COPY DEMKit/docker /app/demkit/docker
COPY DEMKit/scripts /app/demkit/scripts
COPY DEMKit/example /app/demkit/example

RUN mkdir /zmq
RUN mkdir /app/workspace

WORKDIR /app/demkit/
RUN rm -Rf docker

# # Now setup DEMKit itself
WORKDIR /app/demkit

# Finally export everything
VOLUME /app/workspace
VOLUME /root/.ssh

# Set the default environment variables
ENV DEMKIT_COMPONENTS=/app/demkit/components/
ENV DEMKIT_INFLUXURL=http//influx
ENV DEMKIT_INFLUXPORT=8068
ENV DEMKIT_INFLUXDB=dem
ENV DEMKIT_INFLUXUSER=demkit

RUN chmod +x ./scripts/autoexec.sh

CMD ["./scripts/autoexec.sh"]
