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
}
