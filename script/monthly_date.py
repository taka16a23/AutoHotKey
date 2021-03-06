#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""\
Name: monthly_date.py
$Revision$

"""


__revision__ = "$Revision$"
__version__ = "0.1.0"

# for debug
import argparse
import types
import cgitb
cgitb.enable(format='text')

import datetime
import os


def touch(fname):
    """Make non byte file like unix touch command.

    Arguments:
    - `fname`:
    - `times`:
    """
    open(fname, 'w').close()

def read_num(fname):
    """SUMMARY

    @Arguments:
    - `fname`:

    @Return:
    """
    with open(fname, 'r') as f:
        return f.read()

def write_num(fname, num):
    """SUMMARY

    @Arguments:
    - `fname`:
    - `num`:

    @Return:
    """
    with open(fname, 'w') as f:
        f.write(str(num))

def make_flag(fname, fflag, num):
    """SUMMARY

    Arguments:
    - `fname`:
    - `num`:
    """
    assert types.IntType == type(num)

    # Remove flag file
    flist = [fflag, fflag + '4']
    while flist:
        try:
            os.remove(flist.pop())
        except WindowsError:
            pass

    if not os.path.exists(fname):
        write_num(fname, num)

    if not int(read_num(fname)) == num:
        # for Quarter
        if num in [4, 8, 12]:
            fflag += '4'
        touch(fflag)
        write_num(fname, num)

def _main():
    """Main function."""
    parser = argparse.ArgumentParser(description="""for monthly script""")
    parser.add_argument('--version',
                        dest='version',
                        action='version',
                        version=__version__,
                        help='Version Strings.')

    parser.add_argument('-d','--debug',
                        dest='debug',
                        nargs='+',
                        action='store',
                        default=None,
                        required=False,
                        type=int,
                        help='input month num 1~12')

    # (yas/expand-link "argparse_add_argument" t)
    args = parser.parse_args()

    # make flag path
    fname = os.path.join(os.getcwd(), 'date')
    fflag = os.path.join(os.getcwd(), 'flag')

    date = datetime.date.today()
    month_num = date.month

    # Debug overwrite month_num
    if args.debug:
        month_num = args.debug[0]

    make_flag(fname, fflag, month_num)

if __name__ == '__main__':
    _main()


# For Emacs
# Local Variables:
# coding: utf-8
# End:
# monthly_date.py ends here
