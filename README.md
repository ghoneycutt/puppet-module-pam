# puppet-module-pam

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with pam](#setup)
   * [What pam affects](#what-pam-affects)
   * [Setup requirements](#setup-requirements)
   * [Beginning with pam](#beginning-with-pam)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module description

This module manages PAM including accesslogin and limits.conf with
functionality to create limits fragments for use in other modules. There
are examples for using this with VAS/QAS.

## Setup

### What pam affects

Manages the packages and files regarding PAM. These vary by platform
though generally include things such as the following.

* `/etc/pam.conf`
* `/etc/pam.d`
* `/etc/security/access.conf`
* `/etc/security/limits.conf`
* `/etc/security/limits.d`

### Setup requirements
This module requires `stdlib`. When deployed by default it will require
`nsswitch`. See below for more information.

#### Optional

##### nsswitch

By default this module will include the `nsswitch` class with the
settings `pam::manage_nsswitch`. This module is meant to be used with
the Approved [nsswitch](https://github.com/trlinkin/puppet-nsswitch)
module.

##### SSSD

This module has been deployed in production along with
[sgnl05/sssd](https://github.com/sgnl05/sgnl05-sssd). Please see
`examples/hiera/sssd/RedHat-6.yaml` file for an example with the
additional SSSD entries added via hiera.

### Beginning with pam

Include the main `pam` class.

#### Specifying the allowed users

##### Example using an array

As an array where the origin for each is 'ALL'.

```yaml
pam::allowed_users:
  - root
  - ops
  - devs
```

This would create `/etc/security/access.conf` with the following content.

```
# This file is being maintained by Puppet.
# DO NOT EDIT
#

# allow only the groups listed
+:root:ALL
+:ops:ALL
+:devs:ALL

# default deny
-:ALL:ALL
```

##### Example using a hash

As a hash where the user/group can optionally specify the origin.

```yaml
pam::allowed_users:
  'username':
  'username1':
    - 'cron'
    - 'tty0'
  'username2': 'tty1'
```

This would create `/etc/security/access.conf` with the following content.

```
# This file is being maintained by Puppet.
# DO NOT EDIT
#

#allow only the groups listed
+:username:ALL
+:username1:cron tty0
+:username2:tty1

# default deny
-:ALL:ALL
```

#### Setting limits
##### Example:

```yaml
pam::limits_fragments:
  custom:
    list:
      - '* soft nofile 2048'
      - '* hard nofile 8192'
      - '* soft as 3145728'
      - '* hard as 4194304'
      - '* hard maxlogins 300'
      - '* soft cpu 720'
      - '* hard cpu 1440'
```

This would create `/etc/security/limits.d/custom.conf` with content

```
# This file is being maintained by Puppet.
# DO NOT EDIT
* soft nofile 2048
* hard nofile 8192
* soft as 3145728
* hard as 4194304
* hard maxlogins 300
* soft cpu 720
* hard cpu 1440
```

#### Specifying the content of a service
Manage PAM file for specific service.

##### Example:
You can specify a hash to manage the services in Hiera

```yaml
pam::services:
  'sudo':
    content : 'auth     required       pam_unix2.so'
```

## Usage

Minimal and normal usage.

```puppet
include pam
```

## Limitations

This module has been tested to work on the following systems with Puppet
versions 5 and 6 with the Ruby version associated with those releases.
Please see `.travis.yml` for a full matrix of supported versions. This
module aims to support the current and previous major Puppet versions.

 * EL 6
 * EL 7
 * EL 8
 * EL 9
 * Amazon Linux 2
 * Debian 9
 * Debian 10
 * Debian 11
 * Ubuntu 14.04 LTS
 * Ubuntu 16.04 LTS
 * Ubuntu 18.04 LTS
 * Ubuntu 20.04 LTS
 * Ubuntu 22.04 LTS

### May work

These platforms have spec tests and have been verified in the past,
though are not functionally tested and formally supported.

 * EL 5
 * Solaris 9
 * Solaris 10
 * Solaris 11
 * Suse 9
 * Suse 10
 * Suse 11
 * Suse 12
 * Suse 15
 * OpenSuSE 13.1
 * Debian 7
 * Debian 8
 * Ubuntu 12.04 LTS

## Development

See `CONTRIBUTING.md` for information related to the development of this
module.
