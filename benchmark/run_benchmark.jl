using PkgBenchmark

commit = benchmarkpkg("Partitionedvectors")  #dernier commit sur la branche sur laquelle on se trouve
master = benchmarkpkg("Partitionedvectors", "master") # branche master
judgement = judge(commit, master)

export_markdown("benchmark/judgement.md", judgement)
