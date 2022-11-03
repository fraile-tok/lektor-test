# libraries
using Pkg
Pkg.add("CSV")

# import genes (txt)
genes_raw = open("genes/genestest2.txt","r")
genes_separated = readlines(genes_raw)
println(genes_separated)
pwd()
cd("Articles/")
# get txt
my_data = open("1.txt", "r")
# divide text into paragraphs
data_by_line = readlines(my_data)

# gene lists
i = 1
for line in data_by_line
    # cleanup
    line_lc = lowercase(line)
    line_sans_g = replace(line_lc, "-" => "")
    line_sans_d = replace(line_sans_g, "." => "")
    line_clean = line_sans_d
    println("Paragraph ", i, " ", line,"\n")
    for gene in genes
        println(gene, " ", occursin(gene, line_clean))
    end
    println("\n")
    i += 1
end
i = 1