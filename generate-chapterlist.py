#!/usr/bin/env python
# -*- coding: utf-8 -*-

from linklist import parse_linklist, serialize_html_table
from sys import stdin, stdout

data = parse_linklist(stdin.read())
data = filter(lambda e: e['url'] == '', data)
stdout.write(serialize_html_table(data))
