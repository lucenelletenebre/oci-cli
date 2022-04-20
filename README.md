# oci-cli

Docker container for runing Oracle Cloud Infranstructure CLI.

Main advantages of this container is it size: less than 30MB compressed. Designed to work on GitHub workflows (less size, faster download)

This version implement only service.core functionality (for my use case I needed only oci.compute, see [here](#Background))

## Usage
One of the ways you can use oci-cli is by passing enviroment variable to the docker file

```bash
docker run --rm -it \
    -e OCI_CLI_USER=<YOUR VALUE>
    -e OCI_CLI_FINGERPRINT=<YOUR VALUE>
    -e OCI_CLI_TENANCY=<YOUR VALUE>
    -e OCI_CLI_REGION=eu-milan-1
    -e OCI_CLI_KEY_FILE=/config/<YOUR PRIVATE PEM FILE>
    -v <YOUR FOLDER WITH PRIVATE PEM FILE>:/config
    ghcr.io/lucenelletenebre/oci-cli-slim \
    <OCI COMMAND (omit oci)>
```

For additional variables refer to [here](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/clienvironmentvariables.htm#CLI_Environment_Variables).

## Background
So, why the hell spend time to pack the oci-cli in onother docker container? Why not use one of the already existing solution? In order to save some money, I wanted to implement an automatic system for stopping an oracle VM during the night, so what better way than to use the GitHub workflow!? But come on, just 500MB for executing 1 comand? So I packed the oci-cli python package using Pyinnstaller

## Note
If you want to expand the service available, modify the file `compile.py` commenting out the line `--collect-all=services.core` and enabling `--collect-all=services` will install all oci services.
Recompile using docker image using `make build` or `docker build -t <IMAGE NAME> .`

## Warning
A fair warning: pretty much all oci-cli funcionality under Pyinstaller is untested in this container! It should work but...