#!/usr/bin/python
# -*- coding: utf-8 -*-

from requests import get, head, ConnectionError, Timeout
from werkzeug.contrib.cache import FileSystemCache
from progressbar import Bar, ProgressBar, SimpleProgress
from sys import argv, stderr, stdout
from urllib2 import urlparse

url_status_cache = FileSystemCache('cache_dir', threshold=10000, default_timeout=3600)

def html_line(tokens):
    html = '</ol>\n' + ' '.join(tokens[1:]) + '\n' + '<ol>\n'
    return html

timestamps = []

def link_line(tokens):
    timestamp = tokens[0]

    if timestamp in timestamps:
        stderr.write('Duplicate timestamp: %s\n' % timestamp)
        raise RuntimeError
    timestamps.append(timestamp)

    url_with_brackets = tokens[1]
    try:
        assert(url_with_brackets[0] == '<')
        assert(url_with_brackets[-1] == '>')
    except AssertionError:
        stderr.write('Error at:\n' + ' '.join(tokens) + '\n')
        exit(1)
    url = url_with_brackets[1:-1]
    scheme = urlparse.urlsplit(url).scheme
    host = urlparse.urlsplit(url).netloc

    # TODO: check if it really is a url
    if scheme == 'http' or scheme == 'https':
        if url_status_cache.get(url) is not True:
            try:
                request = head(url, timeout=10)
                # some web site operators cannot into head requests
                if (request.status_code in (403, 405, 500)):
                    request = get(url)
            except Timeout as e:
                stderr.write('Connection to <' + url + '> timeouted.')
                exit(1)
            except ConnectionError as e:
                stderr.write('Connection to <' + url + '> failed.\n')
                stderr.write(str(e) + '\n')
                exit(1)
            if request.ok:
                url_status_cache.set(url, request.ok)
            else:
                stderr.write('<' + url + '> is unreachable.\n')
                exit(1)

    text = ' '.join(tokens[2:])

    html = ' <li id=%s><a class=timecode href=#%s>%s</a>\n' % \
        (timestamp, timestamp, timestamp)
    html += '  <a href="%s">%s</a>\n' % (url, text)
    return html

filename = argv[1]
with open(filename) as linklist:
    lines = [line for line in linklist]

if len(lines) == 0:
    stderr.write('“%s” is empty. Exiting …\n' % filename)
    exit(0)

stdout.write('<ol>\n')

widgets = [Bar(), SimpleProgress()]
pbar = ProgressBar(widgets=widgets, maxval=len(lines)).start()

for i, line in enumerate(lines):
    tokens = line.split()
    if tokens[0] == 'HTML':
        html = html_line(tokens)
        stdout.write(html)
    else:
        html = link_line(tokens)
        stdout.write(html)
    pbar.update(i+1)
stdout.write('</ol>\n')
pbar.finish()
