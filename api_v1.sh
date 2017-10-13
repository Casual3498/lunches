#!/bin/bash 
echo 'API LOGIN/LOGOUT TEST'

export port=3000
export host=http://localhost:$port
export email=second@lunches.md
export password=222222


#RESTFUL API using DEVISE

#sign in and set the token

echo 1. 'POST' $host/v1/login.json

export token=$(
curl -s -H "Accept: application/vnd.api+json" \
        -H "Content-Type: application/vnd.api+json" \
        -X POST $host/v1/login.json  \
        -d '{"data": {"id": "0", "type": "auth_params", "attributes": {"email" : '"\"$email\""', "password":'"\"$password\""'}}}' \
        | python -mjson.tool  \

  )

echo result = $token  

token=$(echo $token | grep -wo authentication_token.* | cut -d',' -f1 | cut -d':' -f2 | sed 's/ *["\,]//g')


echo token = $token

#read -rsp $'Press enter to continue...\n'

echo 2. 'GET' $host/v1/orders.json

curl -s -H "Accept: application/vnd.api+json" \
        -H "Content-Type: application/vnd.api+json" \
        -H "X-User-Token: $token" \
        -H "X-User-Email: $email" \
        -X  GET http://localhost:3000/v1/orders.json \
     | python -mjson.tool

#read -rsp $'Press enter to continue...\n'

echo 3. 'DELETE' $host/v1/logout.json

curl -s -H "Accept: application/vnd.api+json" \
        -H "Content-Type: application/vnd.api+json" \
        -H "X-User-Token: $token" \
        -H "X-User-Email: $email" \
        -X  DELETE http://localhost:3000/v1/logout.json \
     | python -mjson.tool


#read -rsp $'Press enter to continue...\n'

echo 4. 'GET' $host/v1/orders.json

curl -s -H "Accept: application/vnd.api+json" \
        -H "Content-Type: application/vnd.api+json" \
        -H "X-User-Token: $token" \
        -H "X-User-Email: $email" \
        -X  GET http://localhost:3000/v1/orders.json \
     | python -mjson.tool     