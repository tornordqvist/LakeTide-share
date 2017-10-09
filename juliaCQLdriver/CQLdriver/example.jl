push!(LOAD_PATH, ".")

using CQLdriver
const CQL_OK = 0

# ++++
# CONNECT TO THE CLUSTER
session, cluster, err = cqlinit("192.168.1.115, 192.168.1.149")

rows = 100_000
a = now()
cols = ["imsi", "ts", "id", "pl", "t1id", "t1rnc", "t2id", "t2rnc", "t3id", "t3rnc", "t4id", "t4rnc"]
table = "test.benchmarks"
data = Array{Any, 1}(rows)
for i in 1:rows
    data[i] = [string(i), a, Int32(1), Int32(2), Int32(3),
    Int32(4), Int32(5), Int32(6), Int32(7), Int32(8), Int32(9), Int32(10)]
end

# ++++
# WRITE 1000 (DEFAULT) ROWS AT A TIME
# RETURNS ARRAY OF UInt16 ERROR MESSAGES FOR EACH 1000 ROWS - 0 is CQL_OK

err = cqlasyncwrite(session, table, cols, data)
@assert union(err) == [CQL_OK]

# ++++
# READ 100_000 ROWS FROM A TABLE
# QUERIES ASSUME STRINGS ARE MAX 128 CHARS (DEFAULT)
# QUERIES PULL 10000 ROWS PER PAGE (DEFAULT)
# RETURNS AN ARRAY OF ARRAYS

query = "SELECT DISTINCT imsi FROM test.benchmarks LIMIT 100000"
err, result = cqlread(session, query)
@assert err == CQL_OK

# ++++
# REMEMBER TO RELEASE RESOURCES
cqlclose(session, cluster)
