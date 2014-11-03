$plugins = ['greenballs','jacoco','violations','msbuild',
			'htmlpublisher','mstestrunner','mstest']

class { 'jenkins':}

jenkins::plugin {$plugins:}

class { 'subversion':}

$rvm_version='1.25.32'
$ruby_version='ruby-1.9.3'
$rvm_users=['vagrant','kleer']
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