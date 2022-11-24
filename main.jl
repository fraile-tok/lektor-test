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

# get files
files = readdir("articles/")
popfirst!(files)
cd("articles/")

# PER FILE
f = 1
for file in files
    data_raw = open(file, "r")
    data_by_line = readlines(data_raw)
    println("File ", f, ": ", file)
    i = 1
    # PER LINE
    for line in data_by_line
        # cleanup
        line_lc = lowercase(line)
        line_sans_g = replace(line_lc, "-" => "")
        line_sans_d = replace(line_sans_g, "." => "")
        line_clean = line_sans_d
        println("Paragraph ", i, ": ", line,"\n")
        for gene in genes
            count = 0 
            aliases = gene
            for alias in aliases
                alias_sans_dash = replace(alias, "-" => "")
                alias_sans_dot = replace(alias_sans_dash, "." => "")
                alias_clean = lowercase(alias_sans_dot)
                occurs = occursin(alias_clean, line_clean)
                if (occurs == true)
                    count += 1
                end
            end
            if (count >= 1)
                println(gene[1], ": ", count)
            end
        end
        println("\n")
        i += 1
    end
    i = 1
    f += 1
end
f = 0