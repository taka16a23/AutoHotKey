#!/usr/bin/env python
#
"""\
Name: portable_env.py
$Revision$

"""


__revision__ = "$Revision$"
__version__ = "0.1.0"

# for debug
import cgitb
cgitb.enable(format='text')

import os
import winutiles as _win

from portable import DRIVE_DIR

tes = {'PUTTY': 'Internet\\putty',
       'PYTHON': 'system\\PortablePython\\App',
       'PYTHONPATH': 'Lib\\.pylib',
       'PYTHONPATH': 'Office\\emacs\\.emacs.d\\data_e\\pylib',
       'USB': 'Dos\\bat'
       }


def _main():
    for name, path in tes.iteritems():
        print(name)
        print(path)
        # no exists name
        if not name in os.environ:
            _win.env.set_env(name, os.path.join(DRIVE_DIR, path))
        # exists env and already have same path
        elif os.path.join(DRIVE_DIR, path) in os.environ[name]:
            continue
        # exists env and similer path
        elif path in _win.env.get_env(name):
            _win.env.chg_drive(DRIVE_DIR, name, path)
        # no exists value on name
        else:
            env = os.environ[name] + ';' + os.path.join(DRIVE_DIR, path)
            _win.env.set_env(name, env)

if __name__ == '__main__':
    _main()


# For Emacs
# Local Variables:
# coding: utf-8
# End:
# portable_env.py ends here
