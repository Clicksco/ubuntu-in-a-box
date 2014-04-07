class php {

    # Install some base packages
    package { 'php5':
        ensure  => present,
    }

    $packages = [
            'php5-cli',
            'php5-dev',
            'php5-intl',
            'php5-mysql',
            'php5-mcrypt',
            'php5-curl',
        ]

    package { $packages:
        ensure  => latest,
    }
}
