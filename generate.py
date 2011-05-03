#!/usr/bin/env python
# -*- coding: utf-8 -*-

from mako.template import Template
from mako.lookup import TemplateLookup

from config import album, artist, episodes, formats, outdir

from os import path

lookup = TemplateLookup(
    directories=['templates'],
    input_encoding='utf-8',
    output_encoding='utf-8',
    encoding_errors='replace')

for number, episode in episodes.iteritems():
    print "Rendering HTML for episode %s …" % number
    template = lookup.get_template('episode.mako')
    output = template.render(
        album=album,
        artist=artist,
        episode=episode,
        formats=formats,
        tracknumber=number)

    outpath = path.join(outdir, str(number) + '.html')
    print "Writing HTML for episode %s to file %s." % (number, outpath)
    with open(outpath, 'w') as outfile:
        outfile.write(output)
