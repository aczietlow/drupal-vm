#!/bin/bash
usage()
{
cat << EOF
Usage: ./code-review.sh uri.dev /path/to/docroot

ARGUMENTS:
   $URI: URI of site to run code review against.
   $SITE_PATH: Absolute path to Drupal docroot.
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

# Relatively move to contrib directory.
cd sites/all/modules/contrib

# Get coder module in case it doesn't exist.
if [ ! -f coder/coder.module ]; then
  wget http://ftp.drupal.org/files/projects/coder-7.x-2.5.tar.gz > /dev/null 2>&1
  tar -xvzf coder-7.x-2.5.tar.gz > /dev/null 2>&1
  rm coder-7.x-2.5.tar.gz
fi

if [ ! -d ../custom ]; then
  echo "No coder-review tests run. custom modules directory not found."; exit 0;
fi
cd ../custom
drush en coder coder_review --uri=$URI -y > /dev/null 2>&1
drush cc drush > /dev/null 2>&1

# See what modules are in custom to be checked by coder.
DIRS=`ls -l --time-style="long-iso" $MYDIR | egrep '^d' | awk '{print $8}'`
if [[ -z $DIRS ]]; then
  echo "No coder-review tests run. No custom modules found."; exit 0;
fi

cd $SITE_PATH

# Run coder module.
drush coder-review $DIRS --uri=$URI --minor --ignore --ignorename --no-empty --ignores-pass
# Run PHP Lint.
# cd sites/all/modules/custom
# find . -name '.module' -or -name '.inc'  -or -name "*.php" -print0 | xargs -0 -n1 -P8 php -l 1>/dev/null
