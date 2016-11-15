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
  include nginx, nfs
}

node 'web02.hyjf.com' inherits basenode {
  include nginx, nfs
}


## java service
node 'srv01.hyjf.com' inherits basenode {
  include javaservices, nfs
}
node 'dep.hyjf.com' inherits basenode {
  include javaservices, nfs
}



