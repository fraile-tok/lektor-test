# Packages
using Pkg
Pkg.add("CSV")
Pkg.add("DataFrames")

# Genes Import, DF -> Matrix -> Vector w/missing -> Vector wo/missing
using CSV, DataFrames
df = CSV.read("genes/csvimport-test.csv", DataFrame; header=false)
mdf = Matrix(df)
function slicematrix(A::AbstractMatrix{T}) where T
    m, n = size(A)
    B = Vector{T}[Vector{T}(undef, n) for _ in 1:m]
    for i in 1:m
        B[i] .= A[i, :]
    end
    return B
end
slicedmdf = slicematrix(mdf)
genes = slicedmdf
for gene in genes
    filter!(!ismissing, gene)
end