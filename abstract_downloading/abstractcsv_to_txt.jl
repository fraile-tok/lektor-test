using Pkg
Pkg.add("CSV")
Pkg.add("DataFrames")

using CSV, DataFrames

abstracts = CSV.read("abstracts.csv", DataFrame; header=true)