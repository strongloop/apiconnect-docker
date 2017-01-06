## Using Micro Gateway as the gateway service

### 1. Starting all services
```
$ docker-compose -f docker-compose-microgateway.yaml up  -d
```
The command will take a while to start all services.

Confirm that the IBM API Connect services are running by entering the following command,
```
$ docker-compose -f docker-compose-microgateway.yaml ps
```
You should see a response similar to the following.
```
    Name                   Command               State               Ports
--------------------------------------------------------------------------------------
apim            /tini -- /startup.sh             Up
esmaster        /docker-entrypoint.sh /bin ...   Up       9200/tcp, 9300/tcp
ibmlogstash     /bin/sh -c /startup.sh           Up
ibmportal       /root/tini -- /root/start_ ...   Up
make-ssh-keys   /bin/sh -c /genkey.sh            Exit 0
microgateway    /bin/sh -c /usr/bin/app.sh ...   Up
microservice    /bin/sh -c /usr/bin/app.sh ...   Up       8080/tcp
nginx           /bin/sh -c /run.sh               Up       0.0.0.0:443->443/tcp, 80/tcp
```

Service `make-ssh-keys` has completed and exited.

To enable access to all the services, edit your local /etc/hosts file to map the IP address of your Docker host to the IBM API Connect host names,
```
<docker-host-ip> apim ibmportal microgateway microservice
```

### 2.  Configuring your IBM API Connec cloud
* In a web browser, enter the URL <https://apim/cmc/>, the cloud console login window opens.
* Log in with the following credentials:

    ```
    Username: admin
    Password: !n0r1t5@C
    ```
* Accept the license agreement.
* On the `Create your profile` page, enter your email address, and a new password, then click `Update profile`. The Cloud Manager user interface opens.
* Make sure the SMTP service is reachable. Click `Settings`, select `Email`, fill in information, and select `Test Configuration`.

* Add a new provider organization
    In the Cloud Manager, click `Organizations`. Click `Add`, and enter
    ```
    Display Name: <organization_display_name>
    Name: <organization_name>
    ```
    *Note:* The value of the Name field is included in the organization segment of the URL for API calls

    Click `New User`, and enter
    ```
    Email: <your_email>
    ```

    Click `Add` to create the provider organization. An invitation email is sent to the specified email address.

    In the invitation email, click the activation link and follow the instructions to sign up.

    Enter your name and password, and click `Sign Up`.

    When you have completed the sign up instructions, the login page for the API Manager user interface opens; log in with your email address and password.


### 3. Configuring the catalog
* If it is not already open, launch the API Manager user interface in a browser by entering URL <https://apim/apim/>. Log in with your email and password.
* Click the `Navigate to` icon ![Navigate to](images/icon_navigate_to.png). The API Manager UI navigation pane opens. Click `Dashboard` .
* Click the `Sandbox` catalog to display its details.
* Customize the gateway endpoint
    Select the Sandbox catalog, click `Settings` > `Endpoints`. And add
    ```
    Custom Gateway URL: https://microgateway/
    ```
    Click `Save` icon ![Navigate to](images/icon_save.jpg) to save your gateway customization.
* Enable Portal in the Sandbox catalog

    Click `Portal`.

    From `Select Portal` drop down, select `IBM Developer Portal`. The URL is set automatically to: `https://ibmportal/organization_name/sb`,
    where organization_name is the Name value that you specified when you created the provider organization in step 2.

    click `Save` icon ![Navigate to](images/icon_save.jpg) to save your Developer Portal configuration.

    After a few minutes, you will receive an email with a link to the Developer Portal site for the `Sandbox` catalog.
    The link is a single use only link for the administrator account.
    When the link is active and you have accessed it, you can change the password of this administrator account.

### 4. Publishing the LoopBack sample application microservice into the Sandbox catalog
* If you have not, install [IBM API Connect Toolkit] on your host.

    ```
    $ npm install -g apiconnect
    ```

    For more details, see [Install Toolkit].
* Log into the API Connect server

    ```
    $ cd microservice
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

    where organization_name is the Name value that you specified when you created the provider organization in step 2.
### 5. Configuring the Developer Portal
* In a web browser, enter url <https://ibmportal/organization_name/sb/>.
    where organization_name is the Name value that you specified when you created the provider organization in step 2.

    You can see the `loopback-example-database 1.0.0` microservice in the `Featured APIs` pane.
* Create a developer account

    *Note:* You cannot use the same email address as the one you used in step 2 when creating your provider organization,
    because this email address is used for the Developer Portal admin account.

    Click `Create an account`, enter answers for the following items
    ```
    E-mail address
    Password
    Confirm password
    First name
    Last name
    Developer organization
    What code is in the image?
    ```
    An invitation email is send to the specified email address.
    Follow the account activation link in the confirmation email to activate your account.
* Log in as a developer

    To use the Developer Portal, click `Login` and sign in with the user credentials you just specified.
* Creating a new App in Developer Portal

    In the Developer Portal, click `Apps` > `Create new App`, enter
    ```
    Title:  microservice
    Description: <your_description>
    ```
    Click `Submit`. Your application is displayed.
* Select the `Show Client Secret` check box and make a note of your client secret because it is displayed only once.
You must supply the client secret when you call an API that requires you to identify your application by using a client ID and client secret.

    *Note:* The client secret cannot be retrieved. If you forget it, you must reset it.
* Optional: The client ID is hidden, to display the client ID for your application, select the Show check box for Client ID.
The client ID is displayed and can be hidden again by clearing the check box.
* Optional: You can add an additional client ID and client secret to the application. For more details, see [Registering an application]
* Subscribe to a plan

    Select `API Products`, then click `loopback-example-database 1.0.0` to open the Product detail page.
    Click `Subscribe` to subscribe to the default plan. Check `microservice` application, click `Subscribe`.

    *Note:* it will take up to 10 minutes for Micro Gateway to get synced with APIM. After then the subscription credentials will be accepted by Micro Gateway.

### 6. Access microservice sample APIs through Micro Gateway
*Note:* In the following examples, we are using a sample of Client ID and Client Secret from the previous step.
You must replace these values with your own credentials from step 5.
```
Client ID: ad37d0e2-4551-41f7-a011-88f0447f4560
Client  Secret: yY7xL8hA0iD1tR0qD5hY0kG3rR3nC2eA3mM8iN2yL4hD2bQ2gU
```

* Accessing POST API via Micro Gateway
    ```
    $ curl -k --request POST \
       --url https://microgateway/api/Accounts \
       --header 'accept: application/json' \
       --header 'content-type: application/json' \
       --header 'x-ibm-client-id: ad37d0e2-4551-41f7-a011-88f0447f4560' \
       --header 'x-ibm-client-secret: yY7xL8hA0iD1tR0qD5hY0kG3rR3nC2eA3mM8iN2yL4hD2bQ2gU' \
       --data '{"email":"ara@ziat.ly","createdAt":"2016-11-26T15:29:45.233Z","lastModifiedAt":"2016-11-25T20:17:02.033Z"}'
    ```

* Accessing GET API via Micro Gateway
    ```
    $ curl -k --request GET \
       --url 'https://microgateway/api/Accounts' \
       --header 'accept: application/json' \
       --header 'content-type: application/json' \
       --header 'x-ibm-client-id: ad37d0e2-4551-41f7-a011-88f0447f4560' \
       --header 'x-ibm-client-secret: yY7xL8hA0iD1tR0qD5hY0kG3rR3nC2eA3mM8iN2yL4hD2bQ2gU'
    ```


[IBM DataPower Gateway]: <https://https://hub.docker.com/r/ibmcom/datapower/>
[IBM API Connect]: <http://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/mapfiles/getting_started.html>
[IBM API Connect Toolkit]: <http://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.toolkit.doc/capim_cli_overview.html>
[IBM Developer Portal]: <http://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.devportal.doc/capim_devportal_overview.html>
[LoopBack]: <https://loopback.io/>
[Install Toolkit]: <https://www.ibm.com/support/knowledgecenter/SSFS6T/com.ibm.apic.toolkit.doc/tapim_cli_install.html>
[Registering an application]: <http://www.ibm.com/support/knowledgecenter/SSMNED_5.0.0/com.ibm.apic.devportal.doc/task_cmsportal_registerapps.html>
