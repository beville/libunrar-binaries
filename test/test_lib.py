#!/usr/bin/python3

import platform
import os
import zipfile
import shutil

def testRarLibrary():
    from unrar import rarfile
    rar = rarfile.RarFile('sample.rar')
    print("File list:")
    print("  ", rar.comment.decode('utf-8'))
    print("  ",rar.namelist())
    if rar.namelist():
        firstname = rar.namelist()[0]
        print("Contents of ", firstname)    
        print("  ", rar.read(firstname))

def main():
    if os.path.exists('unrar'):
        shutil.rmtree('unrar')
    
    # Calculate package name
    machine = platform.machine()
    if platform.system() == "Darwin":
        osname = "macos"
    elif platform.system() == "Linux":
        osname = "linux"
    else:
        print("Unknown system type!")
        return

    version_filename = "../version.txt"
    try:
        with open(version_filename, 'r') as vfile:
            version = vfile.read().strip()
    except:
        print("Can't read version file!")
        return
    
    package_name = "../packages/libunrar-{}_{}_{}.zip".format(version, osname, machine)
    if not os.path.exists(package_name):
        print("Package doesn't exist for this platform: {}".format(package_name))
        return
    
    # Extract libunrar from package
    package = zipfile.ZipFile(package_name, mode='r')

    package.extract('libunrar.so')

    # Set up environment for rarfile python package
    os.environ['UNRAR_LIB_PATH'] = './libunrar.so'
    
    # Now ready to verify that the package works
    try:
        testRarLibrary()
    except Exception as e:
        print("Test failed! {}".format(e))

#----------------------------------------------------          
if __name__ == '__main__':
    main()    
