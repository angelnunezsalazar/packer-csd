class { "jenkins":}

$plugins = ['jacoco','violations','msbuild',
			'htmlpublisher','mstestrunner','mstest']

jenkins::plugin {$plugins:}

class { "subversion":}



