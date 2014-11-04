$user='kleer'
$password='$6$9ML80kewULF$adXWnnDzwa/bc4M5uVnP3I.6nz0we06LqNkMoR6pzvKtp7Wa47kKAx9o5BewhWBad7GcVvRr34VOTIzoY.4aP1'

user{$user:
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

$plugins = ['greenballs','jacoco','violations','msbuild',
			'htmlpublisher','mstestrunner','mstest']

class { 'jenkins':}

jenkins::plugin {$plugins:}

class { 'subversion':}

$rvm_version='1.25.32'
$ruby_version='ruby-1.9.3'
$rvm_users=['vagrant',$user]
$gemset='csd'
$gems = ['rspec','cucumber','sinatra']

class{ 'rvm::rvmrc':
  max_time_flag => 30
}
->
class { 'rvm':
	version => $rvm_version,
	require => User[$user]
}
->
rvm::system_user { $rvm_users:}
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
    ruby_version => "${ruby_version}@${gemset}",
    ensure       => latest,
}