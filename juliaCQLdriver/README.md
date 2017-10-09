# CQLdriver
This Julia package for interfacing with ScyllaDB / Cassandra is based on the Datastax [CPP driver](http://datastax.github.io/cpp-driver/) implementing the CQL v3 binary protocol. 

Julia performance is on par with C++ and about twice as fast as Python. This package is missing very many features (nearly all of them), but it does two things quite well:

 - write very many rows quickly
 - read very many rows quickly

Now, it's probably easy to extend this package to enable other features, but I haven't taken the time to do so. If you find this useful but are missing a small set of features I can probably implement them if you file an issue.

The way to use this package is:
```
julia> session, cluster, err = cqlinit("127.0.0.1")

julia> table = "data.testtable"
julia> data = [["hello", 1, now()],
               ["lolol", 2, now()]]
julia> colnames = ["msg", "num", "timestamp"]

julia> err = cqlasyncwrite(session, table, colnames, data)

julia> query = "SELECT DISTINCT vals FROM data.test LIMIT 1000000"

julia> err, result = cqlread(session, query)

julia> cqlclose(session, cluster)
```
Functions return `err::Int16` codes which are 0x0000 if things are good, and something else if there's a problem.
