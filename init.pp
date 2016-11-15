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
  $web_servers = ['web01','web02','w001']
  $srv_servers = ['srv01','srv02','srv03']
  $all_servers = split(inline_template("<%= (web_servers+srv_servers).join(',') %>"),',')
  
  #groups
  group { [ 'admin' ]: 
    ensure => present,
    gid    => 1000,
  }
  
  # users
  useradd {      
    'chendayong':
      comment     => 'Binary Chen',
      groups      => [ 'admin', $os_admin_group ],
      publickey   => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAo45sICj/6XXxGXfYgk+vOjxz6tzDrKbyC3gjmBuZ9fnuBCcghx82Ebtcrb8nynn/R1JRMaeXwPnolGMny7xcWA8Omp6REMiv6R5FbkOBb2cGfznradBLRoaadM44VDFkybeAA6cMWH4MswfUGWBTtovfbU7OoH2pUrK+XIU712LKUqhQg4jPDtHuWS9no3sPLyjWq5bAXWOoHfrDBqI9gHcmKr9G9tvyXGueKG7LToCYuUucqqJOxZiSvE7gBoRqDgzae1Jsy8ZOmHSzMa7EZv4Lcj8gMcpAHTGoaOWPBA2ADeLczCKRsPiJkYzZaOIJbHPynOZXvNPKaHbDXVrutw== binary.chen',
      uid         => '3001',
      servers     => $all_servers;
      
    'manchao':
      comment     => 'Man Chao',
      groups      => [ 'admin', $os_admin_group ],
      publickey   => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAqJ6adhh6Y9OcuniWnESJFnJ9ZZWzzjOjnfe+W1bp9xsNAMFtYC8xv0ZPEtIpVp0c/0VGiJ0obVR/J8iUTsdYuLxQwnRUCae6IdDFO51qZcMwagMm6G1RBF1++Dw0J6AzyDeNSfQaqNy06ZqDHTN13Z1RabGMdlqa1vgPvjUj6JmprX0FLoKl9ApjVo4kPE8WkOjlR7juB/GzBlkVE43HD8IRZfK3Hhf59a1ve5ho6yTUOivCSWJXSf3u7p/7QkgMEfutP/Mr3xr2epwlIQUfPsSGQbrru7033Tg/lQxWWJnZfwP4JBxMB8x+ldl9qTn8xQJt8S3wOUGcKgPmNolWWw== manchao',
      uid         => '3002',
      servers     => $all_servers;
      
     'qixiaoji':
      comment     => 'Qi Xiaoji',
      groups      => [ 'admin', $os_admin_group ],
      publickey   => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOnGJWOTd/l2l7/19P/Eukh3Hy2CE7/WDXR3lJ2pXgGDA+qgnZykBVpWGDJtoqI4Zw4GjWY7eb7Ni8LgF7N3Z8Gy9cw/JHFjoKacjiWcJgiuaKo/Y6Wsqm7q8lrrHKtGKI1hODch/bW8J1CIVCPUrtn673QT2mMRxpSAWrmNEBcVUkGkA5gXDOlgXT42sGpZ7u7Z4fgvXTvnE6lT1t4Lv16DaUSZRzRdEmNirquGJLNbGxXUucIm2IxZX928f2PuhSV19VmzJKG6p6NHOjc7bH7/had7kAMc4jqf2MQ6zVJwcl9dlfl41ExEmoj4Sc5LmtpxDOKZSFAcAKFH1RiSZV qixiaoji',
      uid         => '3003',
      servers     => $all_servers;
      
    'hubaozhi':
      comment     => 'Hu Baozhi',
      groups      => '',
      publickey   => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwhQctLuDP4tTPNnbp38n2IMHZ+Uq6aX4C6jiquutX8aT51G53XqENG4+EVOqbj2velz1pHKi/yOnZbnlpH6XzQL3kpL9eiopK6EyL3vUfcaS0EBRmOn8GryVMGphjygok+qdIDN4M5xJQptEBUrstAmhnrRbTTePVo7S+R89HssBJ3GIN7XRzll6GD7J78t1rW2Lk6/Fsz3aygvt5UU0EImoo04ocvWOjJI/9IoQNJHN6hfSUqOGK8sAuCqj4tpSaH+unc0HOLN3DD7HpkqlTjkDNGgv5i0nvVa4TiG6qt35HyIlRSjh14wqY02dwczYPLAN2JrlhlzhtgX4U1uVLQ== hubaozhi',
      uid         => '5000',
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