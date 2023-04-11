using PkgBenchmark

commit = benchmarkpkg("PartitionedVectors")  #dernier commit sur la branche sur laquelle on se trouve
master = benchmarkpkg("PartitionedVectors", "main") # branche master
judgement = judge(commit, master)

export_markdown("benchmark/judgement.md", judgement)
