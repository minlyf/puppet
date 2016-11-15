define useradd($comment, $uid, $groups, $publickey, $servers) {
#define useradd($comment, $groups, $publickey, $servers) {

  if $hostname in $servers {
    if $groups == '' {
      user {
        $name:
          comment     => $comment,
          ensure      => present,
          home        => "/home/${name}",
          managehome  => true,
          membership  => inclusive,
          shell       => '/bin/bash',
          uid         => $uid;
      }
    }else{ 
      user {
        $name:
          comment     => $comment,
          ensure      => present,
          groups      => $groups,
          home        => "/home/${name}",
          managehome  => true,
          membership  => inclusive,
          shell       => '/bin/bash',
          uid         => $uid;
      }
    }

    group {
      $name:
        gid         => $uid,
        require     => User[$name];
    }

    file {
      "/home/${name}":
        ensure      => directory,
        group       => $name,
        mode        => '0700',
        owner       => $name,
        require     => [ User[$name], Group[$name] ];
      "/home/${name}/.ssh":
        ensure      => directory,
        group       => $name,
        mode        => '0700',
        owner       => $name,
        require     => File["/home/${name}"];
      "/home/${name}/.ssh/authorized_keys":
        content     => $publickey,
        ensure      => present,
        group       => $name,
        mode        => '0600',
        owner       => $name,
        require     => File["/home/${name}/.ssh"];
    }

  }

}