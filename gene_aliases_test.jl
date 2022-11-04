# genes = [gene1 = ["gene1", "gene-1", ...], gene2 = ["gene2", "gene-2"]]
# In a .csv, import each file as an array, then make an array of those arrays.
cd8 = ["cd8", "cd8A", "cluster of differentiation 8"]
bcl11b = ["bcl11b", "atl1", "ctip2", "rit1"]
genes = [bcl11b, cd8]

pwd()
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
        aliases = gene
        #occurs = false
        for alias in aliases
            alias_sans_dash = replace(alias, "-" => "")
            alias_sans_dot = replace(alias_sans_dash, "." => "")
            alias_clean = alias_sans_dot
            occurs = occursin(alias_clean, line_clean)
            if (occurs == true)
                println(aliases[1], " found")
            end
        end
    end
    println("\n")
    i += 1
end
i = 1

