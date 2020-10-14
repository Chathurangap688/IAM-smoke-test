# WSO2-IS-Access-Token
Obtain an access token for a new application from WSO2 Identity Server - CURL

WSO2 IS(Identity Server) is an open source product which provide number of IAM solutions such as SSO, Identity Federation, Authentication - be it multi-factor authentication or adaptive authentication, and more.
	Here we discuss a simple method to get an access token of an application which registered on wso2 IS. Before we do this we need to register an application on IS and it needs enable inbound configurations.
## Register Application on IS with inbound configurations
```curl
curl -k --user <username>:<password> -X POST "https://localhost:9443/t/carbon.super/api/server/v1/applications" -H  "Content-Type: application/json" \
-d '{"name":"'<your app name>'","description":"This is the configuration for Pickup application.",     "inboundProtocolConfiguration": { 
    "oidc": { 
        "grantTypes": ["authorization_code", "refresh_token", "client_credentials"],  
        "callbackURLs": ["regexp=(https://localhost:6443/oauth2client|https://localhost:6443/logout)"],  
        "publicClient": false,  
        "pkce": { 
            "mandatory": true,  
            "supportPlainTransformAlgorithm": true 
        },  
        "accessToken": { 
            "type": "Default",  
            "userAccessTokenExpiryInSeconds": 3600,  
            "applicationAccessTokenExpiryInSeconds": 3600 
        },  
        "refreshToken": { 
            "expiryInSeconds": 86400,  
            "renewRefreshToken": true 
        },  
        "idToken": { 
            "expiryInSeconds": 3600,  
            "encryption": {"enabled": false, "algorithm": "RSA-OAEP", "method": "A128CBC+HS256"} 
        },  
        "logout": { 
            "backChannelLogoutUrl": "https://localhost.com:6443/backchannel/logout",  
            "frontChannelLogoutUrl": "https://localhost:6443/logout" 
        },  
        "validateRequestObjectSignature": false 
        } 
    }}'
```
Here username and password must be the same as IS username and password.(default username and password is ```admin``` and ```admin``` )

## Get Application ID
After registering a new application on IS we need application ID for future requirements.

```
curl -k --user <username>:<password>  -X GET "https://localhost:9443/t/carbon.super/api/server/v1/applications?filter=name+eq+<your app name>" \
-H  "accept: application/json" | jq '.applications[0].id'

```
we can prace response json by using ```jq```
(if you haven't install ```jq``` you can install it by ```sudo apt-get install jq```)

```| jq '.applications[0].id'```

## Get ```clientId``` and ```clientSecret``` by ```app id```

Now you can obtain ```clientId``` and ```clientSecret``` by using application ID

```curl -k --user <username>:<password> -X GET "https://localhost:9443/t/carbon.super/api/server/v1/applications/<app id>/inbound-protocols/oidc" -H  "accept: application/json" )"```

## Obtain Access Token 
There are several ways to obtain access tokens.

    Authorization Code Grant
    Implicit Grant
    Resource Owner Password Credentials Grant
    Client Credentials Grant
    Refresh Token Grant
    Kerberos Grant

 Once we obtain access token by one of these ways, we can access the resource server

### Client Credentials Grant

Using this method, we can obtain a access token by ```clientId``` and ```clientSecret``` without any password or username. 

    curl -u <clientId>:<clientSecret> -k -d "grant_type=client_credentials" -H "Content-Type:application/x-www-form-urlencoded" https://localhost:9443/oauth2/token | jq '.access_token'

