#!/bin/bash

echo "Welcome to Auth2 app IS"


read -p "Enter IS username: "  username
read -p "Enter IS password: "  password

read -p "Enter new auth2 app name: "  appname
data = "{'name':'$appname','description':'This is the configuration for Pickup application.'}"
echo "Registering $appname in IS......."
curl -k --user $username:$password -X POST "https://localhost:9443/t/carbon.super/api/server/v1/applications" -H  "Content-Type: application/json" \
-d '{"name":"'$appname'","description":"This is the configuration for Pickup application.",     "inboundProtocolConfiguration": { 
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
echo "\nApp Registration Successful.......!"
request_cmd="$(curl -k --user $username:$password  -X GET "https://localhost:9443/t/carbon.super/api/server/v1/applications?filter=name+eq+$appname" -H  "accept: application/json" | jq '.applications[0].id')"

echo "Get Application ID.."
id=$(echo $request_cmd)
echo "ID: $id"
temp="${id%\"}"
appid="${temp#\"}"

url="https://localhost:9443/t/carbon.super/api/server/v1/applications/${appid}/inbound-protocols/oidc"
echo "Getting Token.........."
cmd="$(curl -k --user $username:$password -X GET "$url" -H  "accept: application/json" )" #| jq '.clientId, .clientSecret'
client=$(echo $cmd)


clientId=$(echo $client | jq '.clientId')
temp="${clientId%\"}"
clientId="${temp#\"}"

clientSecret=$(echo $client | jq '.clientSecret')
temp="${clientSecret%\"}"
clientSecret="${temp#\"}"



echo "Client ID: $clientId"
echo "Client secret: $clientSecret"


cmd="$(curl -u $clientId:$clientSecret -k -d "grant_type=client_credentials" -H "Content-Type:application/x-www-form-urlencoded" https://localhost:9443/oauth2/token | jq '.access_token')"
tokenVal=$(echo $cmd)
echo "\n*******************************************************"
echo " \nAccess Token : $tokenVal\n"
echo "*******************************************************"

echo "\n\nDeleting App $appname..."
curl -k --user $username:$password -X DELETE "https://localhost:9443/t/carbon.super/api/server/v1/applications/${appid}" -H  "accept: */*"
echo "Delete Successful....!"