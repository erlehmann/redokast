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

    <audio controls>
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
        <section>
            <ul>
<%
    with open(episode['linklist']) as file:
        lines = file.readlines()
%>\
% for line in [l.split() for l in lines]:
<%!
    from urlparse import urlparse
%>\
    % if len(line) > 0:
        % if not urlparse(line[0]).scheme:
            </ul>
        </section>
        <section>
            <h1>${" ".join(line).decode('utf-8') |x}</h1>
            <ul>
        % else:
<%
            url = line[0]
            description = " ".join(line[1:]).decode('utf-8')
%>\
        % if not description:
<%!
                from BeautifulSoup import BeautifulSoup
                from urllib import urlopen
%>\
<%
                print "Getting title of <%s> …" % url
                soup = BeautifulSoup(urlopen(url))
                description = soup.title.string
%>\
                <li><a href="${url |n}"><i>${description |n}</i></a></li>
            % else:
                <li>${h.link_to(description, url)}</li>
            % endif
        % endif
    % endif
% endfor
            </ul>
        </section>
    </section>
</article>
