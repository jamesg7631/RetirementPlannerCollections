# Script to add user using the api
# This script sources the config.sh file for the Bearer token.
# ==========================================================
#
# Source the configuration file to get shared_variables
source ../config.sh
#

# The JSON data for the new user profile using a here document
# This is a robust way to handle multi-line strings.
RESPONSE=$(curl --location --request GET "$API_BASE_URL/users/" \
--header "Authorization: Bearer $BEARER_TOKEN" \
--silent \
--write-out "%{http_code}")

HTTP_STATUS="${RESPONSE: -3}"
JSON_BODY="${RESPONSE:0:${#RESPONSE}-3}"

echo "Status Code: $HTTP_STATUS"

# Check if the status code indicates success (e.g., 200 or 201)
if [[ "$HTTP_STATUS" =~ ^2 ]]; then
    # If successful, pipe to jq to pretty-print the JSON
    echo "$JSON_BODY" | jq .
else
    # If not successful, just print the raw response body
    echo "Response Body: $JSON_BODY"
fi
