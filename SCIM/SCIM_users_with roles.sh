echo "Entering a new User through SCIM"

read -p "Enter IS username: "  isUsername
read -p "Enter IS password: "  isPassword

read -p "Enter new user first name: "  fname
read -p "Enter new user last name: "  lname
read -p "Enter new user username: "  username
read -p "Enter new user password(min 5 characters): "  password
read -p "Enter new user role: "  role


#adding user
user="$(curl -v -k --user $isUsername:$isPassword --data "{"schemas":[],"name":{"familyName":'$lname',"givenName":'$fname'},"userName":'$username',"password":'$password',"emails":[{"primary":true,"value":"wso2_home.com","type":"home"},{"value":"wso2_work.com","type":"work"}]}" --header "Content-Type:application/json" https://localhost:9443/wso2/scim/Users)"


id=$(echo $user | jq '.id')
echo "\nuser ID : $id"


#adding roles
grps="$(curl -v -k --user $isUsername:$isPassword --data '{"displayName": '$role',"members": [{"value":'$id'}] }  ' --header "Content-Type:application/json" https://localhost:9443/wso2/scim/Groups )"


grpId=$(echo $grps | jq '.id')
echo "\nGroup ID : $grpId"


temp2="${grpId%\"}"
newGrpId="${temp2#\"}"

#delete role
curl -v -k --user admin:admin -X DELETE https://localhost:9443/wso2/scim/Groups/${newGrpId} -H "Accept: application/json"


temp1="${id%\"}"
idNew="${temp1#\"}"

#delete user
curl -v -k --user $isUsername:$isPassword -X DELETE https://localhost:9443/wso2/scim/Users/${idNew} -H "Accept: application/json"


echo "\nUser Registered and Deleted Successfully in IS......."