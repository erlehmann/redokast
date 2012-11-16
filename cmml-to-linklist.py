#!/usr/bin/env python
# -*- coding: utf-8 -*-

from sys import argv
from xml.etree.ElementTree import ElementTree, XML

def _npt_to_timestamp(npt):
    nptparts = npt.split(':')
    hours = int(nptparts[1])
    minutes = int(nptparts[2])
    seconds = int(nptparts[3])
    if hours == 0:
        return "%d:%02d" % (minutes, seconds)
    else:
        return "%d:%02d:%02d" % (hours, minutes, seconds)

def serialize_to_plaintext_format(data):
    textparts = []
    for row in data:
        textparts.append('%s %s' % (row['timestamp'], row['text']))
    return '\n'.join(textparts)

def parse_cmml(cmml):
    data = []

    root = XML(cmml)
    for clip in root.findall('clip'):
        timestamp = _npt_to_timestamp(clip.attrib['start'])
        url = ''  # TODO: this
        text = clip.attrib['title']
        data.append(
            {
                'timestamp': timestamp,
                'url': url,
                'text': text
            }
        )
    return data

with open(argv[1]) as f:
    data = parse_cmml(f.read())
    print serialize_to_plaintext_format(data)
