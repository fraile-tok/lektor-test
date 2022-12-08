# Packages
using Pkg
Pkg.add("CSV")
Pkg.add("DataFrames")

using CSV, DataFrames
import Dates

# Genes Import, DF -> Matrix -> Vector w/missing -> Vector wo/missin
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
genelist = slicedmdf

# File Import
filelist = readdir("articles/")
popfirst!(filelist)

# SearchGenes Func Declaration
function searchgenes(files, genes, resultsname) # searchgenes(array of files, array of genes, name for the results file)
    # GO FOR RESULTS
    cd("results/")
    resultsfile = open(resultsname, "a")
    # RESULTS HEADER
    searchdate = string(Dates.now())
    write(resultsfile, "SearchGenes function ran on ", searchdate,"\n")
    # GO FOR FILES
    cd("../articles/")
    # PER FILE
    global f = 1
    for file in files
        data_raw = open(file, "r")
        data_by_line = readlines(data_raw)
        # println("File ", f, ": ")
        write(resultsfile, "\n  File ", string(f), ":")
        global l = 1
       # filter!(!isempty, data_by_line) # simply deletes the line from array, but does not maintain numbering
        # PER LINE
        for line in data_by_line
            # if line is empty then skip
            if (line == "") 
                global l += 2 # the line is skipped but the .txt paragraph numbers maintained
            else
                linescore = 0
                # cleanup
                line_lc = lowercase(line)
                line_sans_g = replace(line_lc, "-" => "")
                line_sans_d = replace(line_sans_g, "." => "")
                line_clean = line_sans_d
                #println("Paragraph ", l, ":\n")
                write(resultsfile, "\n    Paragraph ", string(l), ": ")
                for gene in genes
                    filter!(!ismissing, gene) # deletes missing values from gene arrays (aliases lists)
                    genescore = 0 
                    aliases = gene
                    for alias in aliases
                        alias_sans_dash = replace(alias, "-" => "")
                        alias_sans_dot = replace(alias_sans_dash, "." => "")
                        alias_clean = lowercase(alias_sans_dot)
                        occurs = occursin(alias_clean, line_clean)
                        if (occurs == true)
                            genescore += 1
                            linescore += 1
                        end
                    end
                    if (genescore >= 1)
                        #println(gene[1], ": ", score)
                        write(resultsfile, "\n      ", gene[1], ": ", string(genescore))
                    end
                end
                if (linescore >= 1)
                    write(resultsfile, "")
                else 
                    write(resultsfile, "No genes found.")
                end
                #println("\n")
                global l += 1
            end
        end
        global l = 1
        global f += 1
    end
    global f = 1
    close(resultsfile)
    cd("../")
end

searchgenes(filelist, genelist, "results.txt")