class bootstrap { 

    Exec {
        path => [
            "/usr/bin", 
            "/bin", 
            "/usr/sbin", 
            "/sbin", 
            "/usr/local/bin", 
            "/usr/local/sbin",
        ]
    }

    # this makes puppet and vagrant shut up about the puppet group
    group { 'puppet':
        ensure => 'present',
    }

    # initial update of repos
    exec { 'apt-get update':
        command => '/usr/bin/apt-get update',
    }

    if $virtual == "virtualbox" and $fqdn == '' {
        $fqdn = "localhost"
    }

    # add any additional repos that we need
    package { "python-software-properties":
        ensure => present,
        require => Exec['apt-get update'],
    }

    #https://launchpad.net/~ondrej/+archive/php5
    exec { 'add-repositories':
        command => '/usr/bin/add-apt-repository ppa:ondrej/php5 -y',
        require => Package['python-software-properties'],
    }

    exec { 'post-repos-update':
        command => '/usr/bin/apt-get update',
        require => Exec['add-repositories'],
    }

    file { "hosts":
        path    => "/etc/hosts",
        ensure  => file,
        source  => "/vagrant/vagrant/manifests/hosts"
    }
}
