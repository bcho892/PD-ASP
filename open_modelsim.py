import os
from subprocess import call

os.chdir(os.path.abspath("./scripts"))
call(["vsim", "-do", "compile.do"])