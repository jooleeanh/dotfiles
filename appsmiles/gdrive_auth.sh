#! /bin/bash

# gdrive-oauth v1.1 (build 20170321)
# A Bash helper script for Drive API authentication
#
# I use this to run scripts to perform automated tasks on my Google Drive
# Reporting of bugs/issues or General inquiries are encouraged
# If you found this helpful, let me know :-)
#
#  by Andy Forceno <andy@aurorabox.tech>
#
# Distributed under the MIT license:
# https://opensource.org/licenses/MIT

# To obtain client_id & secret:
# 1) Create a project at: https://console.developers.google.com
# 2) Go to APIs & Auth > API section (in the menu on the left side of the page)
# 3) Enable Drive API (you can search for it there)
# 4) Go to APIs & Auth > Credentials
# 5) Select "Add Credentials" from the drop down box, then choose OAuth 2.0 client ID
# 6) Follow prompts and you will be presented with client_id and secret
# 7) (Optional) You can also create an API key there, some API calls require it

client_id=$GSCRIPT_TRAD_CLIENT_ID
secret=$GSCRIPT_TRAD_SECRET

## Google Drive OAuth2 authentication
oauth () {
# Google recommends using the feeds scope only as a last-ditch effort if other scopes fail
# I can't get less permissive scopes to work, so this will have to do
scope=${SCOPE:-"https://docs.google.com/feeds"}

# Initial request to get user code & verification URL needed for user to verify authentication
oauth_verify=$(curl -s https://accounts.google.com/o/oauth2/device/code -d "client_id=$client_id&scope=$scope" -H "Accept: application/x-www-form-urlencoded")
device_code=$(echo $oauth_verify | grep -oP 'device_code"\s*:\s*"\K(.*)"'| cut -f1 -d',' | tr -d '"')
user_code=$(echo $oauth_verify |  grep -oP 'user_code"\s*:\s*"\K(.*)"' | cut -f1 -d',' | tr -d '"')
auth_url=$(echo $oauth_verify | grep -oP 'verification_url"\s*:\s*"\K(.*)"' | cut -f1 -d',' | tr -d '"')

echo -e "\nYou must authorize this app with Google Drive. Enter the following code in your browser to verify this app:
$user_code\n"
echo  "Press any key to open the authorization URL in your browser"
reap -p "Once you authorize this app with Google Drive, you may close your browser window\n"

# INFO: If you use Google Chrome, replace with:
google-chrome %U "$auth_url"
read -p "Press any key to continue..."

# Second step in OAuth using the device_code previously obtained. This will get access_token and refresh_token
oauth_tokens=$(curl -s https://www.googleapis.com/oauth2/v3/token -d "client_id=$client_id&client_secret=$secret&code=$device_code&grant_type=http://oauth.net/grant_type/device/1.0")
access_token=$(echo $oauth_tokens | grep -oP 'access_token"\s*:\s*"\K(.*)"' | cut -f1 -d',' | tr -d '"')
refresh_token=$(echo $oauth_tokens | grep -oP 'refresh_token"\s*:\s*"\K(.*)"' | cut -f1 -d',' | tr -d '"')

# access_token and refresh_token are written to .gdriverc
touch ~/.gdriverc
echo "access_token=$access_token" >> ~/.gdriverc
echo "refresh_token=$refresh_token" >> ~/.gdriverc
echo -e "\nAccess & refresh token have been saved to /.gdriverc\n"
exit 0
}

## Check for expired or invalid tokens
validate_token () {
# Will automagically refresh access_token using refresh_token
files_uri="https://www.googleapis.com/drive/v2/files"

# File to be searched for, used by validate_token()
# Doesn't really matter what this is set to, it's just used to determine if access_token expired
# Must be encoded, see: https://developers.google.com/drive/web/search-parameters
# Or use the API explorer to generate the encoded query string for you,
# Found at the bottom of this page: https://developers.google.com/drive/v2/reference/files/list
file="'Document+(1)'"

# Request to obtain confirmation of either valid or invalid access_token
# This just searches for $file using the file.list object
# This could be just about any Drive API call
file_list=$(curl -s -H "Authorization: Bearer $access_token" $files_uri?corpus=DEFAULT&maxResults=3&orderBy=createdDate&q=title+%3D+$file&spaces=drive)

if [[ -n $(echo $file_list | grep -io "invalid") ]]; then
	echo -e "Expired access token. Re-authenticating..."
# Obtain the new refresh_token and access_token
	get_refresh=$(curl -s https://www.googleapis.com/oauth2/v3/token -d "client_id=$client_id&client_secret=$secret&refresh_token=$refresh_token&grant_type=refresh_token")
	access_token=$(echo $get_refresh | grep -oP 'access_token"\s*:\s*"\K(.*)"' | cut -f1 -d',' | tr -d '"')
# Write access_token to .gdriverc
	sed -i "s/access_token=.*/access_token=$access_token/g" ~/.gdriverc
	echo -e "Access token refreshed!"
fi
}

## Your function goes here
a_function() {
# Validation should be performed after authentication but prior to any other API calls
validate_token

 # Other stuff goes here...
 # Take a look at the Drive API docs to see what you can do:
 # https://developers.google.com/drive/web/about-sdk
}

# Generate .gdriverc if it is missing
if [[ ! -f ~/.gdriverc ]];
then
	touch ~/.gdriverc
fi
source ~/.gdriverc

# Loop that initializes authentication the first time
# Initializes other user-defined functions subsequently
while true
do
if [[ -z "$access_token" ]]; then
	oauth
else
	a_function
#   b_function
#   ...
fi
done
