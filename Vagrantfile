Vagrant::Config.run do |config|

    config.vm.customize do |vm|
        vm.memory_size = 512
    end

    config.vm.box = "precise32"
    config.vm.box_url = "http://files.vagrantup.com/precise32.box"
    config.vm.network :bridged
    config.vm.forward_port 80, 8080
    config.vm.share_folder("vagrant-root", "/vagrant", ".", :owner => 'vagrant', :group => 'vagrant', :mount_options => ['dmode=755', 'fmode=755'])

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "vagrant/manifests"
        puppet.manifest_file = "project.pp"
        puppet.module_path = "vagrant/modules"
    end
end
