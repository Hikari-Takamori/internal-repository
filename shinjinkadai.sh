#!/bin/bash

# Basic Directory definitions.
CURRENT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0)); pwd -P)

#Do cpsuser the job below

#CPSUSER_LOGIN="- cpsuser"
#password_cpsuser="cpsuser"

#expect -c "
#spawn "/bin/su - cpsuser"
#expect \"Password: \"
#send \"${password_cpsuser}\n\"

#"

#cautioned
#touch /tmp/cautioned

#warned
#touch /tmp/warned

#Do cpsroot the job below

#password_cpsroot="cpsroot"

#spawn env LANG=C "/bin/su - cpsroot"


#expect -c "
#spawn env LANG=C "/bin/su - cpsroot"
#expect \"Password: \"
#send \"${password_cpsroot}\n\"

#"

#Variable definition
API_BASE_URL="https://cpspgear.solomondev.access-company.com/v1"
id="cpspgear_dev_o-gr+dev_cpsp_admin_km@access-company.com"
password="irelbEwkAdGivwefJi"


###### adminStaff_login: Login to the cpspgear system ######
adminStaffLogin() {
    response=`curl -X POST \
         ${API_BASE_URL}/adminStaff/login \
         -H 'accept: application/json' \
         -H 'cache-control: no-cache' \
         -H 'content-type: application/json' \
         -d '{
                 "email": "'${id}'",
                 "password": "'${password}'",
                 "sessionLifetime": 86400,
                 "sessionLifetimeMarginMax": 30
             }'`
#    echo ${response} | jq
}

#echo '##### Do adminStaffLogin #####'
adminStaffLogin

ADMIN_CREDENTIAL_KEY=`echo ${response} | jq -r .session.key`
ADMIN_ID=`echo ${response} | jq -r ._id`

#echo KEY:
#echo ${ADMIN_CREDENTIAL_KEY}
#echo ID:
#echo ${ADMIN_ID}





###### retrieve AppID ######
AppID() {
    response_AppID=`curl -X GET \
         ${API_BASE_URL}/app \
	 -H "Authorization: ${ADMIN_CREDENTIAL_KEY}" `
#	 -H 'accept: application/json' \
#        -H 'cache-control: no-cache' \
 #   echo ${response_AppID} | jq -r .[]._id
}

#echo '##### Retrieve AppID  #####'
AppID

#JSON | jq
#CPSP_APPID=`echo ${response_AppID} | jq -r .[]._id

#text | grep
CPSP_APPID=`echo ${response_AppID} | grep -o a_XhFvScBc`

#echo ${CPSP_APPID}





###### retrieve GroupID ######
GroupID() {
    response_GroupID=`curl -X GET \
        ${API_BASE_URL}/${CPSP_APPID}/group \
         -H "Authorization: ${ADMIN_CREDENTIAL_KEY}" `
        # -H 'accept: application/json' \
        # -H 'cache-control: no-cache' \
        #-H 'content-type: application/json' \
 #   echo ${response_GroupID} | jq -r .[]._id
}   

#echo '##### Retrieve GroupID #####'
GroupID

#JSON | jq
#CPSP_GROUPID_2=`echo ${response_GroupID} | jq -r .[]._id `

#text | grep
CPSP_GROUPID=`echo ${response_GroupID} | grep -o g_HRcHJTWK`

#echo ${CPSP_GROUPID}




###### retrieve file and data collection list ######
CollectionID() {
    response_CollectionID=`curl -X GET \
        ${API_BASE_URL}/${CPSP_APPID}/collection \
         -H "Authorization: ${ADMIN_CREDENTIAL_KEY}" `     
        # -H 'accept: application/json' \
        # -H 'cache-control: no-cache' \
#        -H 'content-type: application/json' \
 #   echo ${response_CollectionID} | jq -r .[].name
}

#echo '##### Retrieve CollectionID #####'
CollectionID

#JSON | jq
CPSP_COLLECTIONID_2=`echo ${response_CollectionID}`
#text | grep
CPSP_COLLECTIONID=`echo ${CPSP_COLLECTIONID_2} | grep -o filePostProcess`

#echo ${CPSP_COLLECTIONID}





###### retrieve file list ######
FilelistID() {

#Variable definition
SORT='?sort=%7B%22updatedAt%22%3A-1%7D'
LIMIT='&limit=1'   #to get mp4 & thumb.jpg files
SKIP='&skip=1'   #to skip thumb.jpg file
	
    response_FilelistID=`curl -X GET \
	 ${API_BASE_URL}/${CPSP_APPID}/${CPSP_GROUPID}/file/${CPSP_COLLECTIONID}${SORT}${LIMIT}${SKIP} \
	 -H "Authorization: ${ADMIN_CREDENTIAL_KEY}" `
# -H 'accept: application/json' \
        # -H 'cache-control: no-cache' \
        # -H 'content-type: application/json' \
 #   echo ${response_FilelistID} | jq -r .[]._id
}

#echo '##### Retrieve FilelistID #####'
FilelistID

#CPSP_FILELIST_2=`echo ${response_FilelistID} | jq .[0] `
CPSP_FILELIST_2=`echo ${response_FilelistID} | jq -r .[]._id`
#CPSP_FILELIST_THUMB_2=`echo ${response_FilelistID} | jq .[1]`

CPSP_FILELIST=`echo ${CPSP_FILELIST_2}`
#CPSP_FILELIST_THUMB=`echo ${CPSP_FILELIST_THUMB_2}`
#echo ${CPSP_FILELIST}
#echo ${CPSP_FILELIST_THUMB}





###### retrieve file ######
###### retrieve file document ######
FiledocumentID() {
    response_FiledocumentID=`curl -X GET \
        ${API_BASE_URL}/${CPSP_APPID}/${CPSP_GROUPID}/file/${CPSP_COLLECTIONID}/${CPSP_FILELIST} \
         -H "Authorization: ${ADMIN_CREDENTIAL_KEY}" `
        # -H 'accept: application/json' \
        # -H 'cache-control: no-cache' \
#        -H 'content-type: application/json' \
 #   echo ${response_FiledocumentID} | jq
}

#FiledocumentthumbID(){
#response_FiledocumentthumbID=`curl -X GET \
#        ${API_BASE_URL}/${CPSP_APPID}/${CPSP_GROUPID}/file/${CPSP_COLLECTIONID}/${CPSP_FILELIST_THUMB} \
#         -H "Authorization: ${ADMIN_CREDENTIAL_KEY}" \     
        # -H 'accept: application/json' \
        # -H 'cache-control: no-cache' \
#        -H 'content-type: application/json' \
#         `
#    echo ${response_FiledocumentthumbID} | jq
#}

#echo '##### Retrieve FiledocumentID & FiledocumentthumbID #####'
FiledocumentID
#FiledocumentthumbID

CPSP_DOWNLOADURL=`echo ${response_FiledocumentID} | jq -r .downloadUrl `
#CPSP_DOWNLOADURL_THUMB=`echo ${response_FiledocumentthumbID} | jq -r .downloadUrl`

echo ${CPSP_DOWNLOADURL}
#echo ${CPSP_DOWNLOADURL_THUMB}


###### retrieve file ######

#curl -X GET \
#${CPSP_DOWNLOADURL}

#curl -X GET \
#${CPSP_DOWNLOADURL_THUMB}


