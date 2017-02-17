# IBM API Connect on Docker

## Overview

Designed for organizations looking to streamline and accelerate their journey into the API economy, [IBM API Connect] is a comprehensive management solution that addresses all four aspects of the API lifecycle: create, run, manage and secure. This makes API Connect far more cost-effective than limited point solutions that focus on just a few lifecycle phases and can end up collectively costing more as organizations piece components together.

By installing IBM® API Connect Docker images, you can run a complete IBM API Connect on-premises environment on your local machine.
A Docker installation of IBM API Connect is only for development use; it is not supported in a production environment.

## System Requirements
This package requires a minimum of 8GB RAM and 2 CPUs.

You must install the following software on a supported operating system:

* docker 1.12.0 or later.
* docker-compose 1.8.1 or later.
* IBM API Connect Toolkit

## License Acceptance

To use the package, you must accept the license terms. If you do not assert that you have accepted the license, the IBM API Connect services will not start successfully.

You can view all the license files directly in the package: LICENSE.txt, non_ibm_license.txt and notices.txt, or with the command
```
docker run -it --rm --env SHOW_LICENSE=1 ibmcom/apiconnect:manager-v5.0.6.0
```

You can assert license acceptance by specifying the environment variable `ACCEPT_LICENSE=true` in .env file.

## Environment Setup
Before run the package, you need to edit .env file to access license and set SMTP configuration.
```
ACCEPT_LICENSE=true                         (required)
SMTP_HOST=smtp_server_hostname_or_address   (required)
SMTP_PORT=smtp_port_value                   (required)
SMTP_SENDER=sender_email_address            (required)
SMTP_USERNAME=smtp_username                 (optional)
SMTP_PASSWORD=smtp_password                 (optional, unless SMTP_USERNAME is set)
```

## Startup Options

There are 2 options to run IBM API Connect docker images. You can either use DataPower Gateway or Micro Gateway as the gateway service. Please refer to the following link for detailed steps.

* [Using DataPower Gateway](https://github.com/strongloop/apiconnect-docker/blob/master/README-datapower.md)
* [Using Micro Gateway](https://github.com/strongloop/apiconnect-docker/blob/master/README-microgateway.md)

## Links to Resources

* [IBM API Connect]
* [IBM API Connect in a Docker container]
* [IBM DataPower Gateway]
* [Micro Gateway]
* [LoopBack]


[IBM API Connect Product Documentation]: <http://www.ibm.com/support/knowledgecenter/SSMNED>
[IBM API Connect]:  <http://www-03.ibm.com/software/products/en/api-connect>
[IBM API Connect in a Docker container]: <https://www.ibm.com/support/knowledgecenter/en/SSMNED_5.0.0/com.ibm.apic.install.doc/tapic_docker_install.html>
[IBM DataPower Gateway]: <https://hub.docker.com/r/ibmcom/datapower/>
[Micro Gateway]: <https://github.com/strongloop/microgateway>
[LoopBack]: <https://loopback.io/>

