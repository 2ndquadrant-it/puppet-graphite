# graphite

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-graphite.svg?branch=master)](https://travis-ci.org/bodgit/puppet-graphite)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-graphite/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-graphite?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/graphite.svg)](https://forge.puppetlabs.com/bodgit/graphite)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-graphite.svg)](https://gemnasium.com/bodgit/puppet-graphite)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with graphite](#setup)
    * [What graphite affects](#what-graphite-affects)
    * [Beginning with graphite](#beginning-with-graphite)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: graphite::api](#class-graphiteapi)
        * [Class: graphite::api::memcached](#class-graphiteapimemcached)
        * [Class: graphite::api::redis](#class-graphiteapiredis)
        * [Class: graphite::web](#class-graphiteweb)
        * [Class: graphite::web::ldap](#class-graphitewebldap)
    * [Examples](#examples)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages both the Graphite Django-based web frontend and/or the
lighter API frontend.

## Module Description

This module installs the relevant frontend packages, configures them and
optionally enables LDAP authentication and/or caching via Memcached or Redis
where possible. It also manages running the frontend either directly as a
standalone service or through a webserver such as Apache.

## Setup

If running on Puppet 3.x you will need to have the future parser enabled. On
RHEL/CentOS platforms you will need to enable the EPEL repository first.

### What graphite affects

* The package(s) providing the Graphite web software.
* The `/etc/graphite-web/local_settings.py` configuration file.
* Creating the database schema.
* Generating a basic Apache virtual host configuration.
* The package(s) providing the Graphite API software.
* The `/etc/graphite-api.yaml` configuraton file.
* The service controlling the running of Graphite API as a daemon.

### Beginning with graphite

```puppet
class { '::graphite::web':
  secret_key => 'mysecretkey',
}

# or

include ::graphite::api
```

## Usage

### Classes and Defined Types

#### Class: `graphite::api`

**Parameters within `graphite::api`:**

##### `address`

IP address to listen on, defaults to `127.0.0.1`.

##### `allowed_origins`

An array of allowed host header values. Builds the `allowed_origins` setting.

##### `carbon_hosts`

An array of hashes for each carbon instance. Hash must contain `host`
and `port` keys and optionally an `instance` key. Builds the `carbon.hosts`
setting.

##### `carbon_metric_prefix`

Maps to the `carbon.carbon_prefix` setting.

##### `carbon_retry_delay`

Maps to the `carbon.retry_delay` setting.

##### `carbon_timeout`

Maps to the `carbon.timeout` setting.

##### `conf_file`

Defaults to `/etc/graphite-api.yaml`.

##### `group`

Group to run as, defaults to `graphite-api`.

##### `package_name`

The package name to install.

##### `port`

Port to listen on, defaults to `8888`.

##### `render_errors`

Maps to the `render_errors` setting.

##### `replication_factor`

Maps to the `carbon.replicaton_factor` setting.

##### `service_name`

The name of the service, defaults to `graphite-api`.

##### `state_dir`

Path to the state directory, defaults to `/var/lib/graphite-api`.

##### `time_zone`

Maps to the `time_zone` setting.

##### `user`

User to run as, defaults to `graphite-api`.

##### `whisper_dir`

Maps to the `whisper.directories` setting.

##### `workers`

Number of workers to run, defaults to `4`.

#### Class: `graphite::api::memcached`

**Parameters within `graphite::api::memcached`:**

##### `servers`

An array of hashes for each memcached server. Hash must contain `host` and
`port` keys.

##### `key_prefix`

Defaults to `graphite-api`.

##### `timeout`

Defauls to `60`.

#### Class: `graphite::api::redis`

**Parameters within `graphite::api::redis`:**

##### `host`

Redis hostname.

##### `database`

Redis database number, defaults to `0`.

##### `key_prefix`

Defaults to `graphite-api`.

##### `package_name`

The package name of the Redis support package to install.

##### `password`

Optional Redis password.

##### `port`

Redis port, defauls to `6379`.

##### `timeout`

Defaults to `60`.

#### Class: `graphite::web`

**Parameters within `graphite::web`:**

##### `secret_key`

Maps to the `SECRET_KEY` setting.

##### `allowed_hosts`

An array of allowed host header values. Builds the `ALLOWED_HOSTS` setting.

##### `apache_resources`

A hash of Apache resources to create, each key should be an Apache defined
type with the value being a further hash where each key is the title and the
value is the resource attributes.

##### `carbonlink_hosts`

An array of hashes for each carbon instance. Hash must contain `host`
and `port` keys and optionally an `instance` key. Builds the
`CARBONLINK_HOSTS` setting.

##### `carbonlink_query_bulk`

Maps to the `CARBONLINK_QUERY_BULK` setting.

##### `carbonlink_timeout`

Maps to the `CARBONLINK_TIMEOUT` setting.

##### `cluster_servers`

An array of hashes for each remote web instance. Hash must contain `host` key
and optionally a `port` key. Builds the `CLUSTER_SERVERS` setting.

##### `conf_dir`

Maps to the `CONF_DIR` setting. Also used as the path for the various
configuration files.

##### `databases`

Hash of hashes for the database settings. Only key supported is `default` and
the child hash must contain `name` and `engine` keys and optionally `user`,
`password`, `host` and `port` keys. Builds the `DATABASES` setting.

##### `debug`

Maps to the `DEBUG` setting.

##### `default_cache_duration`

Maps to the `DEFAULT_CACHE_DURATION` setting.

##### `documentation_url`

Maps to the `DOCUMENTATION_URL` setting.

##### `flushrrdcached`

Maps to the `FLUSHRRDCACHED` setting.

##### `graphite_root`

Maps to the `GRAPHITE_ROOT` setting. Defaults to `/usr/share/graphite`.

##### `http_server`

Only `apache` is currently supported.

##### `log_cache_performance`

Maps to the `LOG_CACHE_PERFORMANCE` setting.

##### `log_dir`

Maps to the `LOG_DIR` setting.

##### `log_metric_access`

Maps to the `LOG_METRIC_ACCESS` setting.

##### `log_rendering_performance`

Maps to the `LOG_RENDERING_PERFORMANCE` setting.

##### `memcache_hosts`

An array of hashes for each memcached server. Hash must contain `host` and
`port` keys. Builds the `MEMCACHE_HOSTS` setting.

##### `package_name`

The name of the package to install.

##### `remote_find_cache_duration`

Maps to the `REMOTE_FIND_CACHE_DURATION` setting.

##### `remote_prefetch_data`

Maps to the `REMOTE_PREFETCH_DATA` setting.

##### `remote_rendering`

Maps to the `REMOTE_RENDERING` setting.

##### `remote_render_connect_timeout`

Maps to the `REMOTE_RENDER_CONNECT_TIMEOUT` setting.

##### `remote_store_fetch_timeout`

Maps to the `REMOTE_STORE_FETCH_TIMEOUT` setting.

##### `remote_store_find_timeout`

Maps to the `REMOTE_STORE_FIND_TIMEOUT` setting.

##### `remote_store_merge_results`

Maps to the `REMOTE_STORE_MERGE_RESULTS` setting.

##### `remote_store_retry_delay`

Maps to the `REMOTE_STORE_RETRY_DELAY` setting.

##### `remote_store_use_post`

Maps to the `REMOTE_STORE_USE_POST` setting.

##### `rendering_hosts`

An array of hashes for each remote web instance. Hash must contain `host` key
and optionally a `port` key. Builds the `RENDERING_HOSTS` setting.

##### `rrd_dir`

Maps to the `RRD_DIR` setting. Defaults to `${storage_dir}/rrd`.

##### `storage_dir`

Maps to the `STORAGE_DIR` setting. Defaults to `/var/lib/carbon`.

##### `time_zone`

Maps to the `TIME_ZONE` setting.

##### `whisper_dir`

Maps to the `WHISPER_DIR` setting. Defaults to `${storage_dir}/whisper`.

#### Class: `graphite::web::ldap`

**Parameters within `graphite::web::ldap`:**

##### `uri`

Maps to the `LDAP_URI` setting.

##### `search_base`

Maps to the `LDAP_SEARCH_BASE` setting.

##### `bind_dn`

Maps to the `LDAP_BASE_USER` setting.

##### `bind_password`

Maps to the `LDAP_BASE_PASS` setting.

##### `search_filter`

Maps to the `LDAP_USER_QUERY` setting.

##### `package_name`

The name of the LDAP support package to install.

### Examples

Install Graphite API in front of a single carbon cache instance:

```puppet
include ::carbon

class { '::graphite::api':
  carbon_hosts => [
    {
      'host' => '127.0.0.1',
      'port' => 7002,
    },
  ],
  require      => Class['::carbon'],
}
```

Extend the above to include a Memcached caching layer:

```puppet
include ::carbon
include ::memcached

class { '::graphite::api':
  carbon_hosts => [
    {
      'host' => '127.0.0.1',
      'port' => 7002,
    },
  ],
  require      => Class['::carbon'],
}

class { '::graphite::api::memcached':
  servers => [
    {
      'host' => '127.0.0.1',
      'port' => 11211,
    },
  ],
  require => Class['::memcached'],
}
```

Use Redis instead:

```puppet
include ::carbon
include ::redis

class { '::graphite::api':
  carbon_hosts => [
    {
      'host' => '127.0.0.1',
      'port' => 7002,
    },
  ],
  require      => Class['::carbon'],
}

class { '::graphite::api::redis':
  host    => '127.0.0.1',
  require => Class['::redis'],
}
```

Install Graphite web in front of a single carbon cache instance with
Memcached caching enabled:

```puppet
include ::carbon
include ::memcached

class { '::apache':
  default_confd_files => false,
  default_mods        => false,
  default_vhost       => false,
}

class { '::graphite::web':
  secret_key       => 'abc123',
  carbonlink_hosts => [
    {
      'host' => '127.0.0.1',
      'port' => 7002,
    },
  ],
  memcache_hosts   => [
    {
      'host' => '127.0.0.1',
      'port' => 11211,
    },
  ],
  require          => Class['::carbon'],
}
```

Extend the above to also configure LDAP authentication:

```puppet
include ::openldap
include ::openldap::client
class { '::openldap::server':
  root_dn              => 'cn=Manager,dc=example,dc=com',
  root_password        => 'secret',
  suffix               => 'dc=example,dc=com',
  access               => [
    'to attrs=userPassword by self =xw by anonymous auth',
    'to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage by users read',
  ],
  ldap_interfaces      => ['127.0.0.1'],
  local_ssf            => 256,
}
::openldap::server::schema { 'cosine':
  position => 1,
}
::openldap::server::schema { 'inetorgperson':
  position => 2,
}
::openldap::server::schema { 'nis':
  position => 3,
}

include ::carbon
include ::memcached

class { '::apache':
  default_confd_files => false,
  default_mods        => false,
  default_vhost       => false,
}

class { '::graphite::web':
  secret_key       => 'abc123',
  carbonlink_hosts => [
    {
      'host' => '127.0.0.1',
      'port' => 7002,
    },
  ],
  memcache_hosts   => [
    {
      'host' => '127.0.0.1',
      'port' => 11211,
    },
  ],
  require          => Class['::carbon'],
}

class { '::graphite::web::ldap':
  bind_dn       => 'cn=Manager,dc=example,dc=com',
  bind_password => 'secret',
  search_base   => 'dc=example,dc=com',
  search_filter => '(uid=%s)',
  uri           => 'ldap://127.0.0.1',
  require       => Class['::openldap::server'],
}
```

## Reference

### Classes

#### Public Classes

* [`graphite::api`](#class-graphiteapi): Main class for managing the Carbon daemons.
* [`graphite::api::memcached`](#class-graphiteapimemcached): Main class for managing the Carbon daemons.
* [`graphite::api::redis`](#class-graphiteapiredis): Main class for managing the Carbon daemons.
* [`graphite::web`](#class-graphiteweb): Main class for managing the Carbon daemons.
* [`graphite::web::ldap`](#class-graphitewebldap): Main class for managing the Carbon daemons.

#### Private Classes

* `graphite::params`: Different configuration data for different systems.
* `graphite::api::install`: Handles Graphite API installation.
* `graphite::api::config`: Handles Graphite API configuration.
* `graphite::api::params`: Different configuration data for different systems.
* `graphite::api::service`: Handles running the Graphite API service.
* `graphite::api::memcached::install`: Installs the Memcached support.
* `graphite::api::memcached::config`: Handles configuring Memcached caching.
* `graphite::api::redis::install`: Installs the Redis support.
* `graphite::api::redis::config`: Handles configuring Redis caching.
* `graphite::web::install`: Handles Graphite web installation.
* `graphite::web::config`: Handles Graphite web configuration.
* `graphite::web::params`: Different configuration data for different systems.
* `graphite::web::ldap::install`: Installs the LDAP support.
* `graphite::web::ldap::config`: Handles configuring LDAP authentication.

## Limitations

This module intentionally doesn't manage the Carbon daemons, see my other
module which does that.

This module has been built on and tested against Puppet 3.0 and higher.

The module has been tested on:

* RedHat/CentOS Enterprise Linux 7

Testing on other platforms has been light and cannot be guaranteed.

## Development

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-graphite).
