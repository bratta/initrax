# -*- mode: ruby -*-
# vi: set ft=ruby :

$provision = <<SCRIPT
cd /vagrant # This is where the host folder/repo is mounted

ENV_FILE="/vagrant/.env.development"
if [ -f $ENV_FILE ]; then
  echo "Sourcing environment variables from $ENV_FILE"
  source $ENV_FILE
else
  echo "File $ENV_FILE not found; not sourcing any environment variables."
  echo "NOTE: This will cause errors in the provisioning process."
  echo "Copy .env.production.sample to $ENV_FILE and edit accordingly."
  exit 1
fi

# Add the yarn repo + yarn repo keys
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
sudo apt-add-repository 'deb https://dl.yarnpkg.com/debian/ stable main'

# Add repo for NodeJS
curl -sL https://deb.nodesource.com/setup_7.x | sudo bash -

# Add firewall rule to redirect 80 to 3000 and save
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3000
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt-get install iptables-persistent -y

# Add packages to build and run Initrax
sudo apt-get install \
  git-core curl zlib1g-dev build-essential libssl-dev \
  libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
  libxml2-dev libxslt1-dev libcurl4-openssl-dev \
  python-software-properties libffi-dev nodejs imagemagick \
  postgresql postgresql-contrib libpq-dev yarn libreadline-dev \
  -y

# Install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
cat << 'EOF' > ~/.bash_profile
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
EOF
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
export PATH="$HOME/.rbenv/bin::$PATH"
eval "$(rbenv init -)"
cd /vagrant
echo "Compiling Ruby $(cat .ruby-version): warning, this takes a while!!!"
rbenv install $(cat .ruby-version)
rbenv global $(cat .ruby-version)

# Configure database
sudo -u postgres createuser -U postgres $DB_USER -s
sudo sh -c "cat << 'EOF' > /etc/postgresql/9.5/main/pg_hba.conf
local   all                     all                     trust
host    all                     all     0.0.0.0/0       trust
EOF"
sudo service postgresql restart

# Install gems and node modules
gem install bundler
bundle install
yarn install

# Build Initrax
RAILS_ENV=development bundle exec rails db:setup
SCRIPT

$start = <<SCRIPT
# Uncomment these lines if you want vagrant to load up the application
# from a "vagrant up". Note that it will run in the foreground, requiring
# a ctrl-c to stop as well as process cleanup on the VM.
# cd /vagrant
# RAILS_ENV=development foreman start
echo "You are now ready to 'vagrant ssh' and then"
echo "run 'cd /vagrant && foreman start' to start the application."
echo "It will then be available locally as http://initrax.dev:3000/"
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/xenial64"

  config.vm.provider :virtualbox do |vb|
    vb.name = "initrax"
    vb.customize ["modifyvm", :id, "--memory", "1024"]

    # Disable VirtualBox DNS proxy to skip long-delay IPv6 resolutions.
    # https://github.com/mitchellh/vagrant/issues/1172
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]

    # Use "virtio" network interfaces for better performance.
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio"]

  end

  config.vm.hostname = "initrax.dev"

  # This uses the vagrant-hostsupdater plugin, and lets you
  # access the development site at http://initrax.dev.
  # To install:
  #   $ vagrant plugin install vagrant-hostsupdater
  if defined?(VagrantPlugins::HostsUpdater)
    config.vm.network :private_network, ip: "192.168.42.42", nictype: "virtio"
    config.hostsupdater.remove_on_suspend = false
  end

  config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ['rw']

  # Otherwise, you can access the site at http://localhost:3000
  # webpack-dev-server will be on port 8080
  config.vm.network :forwarded_port, guest: 80, host: 3000
  config.vm.network :forwarded_port, guest: 8080, host: 8080 

  # Full provisioning script, only runs on first 'vagrant up' or with 'vagrant provision'
  config.vm.provision :shell, inline: $provision, privileged: false

  # Start up script, runs on every 'vagrant up'
  config.vm.provision :shell, inline: $start, run: 'always', privileged: false
end
