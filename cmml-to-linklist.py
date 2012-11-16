#!/usr/bin/env python
# -*- coding: utf-8 -*-

from sys import argv, stdin, stdout
from xml.etree.ElementTree import ElementTree, XML

def _npt_to_timestamp(npt):
    nptparts = npt.split(':')
    hours = int(nptparts[1])
    minutes = int(nptparts[2])
    secparts = nptparts[3].split('.')
    seconds = int(secparts[0])
    try:
        fracseconds = int(secparts[1])
    except ValueError:  # empty string
        fracseconds = 0
    if hours == 0:
        if fracseconds == 0:
            return "%d:%02d" % (minutes, seconds)
        else:
            return "%d:%02d.%d" % (minutes, seconds, fracseconds)
    else:
        if fracseconds == 0:
            return "%d:%02d:%02d" % (hours, minutes, seconds)
        else:
            return "%d:%02d:%02d.%d" % (hours, minutes, seconds, fracseconds)

def serialize_to_plaintext_format(data):
    text = ''
    for row in data:
        text += "%s %s\n" % (row['timestamp'], row['text'])
    return text

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

data = parse_cmml(stdin.read())
stdout.write(serialize_to_plaintext_format(data))
