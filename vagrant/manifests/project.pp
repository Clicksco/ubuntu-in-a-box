class project {

    # Declare some stages to ease the toe-stepping
    stage { 'pre'       : before => Stage['main'] }
    stage { 'platform'  : require => Stage['main'] }
    stage { 'server'    : require => Stage['platform'] }
    stage { 'services'  : require => Stage['server'] }
    stage { 'configure' : require => Stage['services'] }

    # Apply our classes to them
    class { 'bootstrap' : stage => pre }
    class { 'utils'     : stage => platform }
    class { 'apache'    : stage => server }
    class { 'php'       : stage => services }
    class { 'mysql'     : stage => services }
    class { 'sendmail'  : stage => services }
    class { 'config'    : stage => configure }

    # Load them up and...
    include bootstrap
    include utils
    include apache
    include php
    include mysql
    include sendmail
    include config
}

# ...Go!
include project
