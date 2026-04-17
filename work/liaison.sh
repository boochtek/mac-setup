# Software required for use at Liaison International.


source 'homebrew.sh'


## Things needed for WebAdMIT itself.
brew install git-flow
brew install phantomjs
brew install unixodbc
brew install --with-unixodbc freetds
brew install sqsh
brew install postgresql
brew install redis
brew install homebrew/boneyard/wkhtmltopdf


## Communication Methods
brew install --quiet --cask hipchat
# TODO: Google Hangouts SSB.
brew tap nviennot/tmate
brew install tmate
brew install --quiet --cask skype

## PostgreSQL configuration.

# Set shared memory to 1 GB, both now and after a reboot.
sudo sysctl -w kern.sysv.shmmax=1073741824 # Was 4194304 by default on Mac OS X 10.8
sudo sysctl -w kern.sysv.shmall=262144 # (In number of 4k pages) Was 1024 by default on Mac OS X 10.8
sudo sh -c 'cat >> /etc/sysctl.conf' <<-EOF
kern.sysv.shmmax=1073741824
kern.sysv.shmall=262144
kern.sysv.shmmin=1
kern.sysv.shmmni=32
kern.sysv.shmseg=8
EOF

# Initialize the database structure.
PGDATA=/usr/local/var/postgres pg_ctl init -D /usr/local/var/postgres -o '-E utf8'

# Have launchd start PostgreSQL at login.
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents

# Start PostgreSQL now.
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
launchctl start homebrew.mxcl.postgresql

# Create a user for webadmit database:
createuser -s webadmit

# Make sure Homebrew Postgres commands are run instead of system commands.
export PATH=/usr/local/bin:$PATH

# Be sure to also set the $PATH correctly in your .bashrc file as well.


## Redis.

# Have launchd start Redis at login.
ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents

# Start Redis now:
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
launchctl start homebrew.mxcl.redis

# NOTE: You can just run redis-server in a Terminal tab, if you don't want to always have it running.



## Project Management

# TODO: Jira SSB.


## Project Code
old_pwd=$(pwd)
mkdir -p Work/Liaison
cd Work/Liaison
git clone git@github.com:Liaison-Intl/WebAdMIT-meta.git WebAdMIT-meta
cd WebAdMIT-meta
./SETUP.sh
cd $old_pwd
