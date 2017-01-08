# vagrant-nginx-rails-unicorn

1. Create vagrant vm directory.
   
   cd ~/kcs/vagrant
   mkdir dbaexpert
   cd dbaexpert

2. Created shared directory and go there

   mkdir shared;cd shared

3. Clone this repo

   git clone git@github.com:reachsreedhar/vagrant-nginx-rails-unicorn.git

4. Rename vagrant-nginx-rails-unicorn to setup-scripts

   mv vagrant-nginx-rails-unicorn setup-scripts

5. Copy Vagrantfile from templates to vagrant vm home directory

   cp setup-scripts/templates/Vagrantfile ~/kcs/vagrant/dbaexpert/.

6. Goto VM root location and edit Vagrantfile and make necessary changes. Refer the examples for help.

   cd ~/kcs/vagrant/dbaexpert
   vi Vagrantfile

7. Bring up VM

   vagrant up

8. Login to the VM and go to /vagrant/shared/setup-scripts

   vagrant ssh
   cd /vagrant/shared/setup-scripts

8. Execute 01 thru 09 scripts in that order and make sure to follow any instructions from each script. Some scripts need to be run under 'sudo'.

    sudo ./01_change_hostname.bash
    sudo ./02_disable_selinux.bash
    ./03_copy_files.bash
    sudo ./04_install_ruby_install.bash
    sudo ./05_install_chruby.bash
    sudo ./06_install-awscli.bash
    ./07_setup_rails.bash
    ./08_setup_unicorn.bash
    ./09_setup_nginx.bash

9. Verify if Rails app is now running using a browser! Weblink would be http://localhost:<mapped port>
