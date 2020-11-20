#!/usr/bin/python3

import sys
import os

from datetime import datetime
startTime = datetime.now()
cmd = str(sys.argv[1])
print("Executing Script:" + cmd + "\n")
print("====script starts====\n")
os.system(cmd)
print("\n====script ends====\n")
print("Took " + str(datetime.now() - startTime) + " seconds\n")
os.system("osascript -e 'display notification \"Script Done!\" with title \"ATTN\"'")
os.system('say "script done"')
