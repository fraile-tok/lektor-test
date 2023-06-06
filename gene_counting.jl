using CSV
using DataFrames

# Read the CSV file into a DataFrame
df = CSV.read("results/results_twos.csv", DataFrame)

# Get the names of the genes from the DataFrame
genes = names(df)[2:end]

# Create a dictionary to store the gene pair counts
pair_counts = Dict()

# Iterate over each row in the DataFrame
for row in eachrow(df)
    # Iterate over each pair of genes
    for i in 1:length(genes)-1
        for j in i+1:length(genes)
            # Create the gene pair as a string
            pair = string(genes[i], "-", genes[j])
            
            # Increment the count for the gene pair in the dictionary
            pair_counts[pair] = get(pair_counts, pair, 0) + (row[genes[i]] == 1 && row[genes[j]] == 1)
        end
    end
end

# Print the gene pair counts
for (pair, count) in pair_counts
    println("$pair: $count instance(s)")
end