# Packages
using Pkg
Pkg.add("CSV")
Pkg.add("DataFrames")

using CSV, DataFrames
import Dates

# Genes Import, DF -> Matrix -> Vector w/missing -> Vector wo/missin
df = CSV.read("genes/full_gene_list.csv", DataFrame; header=false)
mdf = Matrix(df)
function slicematrix(A::AbstractMatrix{T}) where T # TURNS MATRIX INTO ARRAY
    m, n = size(A)
    B = Vector{T}[Vector{T}(undef, n) for _ in 1:m]
    for i in 1:m
        B[i] .= A[i, :]
    end
    return B
end

# Genelist Prep
slicedmdf = slicematrix(mdf)
genelist = slicedmdf

# File Import
filelist = readdir("articles/")
popfirst!(filelist)

# CSV Exporting
results_template = CSV.read("results/results_template.csv", DataFrame; header=true)

# SearchGenes Func Declaration
function searchgenes(files, genes, resultsname) # searchgenes(array of files, array of genes, name for the results file)
    # GO FOR RESULTS
    cd("results/")
    resultsfile = open(resultsname, "a")
    # RESULTS HEADER
    searchdate = string(Dates.now())
    write(resultsfile, "\n SearchGenes function ran on ", searchdate,"\n")
    # GO FOR FILES
    cd("../articles/")
    # PER FILE
    global f = 1
    global run_data = [] # run results array
    for file in files
        data_raw = open(file, "r")
        data_by_line = readlines(data_raw)
        # println("File ", f, ": ")
        write(resultsfile, "\n  File ", string(f), ":")
        global l = 1
        # PER LINE
        for line in data_by_line #for line begins
            global para_results = [] # generates array to keep paragraph results
            global genes_in_line = 0
            # if line is empty then skip
            if (line == "") 
                global l += 2 # the line is skipped but the .txt paragraph numbers maintained
            else
                linescore = 0
                # cleanup
                line_lc = lowercase(line)
                line_sp1 = replace(line_lc, "(" => "")
                line_sp = replace(line_sp1, ")" => "")
                line_sans_g = replace(line_sp, "-" => "")
                line_sans_d = replace(line_sans_g, "." => "")
                line_clean = line_sans_d
                #println("Paragraph ", l, ":\n")
                write(resultsfile, "\n    Paragraph ", string(l), ": ")
                # PER GENE
                for gene in genes #for gene begins
                    filter!(!ismissing, gene) # deletes missing values from gene arrays (aliases lists)
                    genescore = 0 
                    aliases = gene
                    # PER ALIAS
                    for alias in aliases #for alias begins
                        alias_sans_dash = replace(alias, "-" => "")
                        alias_sans_dot = replace(alias_sans_dash, "." => "")
                        alias_clean = lowercase(alias_sans_dot)
                        occurs = occursin(alias_clean, line_clean)
                        if (occurs == true)
                            genescore += 1
                            linescore += 1
                        end
                    end #for alias ends
                    if (genescore >= 1)
                        #println(gene[1], ": ", score)
                        write(resultsfile, "\n      ", gene[1], ": ", string(genescore))
                        genes_in_line += 1
                    end
                    push!(para_results,genescore)
                end
                push!(para_results, linescore)
                push!(para_results, genes_in_line)
                if (genes_in_line == 2)
                    write(resultsfile, "")
                    push!(results_template,para_results)
                else 
                    write(resultsfile, "No genes found.")
                end #for gene ends
                #println("\n")
                global l += 1
            end
        end #for line ends
        cd("../results/")
        CSV.write("results.csv", results_template)
        global l = 1
        global f += 1
        #articledf = matrixtodf(article_data)
        #println(articledf) # matrix is here to be used when needed

    end
    global f = 1
    close(resultsfile)
    cd("../")
end

searchgenes(filelist, genelist, "csv_results_testing.txt")

# lo correcto es que los artículos es analizar las matrices de una vez, en el mismo script