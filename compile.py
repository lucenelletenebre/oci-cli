import PyInstaller.__main__
import os.path

#file for compilation
# com_file = 'flask_app.py'
com_file = 'oci'

#Executable Name
exe_name = 'oci.exe'

# create version file bsed on git
# import subprocess
# label = subprocess.check_output(["git", "describe", "--tags", "--always"]).strip()
# label = str(label, 'utf-8')
# print(label)
# with open('VERSION', 'w') as fid:
#     fid.write(label)

run_opt = [
    com_file,
    '--name=' + exe_name, #+ '_' + label,
    # '--onefile',
    # '--noconsole',# this remove the console terminal, use only with Launcher App
    '--noconfirm',# Replace output directory (default: SPECPATH/dist/SPECNAME) without asking for confirmation
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
    '--collect-all=services.core',
    # '--collect-all=services',
]

# support for upx compression
abs_path = '../'#path were to look for upx folders
# list of folders with upx in the name
folders_upx = [x.name for x in os.scandir(abs_path) if x.is_dir() and 'upx' in x.name]
# if you find at least 1 folder with upx
if len(folders_upx) > 0:
    # sort the upx folders in reverse (we will take the one with higher version)
    folders_upx.sort(reverse=True)
    # takes the first insance
    upx = abs_path + folders_upx.pop()
    # add configuration for upx
    run_opt.append('--upx-dir='+upx)
    # exclude the following dll for incompatibility
    run_opt.append('--upx-exclude=vcruntime140.dll')
    run_opt.append('--upx-exclude=ucrtbase.dll')

# compile the exe
PyInstaller.__main__.run(run_opt)

print('-----------------------')
print(*run_opt, sep='\n')
print('-----------------------')

# copy from dist folder to the base folder
# from shutil import copyfile
# src = com_file[:-2] + 'exe'
# copyfile('dist/'+src, src)