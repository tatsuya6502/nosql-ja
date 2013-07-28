# VoltDB

## Compile the Application Catalog

```console
$ voltdb compile $DEMO/voltdb/movie_lens.sql
```

## Start VoltDB

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

...(after few minutes)

Server completed initialization.
```

## Load Movie Lens Dataset

```console
$ csvloader movies --separator '|' --blank null -f $DEMO/data/ml/ml-100k/u.item
$ csvloader users --separator '|' --blank null -f $DEMO/data/ml/ml-100k/u.user
$ perl -pi.bak -e 's/\t/|/g;' $DEMO/data/ml/ml-100k/u.data
$ csvloader ratings --separator '|' --blank null -f $DEMO/data/ml/ml-100k/u.data
```
