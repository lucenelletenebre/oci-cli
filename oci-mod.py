print("Start modding files")

from pathlib import Path
import re

# if "site-packages" in this_file_path or "dist-packages" in this_file_path:
#     # If the installation directory starts with oci_cli, we need to find the
#     # last occurrence of oci_cli in the path.
#     python_cli_root_dir = this_file_path[0:this_file_path.rindex("oci_cli")]
# else:
#     python_cli_root_dir = this_file_path[0:this_file_path.index("/src/oci_cli")]
find_string = re.compile("if \"site-packages\" in this_file_path[\w\s\W]+/src/oci_cli\"\)\]")

# string with code to substitute
sub_string = 'python_cli_root_dir = this_file_path[0:this_file_path.rindex("oci_cli")]'

# search for file to be modded
file2mod_list = [i for i in Path('venv').glob('**/dynamic_loader.py')]

# verify there is only 1 file to be modded
assert len(file2mod_list) == 1, f"found {len(file2mod_list)} files called dynamic_loader.py"

#assign name to first element
file2mod = file2mod_list[0]

# read all the file content in data
with open(file2mod, 'r') as fid:
    data = fid.read()
    
# print(data)
new_data, num = find_string.subn(sub_string, data)

# verify there is only 1 occurence
assert num == 1, f"Number of occurence in {file2mod} should be 1: got {num}"
print("Found", num, "occurrences")

with open(file2mod, 'w') as fid:
    fid.write(new_data)
    
print("File modded sucesfully")