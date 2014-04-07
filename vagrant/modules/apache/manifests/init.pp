class apache {

    # Make sure apache is present
    package { 'apache2':
        ensure => present,
    }

    service { 'apache2':
        ensure  => running,
        # Make sure apache is installed before checking
        require => Package['apache2'],
    }

    # Create the logs folder to put the log files of the vhost
    file { 'vhost-logs':
        ensure => 'directory',
        path   => '/vagrant/log',
    }

    file { 'vhost-htdocs':
        ensure => 'directory',
        path   => '/vagrant/htdocs',
    }

    # Ensure the public folder exists
    file { 'vhost-public':
        ensure => 'directory',
        path   => '/vagrant/htdocs/public',
        require => File['vhost-htdocs'],
    }

    # Create a virtual host file for our website
    file { 'vhost':
        ensure  => present,
        path    => '/etc/apache2/sites-available/000-default.conf',
        owner   => 'root',
        group   => 'root',
        content => template('apache/vhost.erb'),
        # Make sure apache is installed before creating the file
        require => [ Package['apache2'], File[ 'vhost-logs', 'vhost-public' ], ],
    }

    # Enable our virtual host
    file { 'vhost-enable':
        ensure  => link,
        path    => '/etc/apache2/sites-enabled/000-default.conf',
        target  => '/etc/apache2/sites-available/000-default.conf',
        # Make sure apache and the vhost file are there before symlink
        require => File['vhost'],
        notify  => Service['apache2'],
    }

    # Change user
    exec { "ApacheUserChange" :
        path    => [
            "/usr/bin",
            "/bin",
            "/usr/sbin",
            "/sbin",
            "/usr/local/bin",
            "/usr/local/sbin",
        ],
        command => "sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars",
        onlyif  => "grep -c 'APACHE_RUN_USER=www-data' /etc/apache2/envvars",
        require => Package["apache2"],
        notify  => Service["apache2"],
    }

    # Change group
    exec { "ApacheGroupChange" :
        path    => [
            "/usr/bin",
            "/bin",
            "/usr/sbin",
            "/sbin",
            "/usr/local/bin",
            "/usr/local/sbin",
        ],
        command => "sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars",
        onlyif  => "grep -c 'APACHE_RUN_GROUP=www-data' /etc/apache2/envvars",
        require => Package["apache2"],
        notify  => Service["apache2"],
    }

    exec { "apache_lockfile_permissions" :
        path    => [
            "/usr/bin",
            "/bin",
            "/usr/sbin",
            "/sbin",
            "/usr/local/bin",
            "/usr/local/sbin",
        ],
        command => "chown -R vagrant:www-data /var/lock/apache2",
        require => Package["apache2"],
        notify  => Service["apache2"],
    }

    # Load some modules
    define apache::loadmodule () {
        exec { "/usr/sbin/a2enmod $name" :
            unless  => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
            require => Package['apache2'],
            notify  => Service['apache2'],
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
