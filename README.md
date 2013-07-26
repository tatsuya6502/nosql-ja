# NoSQL Demo Matirials

@TODO: Translate to Japanese.

This seminar material contains the followings:

- MongoDB
  * Ruby client

- Cassandra
  * Ruby client (legacy Thrift)
  * CQL3

- VoltDB
  * `sqlcmd` (for ad-hoc queries) and `csvloader`

- Neo4J
  * Ruby client

Hopefully, I'll have more time to add the followings in the future:

- Redis
  * Ruby client

- Infinispan
  * Scala client

- VoltDB
  * Scala client


## Preparation

- Fedora 19 x86_64

In the future, I'll use followings to demonstrate multi node
deployment.

- SmartOS with Solaris Zones (on HP MicroServer)
- Arch Linux x86_64 with Docker (on Mac mini)


## Installation (Fedora 19)

@TODO: Use Chef Solo to automate this process.


### Enable Remote Login (sshd)

**TODO** (System Settings)


### Install Dev Tools

```console
$ sudo yum groupinstall "Development Tools"
```

### Install Oracle JDK

- Version 1.7.0_25
- `alternatives`


### Install Scala (Optional)

- Version 2.10.2
- http://www.scala-lang.org/downloads/distrib/files/scala-2.10.2.tgz

```console
$ mkdir ~/opt
$ ...
```

### Install Ruby via rvm

- Version 2.0.0p247

#### Create .gemrc (Optional)

If you're PC is in China, you won't be able to access the primary
Ruby-Gem repository. You'll need to use a mirror site in China. Create
`~/.gemrc` file and put the following contents:

```console
---
:sources:
- http://gems.gzruby.org/
gem: --no-rdoc --no-ri
```

#### Install rvm

```console
$ curl -L https://get.rvm.io | bash -s stable
$ source $HOME/.rvm/scripts/rvm
```

If you have rvm already installed, make sure to bring it up to the
latest stable version.

```console
$ source $HOME/.rvm/scripts/rvm
$ rvm get stable
$ rvm reload
```

#### Install Ruby 2.0

```console
$ rvm list known
$ rvm install 2.0.0
$ rvm alias create default 2.0.0
$ rvm list
rvm rubies

=* ruby-2.0.0-p247 [ x86_64 ]

# => - current
# =* - current && default
#  * - default

$ ruby --version
ruby 2.0.0p247 (2013-06-27 revision 41674) [x86_64-linux]
```

Add `source $HOME/.rvm/scripts/rvm` to your shell rc file
(e.g. `.bashrc`)


##### Troubleshooting

If you get the following error while installing Ruby, you need to
manually set the latest version of Ruby Gem.

```console
There was an error while trying to resolve rubygems version for 'latest'
```

Go to http://github.com/rubygems/rubygems/tags and find out the latest
version. Then open `~/.rvm/config/db` with an editor and set the
`ruby_2.0.0_rubygem_version` to the latest version.

```ruby
ruby_2.0.0_rubygems_version=2.0.3
```


### Install MongoDB

- Version 2.4.5
- http://www.mongodb.org/downloads
- http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.5.tgz
- http://docs.mongodb.org/manual/MongoDB-manual.pdf


### Install Cassandra

- Version 1.2.6
- http://cassandra.apache.org/download/
- OR use yum:
  * [DataStax Installing Cassandra](http://www.datastax.com/documentation/gettingstarted/index.html?pagename=docs&version=quick_start&file=quickstart#!_Installing Cassandra)


### Install VoltDB

- Version 3.4
- Download the binary from the download page (with mail news subscription)
- OR clone [VoltDB repository](https://github.com/VoltDB/voltdb) from GitHub
  and build it by yourself. (You'll need `ant`.)


### Install Neo4J

- Version 1.9.2
- http://www.neo4j.org/download_thanks?edition=community&release=1.9.2&platform=unix


### Install Redis (Optional)

- Version 2.6.14
- http://redis.io/download
- http://redis.io/topics/quickstart

Download, extract and compile Redis with:

```console
$ sudo yum search jemalloc
$ wget http://redis.googlecode.com/files/redis-2.6.14.tar.gz
$ tar xzf redis-2.6.14.tar.gz
$ cd redis-2.6.14
$ make distclean
$ make
```

The binaries that are now compiled are available in the src
 directory. Run Redis with:

```console
$ src/redis-server
```

You can interact with Redis using the built-in client:

```console
$ src/redis-cli
redis> set foo bar
OK
redis> get foo
"bar"
```

### Install Infinispan (Optional)

- Version 5.3.0
- http://www.jboss.org/infinispan/downloads.html
- Roadmap: https://community.jboss.org/wiki/InfinispanRoadmap
- https://docs.jboss.org/author/display/ISPN/Infinispan+with+Scala


### Download Movie Lens Dataset

- http://www.grouplens.org/node/73
- There are three data sets with 100K, 1M and 10M rating records, get
  ones you want.

