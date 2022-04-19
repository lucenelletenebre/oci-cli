import PyInstaller.__main__

com_file = "oci"

# Executable Name
exe_name = "oci.exe"

run_opt = [
    com_file,
    "--name=" + exe_name,  # + '_' + label,
    # '--onefile',
    # '--noconsole',# this remove the console terminal, use only with Launcher App
    "--noconfirm",  # Replace output directory (default: SPECPATH/dist/SPECNAME) without asking for confirmation
    # '--icon=html/icona.ico',
    # it is important to include this file for cloudscraper (not automticaly included)
    # '--add-data=venv/Lib/site-packages/cloudscraper/user_agent/browsers.json;cloudscraper/user_agent',
    # pack also html files
    # '--add-data=html/*;html/.',
    # pack also template files
    # '--add-data=templates/*;templates/.',
    # add version file, based on git
    # '--add-data=VERSION;.',
    # '--paths=venv/lib/python3.10/site-packages/',
    # '--collect-all=oci_cli',
    # '--collect-all=cryptography',
    # '--collect-all=oci',
    # '--hidden-import=oci',
    # '--runtime-tmpdir=/tmp',
    "--collect-all=services.core",
    # '--collect-all=services',
]

# compile the exe
PyInstaller.__main__.run(run_opt)

print("-----------------------")
print(*run_opt, sep="\n")
print("-----------------------")
