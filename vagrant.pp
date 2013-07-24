node default {
    apt::source { 'puppetlabs':
        location   => 'http://apt.puppetlabs.com',
        repos      => 'main',
        key        => '4BD6EC30',
        key_server => 'pgp.mit.edu',
    }

    apt::source { 'puppetlabs-dependencies':
        location   => 'http://apt.puppetlabs.com',
        repos      => 'dependencies',
        key        => '4BD6EC30',
        key_server => 'pgp.mit.edu',
    }

    package { ['vim','git','puppet']:
        provider    => 'apt',
        ensure      => 'latest',
    }

    include hiera_data_in_modules

}
