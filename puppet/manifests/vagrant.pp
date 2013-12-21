package { 'bundler':
  ensure => 'installed',
  provider => 'gem',
}

package { 'mongodb':
  ensure => 'present'
}

service { 'mongodb':
  ensure => 'running',
  require => Package['mongodb']
}

exec { "install gems":
    environment => "BUNDLE_GEMFILE=/home/vagrant/robot_day_care/Gemfile",
    command => "bundle install",
    path    => "/opt/ruby/bin/:/usr/bin/:/bin/",
    unless => "bundle check",
}

file {
  '/etc/init.d/robot_day_care':
    ensure => present,
    source => '/home/vagrant/robot_day_care/puppet/files/robot_day_care';
}

service { 'robot_day_care':
  ensure => 'running',
  require => [File['/etc/init.d/robot_day_care'], Exec['install gems'], Service['mongodb']]
}
