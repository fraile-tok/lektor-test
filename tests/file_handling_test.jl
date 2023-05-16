pwd()
cd("Articles/")
files = readdir()
popfirst!(files)

for file in files
    data_raw = open(file, "r")
    data_by_line = readlines(data_raw)

    
end