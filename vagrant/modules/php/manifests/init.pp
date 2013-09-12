class php {

    # Install some base packages
    package { 'php5':
        ensure  => present,
    }

    $packages = [
            'php5-cli',
            'php5-dev',
            'php-apc',
            'php-pear',
            'php5-intl',
            'php5-mysql',
            'php5-mcrypt',
            'php5-curl',
        ]

    package { $packages:
        ensure  => present,
        require => Package['php5'],
    }

    # Copy over our default php.ini file
    file { 'php-ini':
        ensure  => present,
        path    => '/etc/php5/apache2/php.ini',
        owner   => 'root',
        group   => 'root',
        content => template('php/php.erb'),
        require => [ Package['php5'], ],
    }
}
