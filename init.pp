class users {
  case $::operatingsystem {
    debian, ubuntu: {
      $os_admin_group = 'sudo'
    }
    centos, fedora, redhat: {
      $os_admin_group = 'wheel'
    }
    default:{
      $os_admin_group = 'wheel'
    }
  }
  
  # define servers
  $web_servers = ['web01','web02']
  $srv_servers = ['srv01','dep01']
  $all_servers = split(inline_template("<%= (web_servers+srv_servers).join(',') %>"),',')
  
  #groups
  group { [ 'admin' ]: 
    ensure => present,
    gid    => 1000,
  }
  
  # users
  
     'manchao':
      comment     => 'Man Chao',
      groups      => [ 'admin', $os_admin_group ],
      publickey   => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqJ6adhh6Y9OcuniWnESJFnJ9ZZWzzjOjnfe+W1bp9xsNAMFtYC8xv0ZPEtIpVp0c/0VGiJ0obVR/J8iUTsdYuLxQwnRUCae6IdDFO51qZcMwagMm6G1RBF1++Dw0J6AzyDeNSfQaqNy06ZqDHTN13Z1RabGMdlqa1vgPvjUj6JmprX0FLoKl9ApjVo4kPE8WkOjlR7juB/GzBlkVE43HD8IRZfK3Hhf59a1ve5ho6yTUOivCSWJXSf3u7p/7QkgMEfutP/Mr3xr2epwlIQUfPsSGQbrru7033Tg/lQxWWJnZfwP4JBxMB8x+ldl9qTn8xQJt8S3wOUGcKgPmNolWWw== manchao',
      uid         => '3002',
      servers     => $all_servers;
      
    
  }
}

class system {
  package {
    'iotop':  ensure => installed;
    'iftop':  ensure => installed;
    'htop':  ensure => installed;
    'unzip': ensure => installed;
    'ntpdate':  ensure => installed;
    'sysstat':  ensure => installed;
    'nc':  ensure => installed;
    'inotify-tools':  ensure => installed;
  }
  
  cron {
    'ntpdate':
      ensure  => present,
      command => '/usr/sbin/ntpdate -u cn.pool.ntp.org > /dev/null 2>&1',
      hour    => '*/4',
      minute  => '55',
      require => Package['ntpdate'],
      user    => 'root';
  }
}

class javaservices {
  package {
    'java-1.7.0-openjdk':        ensure => installed;
    'java-1.7.0-openjdk-devel':  ensure => installed;
  }
}
