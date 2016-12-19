## Using DataPower Gateway as the gateway service
### 1. Starting all services
```
$ docker-compose up -d
```
It will take a few minutes till all services are up.
```
$ docker-compose ps
```
From the output, you should see the following services up and running,
```
   Name                   Command               State               Ports
------------------------------------------------------------------------------------------------------
apim            /tini -- /startup.sh             Up
datapower       /start.sh                        Up       443/tcp
esmaster        /docker-entrypoint.sh /bin ...   Up       9200/tcp, 9300/tcp
ibmlogstash     /bin/sh -c /startup.sh           Up
ibmportal       /root/tini -- /root/start_ ...   Up
make-ssh-keys   /bin/sh -c /genkey.sh            Exit 0
microservice    /bin/sh -c /usr/bin/app.sh ...   Up       8080/tcp
nginx           /bin/sh -c /run.sh               Up       0.0.0.0:443->443/tcp, 80/tcp
```
Service `make-ssh-keys` has completed and exited.

To enable access to all the services with container names, add the following line to your local /etc/hosts file.
```
<docker-host-ip> apim datapower ibmportal microservice
```

### 2.  Configuring your cloud
* In a web browser, enter the URL <https://apim/cmc/>, the cloud console login window opens.
* Enter the Cloud Adminstrator user name and password. The default values are `admin` for the user name and `!n0r1t5@C` for the password. Click `Sign In`.
* In the `License Agreements` page, click `Accept All Licenses, Terms and Notes`.
* In the `Create your profile` page, enter your email, and a new password. Click `Update profile`.
* The Cloud Manager user interface opens.
* Configure the Management service

    Click `Services`. In the `DataPower Services` pane, click the Service Settings icon. Enter

    ```
    Address: datapower
    ```
    Click `Save`.

    In the `DataPower Services` pane, click `Add Server` and then enter

    ```
    Display Name: idg
    Address: datapower
    Username: admin
    Password: admin
    ```

    Note the password is the default password to access DataPower service. Click `Save`.
* Add a new provider organization

    In the Cloud Manager, click `Organizations`. Click `Add`, and enter
    ```
    Display Name: <organization_display_name>
    Name: <organization_name>
    ```
    Click `New User`, and enter
    ```
    Email: <your_email>
    ```
    Click `Add`.

    A provider organization has been created. Check your email and click the link to activate the organization.

    Enter your name and password, and click `Sign Up`.

    The provider organization `organization_name` has been activated.

### 3. Configuring the catalog
* After signed up to the provider organization, the `API Manager` UI <https://apim/apim> opens. Sign in with your email and password.
* Click the Navigate to icon. The API Manager UI navigation pane opens. Click `Dashboard` . You can see the default catalog "Sandbox".
* Enable Portal in the Sandbox catalog

    Select the Sandbox catalog, Click `Settings` > `Portal`.

    From `Select Portal` drop down list, select `IBM Developer Portal`. The URL has been set to: `https://ibmportal/organization_name/sb`, click `Save`.

    After a few minutes, you receive an email with a link to your Developer Portal site for that catalog. The link is a single use only link for the administrator account. When the link is active and you have accessed it, you can change the password of this administrator account.

### 4. Publishing the LoopBack sample application microservice into the catalog
* You need to install [IBM API Connect Toolkit] on your host. If you haven't installed npm, see [Install Toolkit].

    ```
    $ npm install -g apiconnect
    ```
* Log into the API Connect server

    ```
    $ cd microservices
    $ apic login
    Enter the API Connect server
    ? Server: apim
    ? Username: <your_apim_account_email>
    ? Password (typing will be hidden) ********
    Logged into apim successfully
    ```
* Publishing the microservice application

    ```
    $ apic publish definitions/loopback-example-database-product.yaml --catalog sb --organization organization_name --server apim
    ```

### 5. Configuring Developer Portal
* In a web browser, enter url <https://ibmportal/organization_name/sb/>.
    You can see the `loopback-example-database 1.0.0` microservice in the `Featured APIs` pane.
* Create a developer account

    Please note, you need to use a different email other than your admin email address.

    Click `Create an account`, enter
    ```
    E-mail address
    Password
    Confirm password
    First name
    Last name
    Developer organization
    What code is in the image?
    ```
    Your Developer Portal site is activated and you receive a confirmation email as a result. Then, follow the account activation link in the confirmation email to activate your account.
* Log in as a developer

    To use the Developer Portal, click Login and sign in with the user credentials you specified.
* Creating new App in Developer Portal

    In the Developer Portal, click `Apps`. click "Create new App", enter
    ```
    Title:  microservice
    Description: xxx
    ```
    Click `Submit`. Your application is displayed.
* Make a note of your client secret because it is only displayed once. You must supply the client secret when you call an API that requires you to identify your application by using a Client ID and Client Secret.

    Note: The client secret cannot be retrieved. If you forget it, you must reset it.
* Optional: The client ID is hidden, to display the client ID for your application, select the Show check box for Client ID. The client ID is displayed and can be hidden again by clearing the check box.
* Optional: You can add an additional client ID and client secret to the application. For more details, see [Registering an application]
* Subscribe to a plan

    Select `API Products`, click `loopback-example-database 1.0.0` icon and enter into the detail page. Click `Subscribe` to subscribe to the default plan. Check `microservice` application, click "Subscribe".

### 6. Access microservice sample APIs through DataPower Gateway
Note: In the following examples, we are using a sample of Client ID and Client Secret from the previous step. You must replace these values with your own credentials from step 5.
```
Client ID: ad37d0e2-4551-41f7-a011-88f0447f4560
Client  Secret: yY7xL8hA0iD1tR0qD5hY0kG3rR3nC2eA3mM8iN2yL4hD2bQ2gU
```

* Accessing POST API via DataPower Gateway
    ```
    $ curl -k --request POST
       --url https://datapower/organization_name/sb/api/Accounts \
       --header 'accept: application/json' \
       --header 'content-type: application/json' \
       --header 'x-ibm-client-id: ad37d0e2-4551-41f7-a011-88f0447f4560' \
       --header 'x-ibm-client-secret: yY7xL8hA0iD1tR0qD5hY0kG3rR3nC2eA3mM8iN2yL4hD2bQ2gU' \
       --data '{"email":"ara@ziat.ly","createdAt":"2016-11-26T15:29:45.233Z","lastModifiedAt":"2016-11-25T20:17:02.033Z"}'
    ```

* Accessing GET API via DataPower Gateway
    ```
    $ curl -k --request GET
       --url 'https://datapower/organization_name/sb/api/Accounts' \
       --header 'accept: application/json' \
       --header 'content-type: application/json' \
       --header 'x-ibm-client-id: ad37d0e2-4551-41f7-a011-88f0447f4560' \
       --header 'x-ibm-client-secret: yY7xL8hA0iD1tR0qD5hY0kG3rR3nC2eA3mM8iN2yL4hD2bQ2gU'
    ```

### Known issues
1. DataPower may lose connection to `analytics-lb` after docker container restarts

  In some race condition, when DataPower container or Docker engine restarts, DataPower may lose connection to `analytics-lb`. If you see the following error from DataPower log,
  ```
  datapower | 20161202T183348.225Z [APIMgmt_848CDBBB62][0x80e00126][mpgw][error] mpgw(webapi-internal): tid(2097) gtid(2097): Valid backside connection could not be established: Failed to establish a backside connection, url: https://analytics-lb/x2020/v1/events/logevent
  ```
  Open <https://apim/cmc/#/cloud/servers>,  check the status of datapower server in the `DataPower Services` pane.
If server `idg` is marked `INACTIVE`,  wait 5 minutes, if it is still `INACTIVE`, click more icon and select `Delete Server`.
Then add the `idg` server back following the instructions in step 2.

[IBM DataPower Gateway]: <https://https://hub.docker.com/r/ibmcom/datapower/>
[IBM API Connect]: <http://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/mapfiles/getting_started.html>
[IBM API Connect Toolkit]: <http://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.toolkit.doc/capim_cli_overview.html>
[IBM Developer Portal]: <http://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.devportal.doc/capim_devportal_overview.html>
[LoopBack]: <https://loopback.io/>
[Install Toolkit]: <https://www.ibm.com/support/knowledgecenter/SSFS6T/com.ibm.apic.toolkit.doc/tapim_cli_install.html>
[Registering an application]: <http://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.devportal.doc/task_cmsportal_registerapps.html>
