#!/usr/bin/env python
# -*- coding: utf-8 -*-

from sys import argv
from w3lib.html import remove_tags

def parse_plaintext_format(text):
    data = []

    for row in text:
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
    parts = [int(n) for n in timestamp.split(':')]
    npt = 'npt:'
    if len(parts) == 2:
        npt += '0:%d:%d' % (parts[0], parts[1])
    elif len(parts) == 3:
        npt += '%d:%d:%d' % (parts[0], parts[1], parts[2])
    npt += '.'
    return npt

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
        

with open(argv[1]) as f:
    data = parse_plaintext_format(f.readlines())
    print serialize_to_cmml(data)
