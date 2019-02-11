#!/bin/bash

echo param 1 : GitHub user link --- https://github.com/username/
echo param 2 : GitHub project name --- repository-to-mirror
echo param 3 : GitLab project --- username/repository

mirrorsDir="$HOME/mirrors"

# Git Mirror Creation
mkdir $mirrorsDir
cd $mirrorsDir
git clone --mirror $1$2.git
cd $2.git
git remote set-url --push origin ssh://git@gitlab.peploleum.com:9022/$3

# Automatic update script
file="$mirrorsDir/$2_update.sh"
echo "#!/bin/bash" > $file
echo "cd $mirrorsDir/$2.git" >> $file
echo "git fetch -p origin" >> $file
echo "git push --mirror" >> $file

chmod a+x $file

# Add to cron (check 2 minutes)
(crontab -l ; echo "*/2 * * * * $file") 2>&1 | grep -v "no crontab" | sort | uniq | crontab -
