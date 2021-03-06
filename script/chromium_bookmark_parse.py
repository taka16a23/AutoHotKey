#!/usr/bin/env python
# -*- coding: utf-8 -*-
""" chromium_bookmark_parse -- Parse chromium browser bookmark.

$Revision$

"""


__revision__ = '$Revision$'
__version__ = '0.1.0'

# for debug
# import cgitb as _cgitb
# _cgitb.enable(format='text')
# import pdb
import re as _re
import os as _os
import argparse as _argparse
from subprocess import Popen as _Popen
from time import sleep as _sleep

class ChromeData(object):
    """Chrome Data holder.

    _bookmark_base_path: sub path of Bookmarks.
    _bookmark_path: absolute path of Bookmarks.
    """
    if 'posix' == _os.name:
        _bookmark_base_path = '~/.config/chromium/Default/Bookmarks'
        _bookmark_path = _os.path.expanduser(_bookmark_base_path)

    elif 'nt' == _os.name:
        _bookmark_base_path = (
    'Local Settings/Application Data/Google/Chrome/User Data/Default/Bookmarks')
        _bookmark_path = _os.path.join(_os.environ['userprofile'],
                                       _bookmark_base_path)


class ChromeBookmarkTrim(ChromeData):
    """Triming Chrome Bookmarks."""

    def __init__(self, bookmark_path=None):
        """
        """
        if bookmark_path:
            self._bookmark_path = bookmark_path
        self._file = open(self._bookmark_path, 'r')
        self._lines = self._file.readlines()
        self.line_num = 0
        self.urls = []

    def get_urls(self, name):
        """Get list urls in folder.

        @Arguments:

        - `name`: folders name

        @Return: list of urls.
        """
        self._line_num_by_name(name)
        self._mv_init_line()
        self._parse_urls()
        self._trim_urls()
        return self.urls

    def _line_num_by_name(self, name):
        """Determine line number of name.

        @Arguments:

        - `name`: elements name

        @Return: line number
        """
        self._file.seek(0)
        for num, line in enumerate(self._file, 1):
            if '"name":' in line:
                trimed = line.split('"name":')[1].split('"')[1]
                if name == trimed.decode('unicode-escape', 'ignore'):
                    self.line_num = num - 1

    def _mv_init_line(self):
        """Move initialize line.

        @Return: Nothing
        """
        while -1 == self._lines[self.line_num].find(']') and self.line_num != 0:
            self.line_num -= 1

    def _parse_urls(self):
        """Parse urls"""
        operand = -1
        while operand < 0:
            self.line_num -= 1
            if self._lines[self.line_num].find('}') != -1:
                operand -= 1
            if self._lines[self.line_num].find('{') != -1:
                operand += 1
            if operand == -1:
                if self._lines[self.line_num].find('"url":') != -1:
                    self.urls.append(self._lines[self.line_num])

    def _trim_urls(self):
        """Triming urls by regexp."""
        self.urls = trim_urls(self.urls)

    def __del__(self):
        """Close opened file when deconstract."""
        self._file.close()

def trim_urls(urls):
    """Triming urls by regexp.

    @Arguments:
    - `urls`: list of urls

    @Return: list of trimed urls
    """
    pattern = "(http|https)://[A-Za-z0-9.?.$,;:&=!*~@_()\\-\\#%+/]+"
    re_url = _re.compile(pattern)
    new = []
    for url in urls:
        result = re_url.search(url)
        if not result is None:
            new.append(result.group())
    return new

def run(urls, wait=0.5):
    """Open url by Chrome browser."""
    if 'posix' == _os.name:
        chrome_path = "/usr/bin/chromium-browser"
    elif 'nt' == _os.name:
        chrome_path = (
            'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe')
    chrome_options = '--disk-cache-dir="T:\\chrome"'
    count = 0
    for url in urls:
        _Popen([chrome_path, chrome_options, url])
        if count == 0:
            _sleep(wait + 1.5)
            count += 1
        _sleep(wait)

def _main():
    """Main Functions."""
    parser = _argparse.ArgumentParser(description="""\
    parse chromium bookmark.""")
    parser.add_argument('--version',
                        dest='version',
                        action='version',
                        version=__version__,
                        help='Version Strings.')

    parser.add_argument('name',
                        action='store',
                        type=str,
                        help='Open all bookmarks in folder.')

    parser.add_argument('-r', '--run',
                        dest='run',
                        action='store_true',
                        default=False,
                        required=False,
                        # type=int,
                        # (yas/expand-link "argparse_other_options")
                        help='Open urls Chrome browser.')

    parser.add_argument('--wait',
                        dest='wait',
                        nargs='argparse.ZERO_OR_MORE',
                        action='store',
                        default=0.5,
                        required=False,
                        type=float,
                        help='Wait time for each open urls.')

# (yas/expand-link "argparse_add_argument")
    args = parser.parse_args()
    chrome = ChromeBookmarkTrim()
    urls = chrome.get_urls(args.name.decode('sjis'))
    if args.run:
        run(urls, args.wait)


if __name__ == '__main__':
    _main()





# For Emacs
# Local Variables:
# coding: utf-8
# End:
# chromium_bookmark_parse.py ends here
