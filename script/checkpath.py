#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
checkpath.py


"""

from _winreg import *
from win32api import SendMessage
import win32con

SendMessage(
        win32con.HWND_BROADCAST, win32con.WM_SETTINGCHANGE, 0, 'Environment')

reg = OpenKey(HKEY_CURRENT_USER, 'Environment', 0, KEY_ALL_ACCESS)

try:
    QueryValueEx(reg, "PATH")
    print "PATH exist"
except:
    print "PATH not exist"


try:
    tu = QueryValueEx(reg, "TMP")
    print "TMP exist"
    print tu[0]

except:
    print "TMP not exist"



