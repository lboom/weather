class rest_api {
  # base system setup
  package { 'epel-release':
    ensure => 'installed',
  }

  user { 'api':
    ensure     => 'present',
    managehome => 'false',
    home       => '/opt/rest',
  }

  # python setup
  package { 'python-pip':
    ensure => 'installed',
    require => Package['epel-release'],
  }

  $pip_pkgs = [
    'flask',
    'supervisor',
    'requests',
  ]

  package { $pip_pkgs:
    ensure   => 'installed',
    provider => 'pip',
    before   => Exec['api_service'],
    require  => Package['python-pip'],
  }

  file { '/opt/rest':
    ensure  => 'directory',
    owner   => 'api',
    group   => 'api',
    require => User['api'],
  }

  file { '/opt/rest/rest_api.py':
    source  => "puppet:///modules/rest_api/rest_api.py",
    owner   => 'api',
    group   => 'api',
    mode    => '0755',
    require => File['/opt/rest'],
  }

  file { '/opt/rest/pdx_weather.db':
    source  => "puppet:///modules/rest_api/pdx_weather.db",
    owner   => 'api',
    group   => 'api',
    require => File['/opt/rest'],
  }

  # supervisor setup
  file { '/opt/rest/rest_supervisor.conf':
    source  => "puppet:///modules/rest_api/rest_supervisor.conf",
    owner   => 'api',
    group   => 'api',
    before  => Exec['api_service'],
    require => File['/opt/rest'],
  }

  exec { 'api_service':
    command => '/usr/bin/supervisord -c rest_supervisor.conf',
    cwd     => '/opt/rest',
    unless  => '/usr/bin/test -f /opt/rest/supervisord.pid',
    require => File['/opt/rest/rest_supervisor.conf',
                    '/opt/rest/pdx_weather.db'],
  }
}
