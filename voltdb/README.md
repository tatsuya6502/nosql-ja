# VoltDB

## Prerequisites

- VoltDB Community Edition (v3.4) should be installed.


## Preparation

### Download Movie Lens Dataset

See the [general README](../README.md).


### Compile the Application Catalog

```console
$ voltdb compile $DEMO/voltdb/movie_lens.sql
```

### Start VoltDB

Ensure you'll use Oracle JDK 7.

```console
java -version
```

By some reason, VoltDB takes **exact** 10 minutes to start up in my
environment. (**TODO** Ask a question about this at the VoltDB user
forum.)

```console
$ voltdb create catalog movie_lens.jar

Initializing VoltDB...

 _    __      ____  ____  ____
| |  / /___  / / /_/ __ \/ __ )
| | / / __ \/ / __/ / / / __  |
| |/ / /_/ / / /_/ /_/ / /_/ /
|___/\____/_/\__/_____/_____/

--------------------------------

Build: 3.4 voltdb-3.4-0-g87c6e44 Community Edition
Connecting to VoltDB cluster as the leader...
Host id of this node is: 0

...(after 10 minutes)

Server completed initialization.
```

### Load Movie Lens Dataset via `csvloader`

```console
$ csvloader movies --separator '|' --blank null -f $DEMO/data/ml/ml-100k/u.item
$ csvloader users --separator '|' --blank null -f $DEMO/data/ml/ml-100k/u.user

$ perl -pi.bak -e 's/\t/|/g;' $DEMO/data/ml/ml-100k/u.data
$ csvloader ratings --separator '|' --blank null -f $DEMO/data/ml/ml-100k/u.data
```


## Demo

See the [MongoDB Demo README](../mongodb-ruby/README.md)
