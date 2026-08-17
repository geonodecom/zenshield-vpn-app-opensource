"""
=== Fuck fastforge! ===
Fastforge deletes the build artifacts directory after packaging the installer
This script should be defined in Inno Compiler as a sign tool
It proxies calls to signtool as is and backs up the build folder, so fastforge can not delete it
=== Fuck fastforge! ===
"""

import os
import sys
import shutil
import subprocess

args = sys.argv[1:]
result = subprocess.run(["signtool"] + args)
if result.returncode != 0:
  sys.exit(result.returncode)
folder = str(os.path.dirname(args[-1]))
if not folder.endswith("\\installer"):
  backup_folder = folder + "-backup"
  shutil.rmtree(backup_folder, ignore_errors=True)
  shutil.copytree(folder, backup_folder)
  print("Build folder backed up to:", backup_folder)
