using CSV
using DataFrames
using Combinatorics

# Read the CSV file into a DataFrame
df = CSV.read("results/results_twos.csv", DataFrame)

# Get the names of the genes from the DataFrame
genes = names(df)[1:end-2]

# Create a dictionary to store the gene pair counts
pair_counts = Dict()

# Iterate over each row in the DataFrame
for row in eachrow(df)
    # Create a set to store the active genes for the current row
    active_genes = Set{String}()
    
    # Iterate over each gene and check if it is active (non-zero)
    for gene in genes
        if row[gene] != 0
            push!(active_genes, gene)
        end
    end
    
    # Convert the set of active genes to an array
    active_genes_array = collect(active_genes)
    
    # Iterate over each pair of active genes
    for (gene1, gene2) in combinations(active_genes_array, 2)
        # Create the gene pair as a string
        pair = string(gene1, ":", gene2)
        
        # Increment the count for the gene pair in the dictionary
        pair_counts[pair] = get(pair_counts, pair, 0) + 1
    end
end

filtered_pair_counts = Dict()

# Print out pairs with count > 0
for (pair, count) in pair_counts
    if count > 0
        println("$pair: $count instance(s)")
    end
end