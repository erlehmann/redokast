#!/usr/bin/env python
# -*- coding: utf-8 -*-

from linklist import parse_linklist

from progressbar import Bar, ProgressBar, SimpleProgress
from requests import get, head, ConnectionError, Timeout
from sys import stdin, stderr
from werkzeug.contrib.cache import FileSystemCache
from urllib2 import urlparse

url_status_cache = FileSystemCache('.cache_dir', \
    threshold=10000, default_timeout=3600)

def validate_links(data):
    widgets = [Bar(), SimpleProgress()]
    pbar = ProgressBar(widgets=widgets, maxval=len(data)).start()
    for i, element in enumerate(data):
        url = element['url']
        if url == '':
            continue
        scheme = urlparse.urlsplit(url).scheme
        host = urlparse.urlsplit(url).netloc
        if scheme in ('http', 'https') and \
            url_status_cache.get(url) is not True:
            try:
                request = head(url, timeout=10)
                # some web sites cannot into head requests
                if request.status_code in (403, 405, 500) or \
                    host in ('mobil.morgenpost.de'):
                    request = get(url)
            except Timeout as e:
                stderr.write('Connection to <%s> timeouted.\n' % url)
                exit(1)
            except ConnectionError as e:
                stderr.write('Connection to <%s> failed.\n' % url)
                stderr.write(str(e) + '\n')
                exit(1)
            if request.ok:
                url_status_cache.set(url, request.ok)
            else:
                stderr.write('<%s> is unreachable.\n' % url)
                exit(1)
        pbar.update(i+1)

data = parse_linklist(stdin.read())
validate_links(data)
