FROM python:3.10.4-alpine3.15 AS build-stage

WORKDIR /app

# requirement for building and installing python module cryptography
# https://cryptography.io/en/latest/installation/#building-cryptography-on-linux
COPY apk-req.txt ./
RUN xargs apk add < apk-req.txt

# install virtual enviroment and manually activate it
ENV VIRTUAL_ENV=/app/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# install python dependencies
COPY pip-req.txt ./
RUN xargs -I mypack pip install --upgrade mypack < pip-req.txt

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
FROM alpine:3.16.0

COPY --from=build-stage /app/dist/oci.exe /oci.exe

ENTRYPOINT ["/oci.exe/oci.exe"]
# ENTRYPOINT  ["/bin/ash", "-c", "/oci.exe/oci.exe \"$0\" \"$@\"", "--"]
# ENTRYPOINT echo "bello>" "$0" "$@" "<xxx"
# ENTRYPOINT /oci.exe/oci.exe "$0" "$@"