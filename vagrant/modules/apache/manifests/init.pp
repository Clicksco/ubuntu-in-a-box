class apache {

    # Make sure apache is present
    package { 'apache2':
        ensure => present,
    }

    # Make sure apache isn't running until configured
    # Later notify's will sort this out
    service { 'apache2':
        ensure  => stopped,
        # Make sure apache is installed before checking
        require => Package['apache2'],
    }

    # Create the logs folder to put the log files of the vhost
    file { 'vhost-logs':
        ensure => 'directory',
        path   => '/vagrant/log',
        require => Service['apache2'],
    }

    # Ensure the public folder exists
    file { 'vhost-public':
        ensure => 'directory',
        path   => '/vagrant/public',
        require => Service['apache2'],
    }

    # Create a virtual host file for our website
    file { 'vhost':
        ensure  => present,
        path    => '/etc/apache2/sites-available/default.conf',
        owner   => 'root',
        group   => 'root',
        content => template('apache/vhost.erb'),
        # Make sure apache is installed before creating the file
        require => [ Service['apache2'], File[ 'vhost-logs', 'vhost-public' ], ],
    }

    # Enable our virtual host
    file { 'vhost-enable':
        ensure  => link,
        path    => '/etc/apache2/sites-enabled/default.conf',
        target  => '/etc/apache2/sites-available/default.conf',
        # Make sure apache and the vhost file are there before symlink
        require => [ Service['apache2'], File['vhost'] ],
    }

    # Replace the apache user with vagrant
    # Note: this was awkward & didn't work in the apache class. Any pointers
    #       would be appreciated!
    file { 'apache-envvars':
        ensure  => present,
        path    => '/etc/apache2/envvars',
        owner   => 'root',
        group   => 'root',
        content => template('apache/envvars.erb'),
        require => Service['apache2'],
    }

    # Load some modules
    define apache::loadmodule () {
        exec { "/usr/sbin/a2enmod $name" :
            unless  => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
            require => Service['apache2'],
        }
    }

    # List out the module names we want to load
    $modules = [
        'rewrite',
        'expires',
        'deflate',
        'headers',
        'setenvif',
        'filter',
        'autoindex',
    ]
    apache::loadmodule{$modules :}
}
