#!/usr/bin/env python
# -*- coding: utf-8 -*-

from codecs import getwriter
from linklist import parse_linklist, serialize_webvtt
from sys import argv, stdin, stdout
stdout = getwriter('utf-8')(stdout)

data = parse_linklist(stdin.read(), remove_tags=True)
data = filter(lambda e: e['url'] == '', data)
last_chapter_end = argv[1]
stdout.write(serialize_webvtt(data, last_chapter_end))
