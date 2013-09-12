class utils {
    $packages = [
            "curl", 
            'git', 
            'acl',
        ]

    package { $packages:
        ensure => present,
    }
}
