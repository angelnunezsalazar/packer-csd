$user='kleer'
$password='$6$9ML80kewULF$adXWnnDzwa/bc4M5uVnP3I.6nz0we06LqNkMoR6pzvKtp7Wa47kKAx9o5BewhWBad7GcVvRr34VOTIzoY.4aP1'

class csd::update{
	exec { "apt-update":
	    command => "/usr/bin/apt-get update",
	    before  => Stage["main"],
	}
}

class csd::kleer_user{
	user{$::user:
		ensure     => present,
	  	managehome => true,
		groups 	   => ['sudo'],
		password   => $password
	}

	file { '/etc/sudoers.d/kleer':
	  ensure 	=> present,
	  content   => 'kleer ALL=(ALL) NOPASSWD:ALL',
	  group     => 'root',
	  owner     => 'root',
	  mode      => 'ug=r'
	}
}

class csd::jenkins_and_plugins{
	$plugins = ['greenballs','jacoco','violations','htmlpublisher']

	class { 'jenkins':}

	jenkins::plugin {$plugins:}
}

class csd::ruby{
	$rvm_version='1.25.32'
	$ruby_version='ruby-1.9.3'
	$gemset='csd'
	$gems = ['rspec','cucumber','sinatra']

	class{ 'rvm::rvmrc':
	  max_time_flag => 30
	}
	->
	class { 'rvm':
		version => $rvm_version
	}
	->
	rvm::system_user { $::user:}
	->
	rvm_system_ruby { $ruby_version:
	    ensure      => present,
	    default_use => true
	}
	->
	rvm_gemset { "${ruby_version}@${gemset}":
	    ensure  => present
	}
	->
	rvm_gem { $gems:
	    ensure       => latest,
	    ruby_version => "${ruby_version}@${gemset}"
	}
	->
	exec {"rvm to bash":
		command => "echo 'source /etc/profile.d/rvm.sh' >> /home/${::user}/.bashrc",
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]
	}
}

class csd::desktop_apps{
	$apps = ["firefox","gedit","rapidsvn"]
	
	package { $apps:
		ensure => present
	}
}

class csd::download_projects{
	$svn_url = "http://svn.training.kleer.la/csd-master/"
	$directory = "CSD"
	exec { 'download projects':
	  	command => "svn export ${svn_url} --username carlos --password car /home/${::user}/${directory}",
	  	creates => "/home/${::user}/${directory}",
		path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
		require => Package['subversion']
	}
}

stage { 'pre':
  before => Stage["main"],
}

class { 'csd::update':
	stage => 'pre'
}

class { 'csd::kleer_user':
	stage => 'pre'
}

class { 'csd::jenkins_and_plugins':}

class { 'subversion':
	user => $::user,
	password => $::user
}

class {'csd::ruby':}

class {'csd::desktop_apps':}

class {'csd::download_projects':}

