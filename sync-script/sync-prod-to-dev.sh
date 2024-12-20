#! /bin/bash
#
# Sync files and DB from satyadarshin.com FROM the production system (prod) TO the local development system (dev)
# See docs for required setup before running this script.
#
# @author Satyadarshin <s.dog@satyadarshin.com>
# Adapted from a project for Adhisthana retreat centre by Vilasamuni <vilasamuni@adhisthana.org>
#

# Read config from .env file
set -a            
source .env
set +a

echo "Check env vars are set"
required_vars=(
    "wp"
    "dev_alias"
    "staging_alias"
    "prod_alias"
    "dev_url"
    "staging_url"
    "prod_url"
    "remote_host"
    "dev_path"
    "staging_path"
    "prod_path"
    "dev_host_backup_dir"
)
for element in "${required_vars[@]}"; do
    if [[ -n ${!element} ]]; then
        echo "  $element: ${!element}"
    else
        echo "  $element is not set! Please copy '.env-example' to '.env' and make sure that all variables are set."
        exit 1
    fi
done

echo "Sync plugins, themes, and uploaded files (excluding custom theme because it is managed by Git)"
rsync -a --progress --delete $staging_path/wp-content/uploads/ $dev_path/wp-content/uploads/
rsync -a --progress --delete $staging_path/wp-content/plugins/ $dev_path/wp-content/plugins/
rsync -a --progress --delete $staging_path/wp-content/themes/ $dev_path/wp-content/themes/ 

echo "Back up the dev DB to $dev_host_backup_dir/stdn-stg-db.sql"
$wp $dev_alias db export - > $dev_host_backup_dir/stdn-stg-db.sql

$wp $dev_alias db reset --yes
echo "Import the prod DB into dev"
# Piping through tail +2 is a temporary workaround for a MariaDB bug @see https://mariadb.org/mariadb-dump-file-compatibility-change/
$wp $staging_alias db export - | tail +2 | $wp $dev_alias db import -

echo "Search-replace the site URL in the dev DB (this usually takes a while)"
$wp $dev_alias search-replace $staging_url $dev_url --recurse-objects --skip-columns=guid --skip-tables=wp_users

echo "Deactivate plugins which shouldn't be enabled on dev"
$wp $dev_alias plugin deactivate updraftplus
$wp $dev_alias plugin deactivate wordfence
$wp $dev_alias plugin deactivate flamingo
$wp $dev_alias plugin deactivate wp-mail-smtp

# echo "Activate plugins which should be enabled on dev"

