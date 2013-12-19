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
