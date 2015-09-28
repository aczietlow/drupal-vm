#!/bin/bash
usage()
{
cat << EOF
Usage: behat-run.sh uri.dev /path/to/behat.tests

ARGUMENTS:
   $URI: URI of site to run behat against.
   $SITE_PATH: Absolute path to Behat tests directory.
EOF
}

URI=$1
SITE_PATH=$2

# Exit if options aren't set.
if [[ -z $SITE_PATH || -z $URI ]]; then
  usage
  exit 1;
fi

cd $SITE_PATH

# Run behat.
if [ -f bin/behat ]; then
  BEHAT_PARAMS='{"extensions":{"Behat\\MinkExtension":{"base_url":"$URI"}}}' bin/behat
else
  BEHAT_PARAMS='{"extensions":{"Behat\\MinkExtension":{"base_url":"$URI"}}}' behat
fi
