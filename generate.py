#!/usr/bin/env python
# -*- coding: utf-8 -*-

from mako.template import Template
from mako.lookup import TemplateLookup

from config import album, artist, episodes, formats

lookup = TemplateLookup(
    directories=['templates'],
    input_encoding='utf-8',
    output_encoding='utf-8',
    encoding_errors='replace')

for number, episode in episodes.iteritems():
    template = lookup.get_template('episode.mako')
    print template.render_unicode(
        album=album,
        artist=artist,
        episode=episode,
        formats=formats,
        tracknumber=number)
