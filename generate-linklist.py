#!/usr/bin/python
# irgendwas mit UTF-8

from requests import get, head, ConnectionError, Timeout
from sys import argv, stderr, stdout
from urllib2 import urlparse

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
        try:
            request = head(url, timeout=10)
            # some web site operators cannot into head requests
            if (request.status_code == 405) or \
               (request.status_code == 500):
                request = get(url)
        except Timeout as e:
            stderr.write('\nConnection to <' + url + '> timeouted.')
        except ConnectionError as e:
            stderr.write(str(e) + '\n')
            exit(1)
        if request.ok:
            stderr.write('.')
        else:
            stderr.write('\n<' + url + '> is unreachable.\n')
            exit(1)

    text = ' '.join(tokens[2:])

    html = ' <li id=%s><a class=timecode href=#%s>%s</a>\n' % \
        (timestamp, timestamp, timestamp)
    html += '  <a href="%s">%s</a>\n' % (url, text)
    return html

with open(argv[1]) as linklist:
    stdout.write('<ol>\n')
    for line in linklist:
        tokens = line.split()
        if tokens[0] == 'HTML':
            html = html_line(tokens)
            stdout.write(html)
        else:
            html = link_line(tokens)
            stdout.write(html)
    stdout.write('</ol>\n')
    stderr.write('\n')
