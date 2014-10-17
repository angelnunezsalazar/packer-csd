#https://github.com/ghoneycutt/puppet-svn

class subversion{
	Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
	
	$repositories_path = "/srv/svn/"
	$default_repository_name="default-repository"
	$default_user_name_password="vagrant"
	
	class { "apache": }

	apache::mod { 'dav_svn':}
	apache::mod { 'authn_core':}
	
	package {"subversion":
		ensure => present
	}
	
	group { "subversion":
		ensure => present
  	}
	
	exec {"add vagrant to subversion":
		unless => "grep -q 'subversion\\S*vagrant' /etc/group",
		command => "usermod -aG subversion vagrant",
		require => Group["subversion"]
	}
	
	file { $repositories_path:
		ensure 	=> directory,
		owner	=> "www-data",
		group 	=> "subversion",
		mode   	=> 2660,
		require => [Group["subversion"],Class["apache"]]
	}
	
	package {"apache2-utils":
		ensure => present,
		require => Class["apache"]
	}

	exec { 'add default user':
	  	command => "htpasswd -c -b /etc/apache2/dav_svn.passwd ${default_user_name_password} ${default_user_name_password}",
		require => Package["apache2-utils"]
	}

	exec { 'create default repository':
	  	command => "svnadmin create ${repositories_path}/${default_repository_name}",
		require => [Package["subversion"], File[$repositories_path]]
	}
	
	file { 'default repository permissions' :
		path    => "${repositories_path}/${default_repository_name}",
		ensure 	=> directory,
		owner	=> "www-data",
		group 	=> "subversion",
		mode   	=> 2660,
		recurse => true,
		require => Exec["create default repository"]
	}

	file { "/etc/apache2/mods-enabled/dav_svn.conf":
		content => template("subversion/dav_svn.conf.erb"),
		notify => Service["apache2"],
		require => [File["default repository permissions"],
					Apache::Mod['dav_svn'],Apache::Mod['authn_core']]
	}
}