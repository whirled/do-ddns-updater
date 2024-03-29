#!/bin/sh

# Treat unset variables and parameters other than the special parameters ‘@’ or ‘*’,
# or array variables subscripted with ‘@’ or ‘*’, as an error when performing
# parameter expansion. An error message will be written to the standard error, and
# a non-interactive shell will exit.
set -u

# Load Config
source .env

# Check args for list records
if [ $# -gt 0 ]; then
    /usr/bin/curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DO_API_TOKEN}" "https://api.digitalocean.com/v2/domains/${DO_DNS_DOMAIN}/records" | jq -r '.domain_records[] | "\(.id) \(.name) \(.type) \(.data)"' | column -t
    exit 0
fi

# Get Current IP for FQDN from DO DNS via API
DNS_IPV4=$(/usr/bin/curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer ${DO_API_TOKEN}" "https://api.digitalocean.com/v2/domains/${DO_DNS_DOMAIN}/records/${DO_DNS_RECORD_ID}" | jq -r ".domain_record.data")

# Get Public IP via ifconfig.co
PUBLIC_IPV4=$(/usr/bin/curl -s https://ifconfig.co/)

# Compare DNS IP to Public IP
if [ -z "$DNS_IPV4" ] || [ -z "$PUBLIC_IPV4" ]; then
    echo "Public (${PUBLIC_IPV4}) ?? DNS (${DNS_IPV4}) - Missing IP - No Change"
elif [ "$DNS_IPV4" != "$PUBLIC_IPV4" ]; then
    echo "Public (${PUBLIC_IPV4}) <> DNS (${DNS_IPV4}) - Setting ${DO_DNS_FQDN} = ${PUBLIC_IPV4} (ID:${DO_DNS_RECORD_ID})"
    /usr/bin/curl -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer ${DO_API_TOKEN}" -d '{"data":"'"${PUBLIC_IPV4}"'"}' "https://api.digitalocean.com/v2/domains/${DO_DNS_DOMAIN}/records/${DO_DNS_RECORD_ID}"
else
    echo "Public (${PUBLIC_IPV4}) == DNS (${DNS_IPV4}) - No Change"
fi
