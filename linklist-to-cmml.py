#!/usr/bin/env python
# -*- coding: utf-8 -*-

from sys import argv, stdin, stdout
from w3lib.html import remove_tags

def parse_plaintext_format(text):
    data = []

    for row in text.split('\n'):
        rowparts = row.strip().split(' ')
        if len(rowparts) < 2:
            break
        timestamp = rowparts[0]
        if rowparts[1].startswith('<') and rowparts[1].endswith('>'):
            url = rowparts[1][1:-1]
            textparts = rowparts[2:]
        else:
            url = ''
            textparts = rowparts[1:]
        text = remove_tags(' '.join(textparts))
        data.append(
            {
                'timestamp': timestamp,
                'url': url,
                'text': text
            }
        )
    return data

def _timestamp_to_npt(timestamp):
    parts = timestamp.split(':')
    try:
        hours = int(parts[-3])
    except IndexError:
        hours = 0
    minutes = int(parts[-2])
    secparts = parts[-1].split('.')
    seconds = int(secparts[0])
    try:
        fracseconds = int(secparts[1])
    except IndexError:
        fracseconds = 0
    except ValueError:
        fracseconds = 0
    if hours == 0:
        if secparts == 0:
            return "npt:0:%d:%d" % (minutes, seconds)
        else:
            return "npt:0:%d:%d.%d" % (minutes, seconds, fracseconds)
    else:
        if secparts == 0:
            return "npt:%d:%d:%d" % (hours, minutes, seconds)
        else:
            return "npt:%d:%d:%d.%d" % (hours, minutes, seconds, fracseconds)

def serialize_to_cmml(data):
    xml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
    xml += '<!DOCTYPE cmml SYSTEM "cmml.dtd">\n'
    xml += '<cmml>\n'
    xml += '<head></head>\n'
    for entry in data:
        if entry['url'] == '':
            xml += '<clip title="%s" start="%s"></clip>\n' % (
                entry['text'],
                _timestamp_to_npt(entry['timestamp'])
            )
    xml += '</cmml>\n'
    return xml

data = parse_plaintext_format(stdin.read())
stdout.write(serialize_to_cmml(data))
