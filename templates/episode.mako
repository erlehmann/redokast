<%inherit file="base.mako"/>\
\
<%block name="title">\
${album} — Folge ${tracknumber}\
</%block>\

<article>
    <hgroup>
        <h1>${self.title()}</h1>
        <h2>mit ${artist}</h2>
    </hgroup>

    <audio>
<%!
    import webhelpers.html.tags as h
%>\
% for format, description in formats.items():
<%
        url = episode[format]
%>\
        <source src="${url |n}">
% endfor
% for format, description in formats.items():
        ${h.link_to("Download (%s)" % description, url)}
% endfor
    </audio>\

    <section>

    <h1>Linkliste</h1>
<%
    with open(episode['linklist']) as file:
        lines = file.readlines()
%>\
% for line in [l.split() for l in lines]:
<%
    url = line[0]
    description = " ".join(line[1:]).decode('utf-8')
%>\
    % if not description:
<%
            from BeautifulSoup import BeautifulSoup
            import urllib

            print "Getting title of <%s> …" % url
            soup = BeautifulSoup(urllib.urlopen(url))
            description = soup.title.string
%>\
        <a href="${url |n}"><i>${description |h}</i></a>
    % else:
        ${h.link_to(description, url)}
    % endif
% endfor
    </section>
</article>
