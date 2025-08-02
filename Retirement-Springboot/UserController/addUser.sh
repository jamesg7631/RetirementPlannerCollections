# Script to add user using the api
# This script sources the config.sh file for the Bearer token.
# ==========================================================
#
# Source the configuration file to get shared_variables
source ../config.sh
#

# The JSON data for the new user profile using a here document
# This is a robust way to handle multi-line strings.
read -r -d '' DATA << EOM
{
    "name": "James Glover",
    "dateOfBirth": "2000-05-20",
    "plannedRetirementAge": 70,
    "postcode": "PA48HU",
    "taxResidencyEngland": "ENGLAND",
    "numberOfDependants": 0,
    "sexMale": "MALE",
    "grossSalary": 40000.0,
    "monthlyLivingExpenses": 300.0,
    "married": "married",
    "armedForces": false,
    "investments": []
}
EOM

RESPONSE=$(curl --location --request POST "$API_BASE_URL/users/" \
--header "Authorization: Bearer $BEARER_TOKEN" \
--header "Content-Type: application/json" \
--data "$DATA" \
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
