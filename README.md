Packer CSD
==========

# Descripción

# Requerimientos

- Ruby 2.+

# Cómo generar la máquina Virtual?

## Paso 1: Instalar herramientas

Packer:
	http://www.packer.io/docs/installation.html

Librarian-puppet:
    $ gem install librarian-puppet

## Paso 2: Descargar módulos externos para el provisionamiento
    $ librarian-puppet install --path provisioning/modules-vendor

## Paso 3: Generar la máquina virtual
	$ gem build ubuntu.json

# Qué contiene?
- JDK
- Jenkins (Puerto 8008)
- Apache
- Subversion (Puerto 80)
- RVM, Ruby

# Development

Instalar puppet:
	https://docs.puppetlabs.com/guides/install_puppet/pre_install.html

Verificar la sintaxis de puppet
	$ puppet parser validate manifests/init.pp

Mostrar que va a hacer puppet pero sin cambiar nada
	$ puppet apply –-noop --modulepath=modules:modules-vendor manifests/init.pp

Reprosionar con vagrant luego del primer "vagrant up"
	$ vagrant reload --provision

Verificar el template de packer
	$ packer validate ubuntu.json