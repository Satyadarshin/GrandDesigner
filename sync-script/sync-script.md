# Setup WP-CLI and the syncing script

## Intro
I use a shell script (`sync-script/sync-prod-to-dev.sh`) to sync the database and files from the production site into your dev environment. It's a good idea to run this from time to time to ensure your dev environment is 
accurately mirroring the production site.

Once you've got the docker system up and running, follow the steps below, to set up the sync script. 

Note that I've attached the prefix `stdn-` to a number of settings; you should replace this with something pertinent to your own project.  

The script uses an SSH alias to connect to the production server and `rsync` files  (most of the uploads, themes and plugins). Then it uses [WP-CLI](https://wp-cli.org/) to import the production database into the dev database in Docker, and finally it changes certain WordPress settings in the dev database to make it ready as a dev system.

This guide assumes you're using a Unix-like operating system (GNU/Linux, or MacOS), and that you have an SSH installed (in many cases it will come preinstalled with your OS). If you're using Windows, it might be possible to get this script working, but it won't be straightforward and isn't covered by this documentation.

## SSH config
If you haven't already, [set up SSH keys](https://www.howtogeek.com/424510/how-to-create-and-install-ssh-keys-from-the-linux-shell/) so you don't have to enter a password every time you connect to the server. You will need to send your public SSH key (ending `.pub`) to someone who already has access to the production server so they can grant you access. You also need ask them for the `hostname` and `username` which you'll use in a moment.

If you don't have one yet, create an SSH config file - `~/.ssh/config`.

The script uses an SSH host alias to connect to the server because it's better to specify 
SSH details here instead of hardcoding in the script. 
Use the details from above to add an entry for `stdn-prod` in your SSH config file in this format:
```
Host stdn-prod
	hostname change-to-provided-value
	user change-to-provided-value
```

If the SSH host alias is working, you should be able to run `ssh stdn-prod` to log into the production server. 

If your SSH keys are working, you should be able to log in without being prompted for a password.

## Check WP-CLI is installed in all the places
For the script to work, WP-CLI needs to be installed on your local machine, on the server, and in Docker.
 
Optional: Confirm this is working by logging into each user/server 
and running `wp-cli version`. It should return the version of WP-CLI that is installed on the server.

It is already set up in [stdnsthana-docker-dev](https://github.com/stdnsthanaTriratna/stdnsthana-docker-dev).  
Optional: confirm that this is working by running `docker ps` to get the name of the WP-CLI container, 
then run `docker exec -it stdn-cli wp-cli version` (where `stdn-cli` is the container name). 
It should return the version of WP-CLI that is installed in the container 
(it's ok if it's a different version from the one on the server).

You need to install WP-CLI on your local system by following instructions [here](https://wp-cli.org/#installing).

## Optional: Copy WP-CLI Config
The sync script relies heavily on [WP-CLI site aliases](https://make.wordpress.org/cli/handbook/guides/running-commands-remotely/#aliases). 
WP-CLI aliases allow you to run commands to interact with a WordPress site without being in the right directory 
or even logged into the right host, and they abstract away some of the details of connecting to the sites and running commands 
(including hosts in Docker containers!). All of this makes script-writing a lot easier.

Optional: The scripts in the `hosting-scripts` directory will pick up aliases defined in `wp-cli.yml`, 
but if you to use WP-CLI aliases without being in the right directory, 
copy `wp-cli.yml` from this repo to `~/.wp-cli/config.yml`. When running WP-CLI commands from now on you can specify which site to run them on with `@aliasname`.

This file defines three aliases, one for each WordPress instance that I use for stdnsthana. 
My local dev site is running in Docker so the `@stdn-lcl` alias has this line `ssh: docker:stdn-cli` 
to allow WP-CLI to connect to the Docker container. 

## Test WP-CLI Aliases
To check that the aliases have been picked up from the `.yml` file correctly, `cd hosting-scripts/sync-script/` and then run `wp cli alias list`.
You can test each of the aliases in turn running eg.
```bash
wp @stdn-lcl cli info
wp @stdn-stg cli info
wp @stdn-prd cli info
```
Check that all of the paths in returned info match up - prod paths for the prod site alias and dev paths for the dev site alias.

## Config for the script
In the `sync-script` directory, copy `.env-example` to `.env` and change settings as needed (see the comments in the file for guidance).

## Run the script
Follow these steps
```bash
cd GrandDesigner/sync-script/
./sync-prod-to-dev.sh
```

