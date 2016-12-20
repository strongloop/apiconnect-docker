# IBM API Connect on Docker

## Overview

The IBM API Connect on Docker combines the power of [IBM API Connect] with the flexibility of Docker.

[IBM API Connect] is an API management solution that addresses critical aspects of the API lifecycle providing the capability to create, run, manage and secure APIs and microservices.

## Usage

[IBM API Connect Product Documentation] describes in detail how to use IBM API Connect.

This package requires a minimum of 8GB RAM and 2 CPUs.

## License Acceptance

To use the package, you must accept the license terms. If you do not assert that you have accepted the license, the IBM API Connect services will not start successfully.

You can view the license files directly in the package LICENSE.txt, non_ibm_license.txt and notices.txt, or with the command
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

There are 2 options to run IBM API Connect on Docker package. You can either use DataPower Gateway or Micro Gateway as the gateway service. Please refer to the following link for detailed steps.

* [Using DataPower Gateway](https://github.com/strongloop/apiconnect-docker/blob/master/README-datapower.md)
* [Using Micro Gateway](https://github.com/strongloop/apiconnect-docker/blob/master/README-microgateway.md)

## Links to Resources

* [IBM API Connect]
* [IBM DataPower Gateway]
* [Micro Gateway]
* [LoopBack]

## License

View the license files directly in the package LICENSE.txt, non_ibm_license.txt and notices.txt, or with the command

```
docker run -it --rm --env SHOW_LICENSE=1 ibmcom/apiconnect:manager-v5.0.6.0
```

[IBM API Connect Product Documentation]: <http://www.ibm.com/support/knowledgecenter/SSMNED>
[IBM API Connect]:  <http://www-03.ibm.com/software/products/en/api-connect>
[IBM DataPower Gateway]: <https://hub.docker.com/r/ibmcom/datapower/>
[Micro Gateway]: <https://github.com/strongloop/microgateway>
[LoopBack]: <https://loopback.io/>

