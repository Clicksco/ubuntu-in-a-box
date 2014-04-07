class mysql {

    # Install some base packages
    package { 'mysql-server':
        ensure  => present,
    }

    # Make sure MySQL is running
    service { 'mysql':
        ensure  => running,
        # Make sure mysql is installed before checking
        require => [ Package['mysql-server'] ],
    }

    exec { "create-database":
        unless  => "/usr/bin/mysql -uroot -p project_local",
        command => "/usr/bin/mysql -uroot -p -e \"create database project_local;\"",
        require => Service["mysql"],
    }
}
