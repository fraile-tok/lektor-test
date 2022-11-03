# libraries
using Pkg
Pkg.add("CSV")

# import genes (txt)
genes_raw = open("genes/genestest2.txt","r")
genes = readlines(genes_raw)

# get files
cd("articles/")
files = readdir()
popfirst!(files)

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
        #println("Paragraph ", i, ": ", line,"\n")
        println("Paragraph ", i, ": ", "\n")
        # PER GENE
        for gene in genes
            gene_sans_dash = replace(gene, "-" => "")
            gene_sans_dot = replace(gene_sans_dash, "." => "")
            gene_clean = gene_sans_dot
            occurs = occursin(gene_clean, line_clean)
            if (occurs == true)
                println(gene, " found")
            end
            #println(gene, " ", occursin(gene, line_clean))
        end
        println("\n")
        i += 1
    end
    i = 1
    f += 1
end