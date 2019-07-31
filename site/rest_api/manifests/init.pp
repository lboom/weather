class rest_api {
	# base system setup
	package { 'epel-release':
		ensure => 'installed',
	}

	user { 'api':
		ensure 		 => 'present',
		managehome => 'false',
		home			 => '/opt/rest',
	}

	# python setup
	package { 'python-pip':
		ensure => 'installed',
		require => Package['epel-release'],
	}

	package { 'flask':
		ensure   => 'installed',
		provider => 'pip',
		require  => Package['python-pip'],
	}

	file { '/opt/rest':
		ensure  => 'directory',
		owner		=> 'api',
		group   => 'api',
		require => User['api'],
	}

	file { '/opt/rest/rest_api.py':
		source  => "puppet:///modules/rest_api/rest_api.py",
		owner   => 'api',
		group		=> 'api',
		mode		=> '0755',
		require => File['/opt/rest'],
	}
}
