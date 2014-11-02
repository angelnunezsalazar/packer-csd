Packer CSD
==========

# Descripción

# Requerimientos

- Ruby 2.+

# Cómo generar la máquina Virtual?

## Paso 1: Descargar los módulos externos

Instalar librarian-puppet:

    $ gem install librarian-puppet

Descargar los módulos:
    $ librarian-puppet install --path modules-vendor

## Paso 2: Descargar e instalar packer

## Paso 3: Generar la máquina virtual

# Qué contiene?
- JDK
- Jenkins (Puerto 8008)
- Apache
- Subversion (Puerto 80)
- RVM, Ruby

# Development

Verificar la sintaxis de puppet
	$ puppet parser validate manifests/init.pp

Mostrar que va a hacer puppet pero sin cambiar nada
	$ puppet apply –-noop --modulepath=modules:modules-vendor manifests/init.pp

Reprosionar con vagrant luego del primer "vagrant up"
	$ vagrant reload --provision

Verificar el template de packer
	$ packer validate ubuntu.json