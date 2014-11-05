#https://github.com/ghoneycutt/puppet-svn

class subversion($user = 'vagrant', $password = 'vagrant', $repository_name='default-repository'){
	Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }
	
	$repositories_path = '/srv/svn/'
	
	class { 'apache': }

	apache::mod { 'dav_svn':}
	apache::mod { 'authn_core':}
	
	package {'subversion':
		ensure => present
	}
	
	group { 'subversion':
		ensure => present
  	}
	
	exec {'add vagrant to subversion':
		unless => 'grep -q "subversion\\S*vagrant" /etc/group',
		command => 'usermod -aG subversion vagrant',
		require => Group['subversion']
	}
	
	file { $repositories_path:
		ensure 	=> directory,
		owner	=> 'www-data',
		group 	=> 'subversion',
		mode   	=> 2660,
		require => [Group['subversion'],Class['apache']]
	}
	
	package {'apache2-utils':
		ensure => present,
		require => Class['apache']
	}

	exec { 'add default user':
	  	command => "htpasswd -c -b /etc/apache2/dav_svn.passwd ${user} ${password}",
	  	creates => '/etc/apache2/dav_svn.passwd',
		require => Package['apache2-utils']
	}

	exec { 'create default repository':
	  	command => "svnadmin create ${repositories_path}/${repository_name}",
	  	creates => "${repositories_path}/${repository_name}",
		require => [Package['subversion'], File[$repositories_path]]
	}
	
	file { 'default repository permissions' :
		ensure 	=> directory,
		path    => "${repositories_path}/${repository_name}",
		owner	=> 'www-data',
		group 	=> 'subversion',
		mode   	=> 2660,
		recurse => true,
		require => Exec['create default repository']
	}

	file { '/etc/apache2/mods-enabled/dav_svn.conf':
		content => template('subversion/dav_svn.conf.erb'),
		notify => Service['apache2'],
		require => [File['default repository permissions'],
					Apache::Mod['dav_svn'],Apache::Mod['authn_core']]
	}
}