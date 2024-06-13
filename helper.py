import os

def list_files_in_directory(directory_path):
    try:
        # Get the list of files in the directory
        files = os.listdir(directory_path)
        # Filter out directories, only keep files
        files = [file for file in files if os.path.isfile(os.path.join(directory_path, file))]
        return files
    except Exception as e:
        print(f"An error occurred: {e}")
        return []

# Specify the directory path
directory_path = 'path/to/your/folder'

# Get the list of files
file_list = list_files_in_directory(directory_path)

# Specify the output file
output_file = 'file_list.txt'

# Save the list of files to a text file
with open(output_file, 'w') as f:
    for file in file_list:
        f.write(file + '\n')

print(f"List of files saved to {output_file}")
