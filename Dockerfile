FROM python:3.10.2-alpine AS build-stage

WORKDIR /app

# requirement for building and installing python module cryptography
# https://cryptography.io/en/latest/installation/#building-cryptography-on-linux
RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo

# install virtual enviroment and manually activate it
ENV VIRTUAL_ENV=/app/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install --upgrade pip && pip install wheel

# install python dependacies
COPY requirement.txt ./
RUN pip install -r requirement.txt

# mod oci-cli
# in order to run oci-cli from pyinstaller we need to modify the source code,
# the part that load the "services" (compute, etc...)
# must be in the correct folder
COPY oci-mod.py ./
RUN python oci-mod.py

# compile with PyInstaller
COPY compile.py ./
RUN mv /app/venv/bin/oci /app/ && python compile.py

# FROM gcr.io/distroless/base-debian11
# FROM gcr.io/distroless/static-debian11
# FROM python:3.10.2-bullseye
FROM alpine:latest

COPY --from=build-stage /app/dist/oci.exe /oci.exe

ENTRYPOINT ["/oci.exe/oci.exe"]
# ENTRYPOINT  ["/bin/ash", "-c", "/oci.exe/oci.exe \"$0\" \"$@\"", "--"]
# ENTRYPOINT echo "bello>" "$0" "$@" "<xxx"
# ENTRYPOINT /oci.exe/oci.exe "$0" "$@"