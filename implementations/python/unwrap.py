#!/bin/env python3

# This version was ported by Tristan Havelick, 2021
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
# 
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# For more information, please refer to <https://unlicense.org>

import fileinput
import re

def early_indent(line, next_line):
    words = next_line.split(' ')
    return (len(line + ' ' + words[0]) < len(next_line))

result = []
line = ''
previous_line = ''
sentinel = False
for line in fileinput.input():    
    line = line.rstrip()
    if sentinel:
        if (
            line == '' or 
            previous_line == '' or
            re.match(r'^[^A-Za-z0-9]', line) or
            early_indent(previous_line, line)
        ):
            result.extend([previous_line, "\n"])
        else:
            result.extend([previous_line, ' '])
    previous_line = line
    sentinel = True
result.append(line)
print(''.join(result))
