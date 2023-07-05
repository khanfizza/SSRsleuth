# Set the filenames for the input files
file1 = input ("Enter the name of PERF output file (text file) : " )
file2 = input ("Enter the name of SSRMMD output file(.fa.stat file) : " )
file3 = input ("Enter the name of IMEX output file (summary.txt file) : " )

# Set the desired column indexes for each file
column_index_file1 =7  # Adjust as needed
column_index_file2 =0 # Adjust as needed
column_index_file3 =0  # Adjust as needed

# Set the filename for the output file
output_file = 'common_data.txt'

# Initialize sets to store data from each file
data1 = set()
data2 = set()
data3 = set()

# Read the first file and store the data from the desired column in a set
with open(file1, 'r') as file1_fh:
    for line in file1_fh:
        columns = line.strip().split('\t')  # Assuming tab-separated columns
        if column_index_file1 < len(columns):
            data1.add(columns[column_index_file1])

# Read the second file and compare the data with the first set
with open(file2, 'r') as file2_fh:
    for line in file2_fh:
        columns = line.strip().split('\t')  # Assuming comma-separated columns
        if column_index_file2 < len(columns) and columns[column_index_file2] in data1:
            data2.add(columns[column_index_file2])

# Read the third file and compare the data with the first and second sets
with open(file3, 'r') as file3_fh:
    for line in file3_fh:
        columns = line.strip().split('\t')  # Assuming tab-separated columns
        if column_index_file3 < len(columns) and columns[column_index_file3] in data1 and columns[column_index_file3] in data2:
            data3.add(columns[column_index_file3])

# Write the common data to the output file
with open(output_file, 'w') as output_fh:
    for item in data3:
        output_fh.write(f'{item}\n')

print(f"Common data has been extracted and saved to {output_file}.")
