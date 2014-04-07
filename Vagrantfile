# Some config values
# The Box
$box = "precise32"
$box_url = "http://files.vagrantup.com/precise32.box"
$box_port = 8080
$box_ram = 512
$box_bridge = '' # Set default network bridge (don't commit this)
$debug = false

# Require a minimum version...
Vagrant.require_version ">= 1.3.5"

# Start configuring...
Vagrant.configure('2') do |config|

    # Specify the Box
    config.vm.box = $box
    config.vm.box_url = $box_url

    # Forwarding ports and bridging network adapters
    config.vm.network 'forwarded_port', guest: 80, host: $box_port
    config.vm.network 'forwarded_port', guest: 443, host: 8443
    config.vm.network 'forwarded_port', guest: 3306, host: 3306

    # Bridge the network if specified
    if $box_bridge != ''
        config.vm.network 'public_network', :bridge => $box_bridge
    else
        config.vm.network 'public_network'
    end

    # Set the share folder based on the host OS
    if config.vagrant.host == ':windows'
        config.vm.share_folder('vagrant-root', '/vagrant', '.', :owner => 'vagrant', :group => 'vagrant', :mount_options => ['dmode=755', 'fmode=755'])
    else
        # Private network for NFS
        config.vm.network 'private_network', ip: '192.168.50.4'
        config.vm.synced_folder './', '/vagrant', id: 'vagrant-root', nfs: true
    end

    # Virtualbox-specfic set up
    config.vm.provider 'virtualbox' do |vbox|
        vbox.customize ['modifyvm', :id, '--memory', $box_ram]
        vbox.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root', '1']
    end

    # Puppet settings
    config.vm.provision 'puppet' do |puppet|
        puppet.manifests_path = 'vagrant/manifests'
        puppet.manifest_file = "project.pp"
        puppet.module_path = 'vagrant/modules'

        if $debug
            puppet.options = '--verbose --debug --graph --graphdir /vagrant/vagrant/graphs'
        end
    end
end
