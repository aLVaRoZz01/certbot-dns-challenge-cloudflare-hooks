CLOUDFLARE_KEY="change-me"

CHALLENGE_PREFIX="_acme-challenge"
CHALLENGE_DOMAIN="${CHALLENGE_PREFIX}.${CERTBOT_DOMAIN}"
PARENT_DOMAIN=$(sed 's/.*\.\(.*\..*\)/\1/' <<< "${CERTBOT_DOMAIN}")

CLOUDFLARE_ZONE=$(curl -X GET "https://api.cloudflare.com/client/v4/zones?name=${PARENT_DOMAIN}" \
     -H "Authorization: Bearer ${CLOUDFLARE_KEY}" \
     -H "Content-Type: application/json" -s | jq -r '.result[0].id')
