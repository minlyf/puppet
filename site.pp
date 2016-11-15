import 'useradd.pp'
import 'init.pp'

node basenode {
  include sudo, users, system
  
  Exec { 
    path    => "/usr/bin:/bin:/usr/sbin:/sbin",
    timeout => 1800,
  }
  
  exec { 'create_user_www':
    command    => "useradd www -s /sbin/nologin -d /var/www",
    unless     => 'grep -q www /etc/passwd',
  }
  
}

## PHP server
node 'web01.hyjf.com' inherits basenode {
  include nginx, php, nfs
}

node 'web02.hyjf.com' inherits basenode {
  include nginx, php, nfs
}

node 'w001.hyjf.com' inherits basenode {
  include nginx, php
}

## java service
node 'srv01.hyjf.com' inherits basenode {
  include javaservices, nfs
}
node 'srv02.hyjf.com' inherits basenode {
  include javaservices, nfs
}

## backend node
node 'srv03.hyjf.com' inherits basenode {
  include javaservices, nfs, nginx
}

