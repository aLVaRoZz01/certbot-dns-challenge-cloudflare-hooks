# certbot-DNS-challenge-hooks

Simple scripts I use to auto renew my Let's encrypt wildcard SSL cert.

## Usage

- Apply for a certificate use `certbot` and `dns-01` challenge
- Download this repo
- open `config.sh` of this repo, fill the `CLOUDFLARE_KEY` variables
- install `jq` and `python3-acme` packages from your system package manager (apt, yum, etc)
- Add a crontab job (as root) as bellow:

```bash
certbot renew --manual-auth-hook="/path/to/cloned/repo/cloudflare-update-dns.sh" --manual-cleanup-hook="/path/to/cloned/repo/cloudflare-clean-dns.sh" --post-hook="systemctl reload nginx" >> /path/to/log/crontab.renew.log 2>&1
```

## How to obtain token
You will need to create an API token which either:

(i) has permissions to edit a single specific DNS zone; or <br>
(ii) has permissions to edit multiple DNS zones.

You can do this via your Cloudflare profile page, under the [API Tokens section](https://dash.cloudflare.com/profile/api-tokens). When your create the token, under Permissions, select Zone > DNS > Edit, and under Zone Resources, only include the specific DNS zones within which you need to perform ACME DNS challenges.

The API token is a 40-character string that may contain uppercase letters, lowercase letters, numbers, and underscores. You must provide it to acme.sh by setting the environment variable `CF_Token` to its value, e.g. run export `CF_Token="Y_jpG9AnfQmuX5Ss9M_qaNab6SQwme3HWXNDzRWs"`.

#### (i) Single DNS zone
You must give acme.sh the zone ID of the DNS zone it needs to edit. This is a 32-character hexadecimal string (e.g. `763eac4f1bcebd8b5c95e9fc50d010b4`), and should not be confused with the zone name (e.g. `example.com`). This zone ID can be found via the Cloudflare dashboard, on the zone's Overview page, in the right-hand sidebar.

You provide this info by setting the environment variable `CF_Zone_ID` to this zone ID, e.g. run `export CF_Zone_ID="763eac4f1bcebd8b5c95e9fc50d010b4"`.

#### (ii) Multiple DNS zones
You must give acme.sh the account ID of the Cloudflare account to which the relevant DNS zones belong. This is a 32-character hexadecimal string, and should not be confused with other account identifiers, such as the account email address (e.g. `alice@example.com`) or global API key (which is also a 32-character hexadecimal string). This account ID can be found via the Cloudflare dashboard, as the end of the URL when logged in, or on the Overview page of any of your zones, in the right-hand sidebar, beneath the zone ID.

You provide this info by setting the environment variable `CF_Account_ID` to this account ID, e.g. `run export CF_Account_ID="763eac4f1bcebd8b5c95e9fc50d010b4"`.



## Example

```bash
sudo certbot renew --manual-auth-hook="/etc/letsencrypt/scripts/cloudflare-update-dns.sh" --manual-cleanup-hook="/etc/letsencrypt/scripts/cloudflare-clean-dns.sh" --post-hook="systemctl reload nginx" --dry-run

Saving debug log to /var/log/letsencrypt/letsencrypt.log

-------------------------------------------------------------------------------
Processing /etc/letsencrypt/renewal/7sdre.am.conf
-------------------------------------------------------------------------------
Cert not due for renewal, but simulating renewal for dry run
Plugins selected: Authenticator manual, Installer None
Renewing an existing certificate
Performing the following challenges:
dns-01 challenge for 7sdre.am
dns-01 challenge for 7sdre.am
Output from cloudflare-update-dns.sh:
CHALLENGE_DOMAIN: _acme-challenge.7sdre.am
CHALLENGE_VALUE: q_nAln58kJ0M8iaih2dWo_jMlYwogj_iIBQjj2LEIeU
DNS_SERVER: 8.8.8.8
ZONE: d3ea0d3d2fa87bbd2915d6ce869e5f47
Add record result: true
DNS records have not been propagate, sleep 10s...
DNS record have been propagated, finish

Output from cloudflare-update-dns.sh:
CHALLENGE_DOMAIN: _acme-challenge.7sdre.am
CHALLENGE_VALUE: anaxLO1rs2XSTlDwOXiMSdgazBsr8erX5l-Tdx5KRAI
DNS_SERVER: 8.8.8.8
ZONE: d3ea0d3d2fa87bbd2915d6ce869e5f47
Add record result: true
DNS records have not been propagate, sleep 10s...
DNS records have not been propagate, sleep 10s...
DNS record have been propagated, finish

Waiting for verification...
Cleaning up challenges
Output from cloudflare-clean-dns.sh:
DOMAIN: _acme-challenge.7sdre.am
ZONE: d3ea0d3d2fa87bbd2915d6ce869e5f47
a0ba72127de4db56eea3541491cdbd36
clean: a0ba72127de4db56eea3541491cdbd36
true
clean: c11557b6f7766cc2749a36864a14584c
true
clean: 2191aed49f646c5c64209be36a2d3788
true

Output from cloudflare-clean-dns.sh:
DOMAIN: _acme-challenge.7sdre.am
ZONE: d3ea0d3d2fa87bbd2915d6ce869e5f47



-------------------------------------------------------------------------------
new certificate deployed without reload, fullchain is
/etc/letsencrypt/live/7sdre.am/fullchain.pem
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates below have not been saved.)

Congratulations, all renewals succeeded. The following certs have been renewed:
  /etc/letsencrypt/live/7sdre.am/fullchain.pem (success)
** DRY RUN: simulating 'certbot renew' close to cert expiry
**          (The test certificates above have not been saved.)
-------------------------------------------------------------------------------
Running post-hook command: systemctl reload nginx
```

## LICENSE

WTFPL
