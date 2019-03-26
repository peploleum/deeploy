#!/bin/bash

set -x
if [ $# -lt 4 ]; then
  echo "Usage: $0 GITHUB_USER_URL GITHUB_PROJECT_NAME GITLAB_PROJECT_NAME GITLAB_HOST_FQDN"
  echo
  echo GITHUB_USER_URL must be:
  echo "  • GitHub user url"
  echo "  • example: https://github.com/peploleum/"
  echo
  echo GITHUB_PROJECT_NAME must meet the following:
  echo "  • valid github project name"
  echo
  echo GITLAB_PROJECT_NAME must meet the following:
  echo "  • valid existing gitlab name"
  echo
  echo GITLAB_HOST_FQDN must meet the following:
  echo "  • gitlab host Fully Qualified Domain Name"
  echo
  echo  echo "Examples:"
  echo "  • $0 https://github.com/peploleum/ insight insight/insight gitlab.peploleum.com"
  exit 1
fi

mirrorsDir="$HOME/mirrors"

# Git Mirror Creation
mkdir $mirrorsDir
cd $mirrorsDir
git clone --mirror $1$2.git
cd $2.git
git remote set-url --push origin ssh://git@$4:9022/$3

# Automatic update script
file="$mirrorsDir/$2_update.sh"
echo "#!/bin/bash" > $file
echo "cd $mirrorsDir/$2.git" >> $file
echo "git fetch -p origin" >> $file
echo "git push --mirror" >> $file

chmod a+x $file

# Add to cron (check 2 minutes)
(crontab -l ; echo "*/2 * * * * $file") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
