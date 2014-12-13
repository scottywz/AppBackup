#!/usr/bin/env python

# AppBackup
# An iOS application that backs up and restores the saved data and
# preferences of App Store apps.
#
# Copyright (C) 2008-2014 Scott Zeid
# https://s.zeid.me/projects/appbackup/
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 
# Except as contained in this notice, the name(s) of the above copyright holders
# shall not be used in advertising or otherwise to promote the sale, use or
# other dealings in this Software without prior written authorization.

# Converts all INI files in one directory to LANGUAGE.lproj/Localizable.strings
# files in another directory.  (Note:  The INI parsing is real shitty.)

import os
import sys
import traceback

if len(sys.argv) != 3:
 "Usage: %s in-directory out-directory" % os.path.basename(sys.argv[0])
 sys.exit(2)

in_dir = os.path.abspath(sys.argv[1])
out_dir = os.path.abspath(sys.argv[2])

langs = [i.rsplit(".ini", 1)[0] for i in sorted(os.listdir(in_dir))
         if i.endswith(".ini") and
            os.path.isfile(os.path.join(in_dir, i))]

for i in langs:
 print "Converting %s.ini..." % i
 with open(os.path.join(in_dir, i + ".ini"), "rb") as f:
  t = unicode(f.read(), "utf8").splitlines()
 if "%s" in t:
  print "warning: %s contains one or more occurrences of %%s" % i
 y = dict([[z.strip() for z in n.split("=", 1)] for n in t if "=" in n])
 o = ["/* Do not edit this file directly.  It is automatically generated at"
      " build", "   time. */", ""]
 keys = sorted(y.keys())
 for k in keys:
  if k.strip() and y[k].strip():
   o += ['"%s" = "%s";' % (k.replace('"', '\"'), y[k].replace('"', '\"'))]
 if not os.path.isdir(os.path.join(out_dir, i+".lproj")):
  os.makedirs(os.path.join(out_dir, i+".lproj"))
 with open(os.path.join(out_dir, i+".lproj", "Localizable.strings"), "wb") as f:
  f.write("\n".join(o).encode("utf8"))
