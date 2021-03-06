#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
myenv.py

Set my enviroment path on other windows machine.
"""

import os, sys
import Tkinter, tkMessageBox
import win32con

from _winreg import *
from win32api import SendMessage
from optparse import OptionParser
from portable import DRIVE

## Variable
#
prog_name = sys.argv[0]
PATHDIC =  {
    'SYS32':  '%SystemRoot%\\system32',
    'USB':    DRIVE + '\\Dos\\bat',
    'PYTHON': DRIVE + '\\system\\PortablePython\\App',
    'DOXYGEN': DRIVE + '\\Dos\\graphviz\\release\\bin'
    }
PYTHONPATH = DRIVE + '\\Autohotkey\\script'

ONCE_DIALOG = False # for dialog

def ParserSetup():
    """Get options

    """
    usage = 'Usage: ' + prog_name + '[options]'
    parser = OptionParser(usage)
    parser.add_option(
        "-c", "--constraction",
        action = "store_true",
        default = False,
        dest = "constraction",
        help = "Environment Constraction")
    parser.add_option(
        "-d", "--delete",
        action = "store_true",
        default = False,
        dest = "delete",
        help = "Delete my Environment")
    return parser


def get_path(reg, key):
    """Get Environment path.

    Arguments:
    - `reg`: Opened Registry
    - `key`: Registry subkey
    """
    try:
        path = QueryValueEx(reg, key)[0].split(';')
        if path.count(''):
            path.remove('')
        if not __debug__: print key, "\nexist", path
    except WindowsError:
        path = []
        if not __debug__: print key, "\nnot exist"
    return path

def expand_path(path):
    """Expand path like "%TEMP%" => 'T:\'

    Arguments:
    - `path`: path list
    """
    expanded = []
    for p in path:
        expanded.append(os.path.expandvars(p))
    return expanded

def sortsemicolonjoin(path):
    """Sort list and join by ";"

    """
    path.sort()
    joinedpath = ";".join(path)
    return joinedpath

def make_value(olduserpath, newuserpath):
    """Make environment value. and unique list.

    Create value from list. Join with ";".
    ["hello", "world", "hoge"] => "hello;world;hoge"
    Arguments:
    - `olduserpath`:
    - `newuserpath`:
    """
    olduserpath = sortsemicolonjoin(olduserpath)
    newuserpath = list(set(newuserpath))
    newuserpath = sortsemicolonjoin(newuserpath)
    return olduserpath, newuserpath

def envupdate():
    """Update after registry modified.

    """
    SendMessage(
        win32con.HWND_BROADCAST, win32con.WM_SETTINGCHANGE, 0, 'Environment')

def dialog():
    """Yes/No prompt dialog only once.
    """
    global ONCE_DIALOG
    if not ONCE_DIALOG:
        w = Tkinter.Tk()
        w.withdraw()
        if tkMessageBox.askyesno("環境変数の変更", "環境変数を変更しますか？"):
            ONCE_DIALOG = True
        else:
            sys.exit(1)

def env_construction():
    """Environment Construction

    Make my USB Environment "usb dos path" "portable python path"
    """
    # get system 'path'
    reg = OpenKey(
        HKEY_LOCAL_MACHINE, 'SYSTEM\\ControlSet001\\Control\\Session Manager\\Environment',
        0, KEY_ALL_ACCESS)
    allpath = get_path(reg, 'path')
    CloseKey(reg)
    # get user 'PATH'
    reg = OpenKey(HKEY_CURRENT_USER, 'Environment', 0, KEY_ALL_ACCESS)
    olduserpath = get_path(reg, 'PATH')
    # for new user 'PATH'
    newuserpath = []
    newuserpath += olduserpath
    # set all path
    allpath += olduserpath
    allpath = expand_path(allpath)
    for key, value in PATHDIC.items():
        try:
            v = QueryValueEx(reg, key)[0]
            if not v == value:
                dialog()
                DeleteValue(reg, key)
                SetValueEx(reg, key, 0, REG_SZ, value)
        except WindowsError:
            dialog()
            SetValueEx(reg, key, 0, REG_SZ, value)
            if not __debug__: print "Set", key, "=", value
        if not allpath.count(os.path.expandvars(value)):
            expand_key = '%'+key+'%'
            newuserpath.append(expand_key)
            if not __debug__: print '"'+expand_key+'"' + ' will append to "PATH"'
    olduserpath, newuserpath = make_value(olduserpath, newuserpath)
    if olduserpath == newuserpath:
        if not __debug__: print '\nUser "PATH" No need change!!'
        sys.exit(0)
    else:
        dialog()
        try:
            DeleteValue(reg, 'PATH')
        except WindowsError:
            pass
        if not __debug__: print '\nAdd: "PATH"= ', newuserpath
        SetValueEx(reg, 'PATH', 0, REG_EXPAND_SZ, newuserpath)
    CloseKey(reg)

def env_delete():
    """Delete my Environment

    """
    reg = OpenKey(HKEY_CURRENT_USER, 'Environment', 0, KEY_ALL_ACCESS)
    olduserpath = get_path(reg, 'PATH')
    newuserpath = []
    newuserpath += olduserpath
    for key, value in PATHDIC.items():
        try:
            DeleteValue(reg, key)
        except WindowsError:
            if not __debug__: print key, "Aleady not exists."
        expand_key = '%'+key+'%'
        while newuserpath.count(expand_key):
            newuserpath.remove(expand_key)
    if not newuserpath:
        try:
            DeleteValue(reg, 'PATH')
        except WindowsError:
            pass
    else:
        olduserpath, newuserpath = make_value(olduserpath, newuserpath)
        if olduserpath == newuserpath:
            if not __debug__: print '\nUser "PATH" No need change!!'
            sys.exit(0)
        else:
            try:
                DeleteValue(reg, 'PATH')
            except WindowsError:
                pass
            if not __debug__: print '\nAdd: "PATH"= ', newuserpath
            SetValueEx(reg, 'PATH', 0, REG_EXPAND_SZ, newuserpath)
    result = get_path(reg, 'PATH')
    print "Result:", result
    CloseKey(reg)

def main():
    parser = ParserSetup()
    (options, args) = parser.parse_args()
    envupdate()
    if options.constraction: # Create Environment
        env_construction()
    if options.delete: # Delete Environment
        env_delete()
    envupdate()

if __name__ == '__main__':
    main()
