from w3lib import html

def _time_to_npt(timestamp, webvtt_timestamp=False):
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
    if webvtt_timestamp:
        return "%02d:%02d:%02d.%03d" % (hours, minutes, seconds, fracseconds)
    if hours == 0:
        if fracseconds == 0:
            return "%02d:%02d" % (minutes, seconds)
        else:
            return "%02d:%02d.%03d" % (minutes, seconds, fracseconds)
    else:
        if fracseconds == 0:
            return "%d:%02d:%02d" % (hours, minutes, seconds)
        else:
            return "%d:%02d:%02d.%03d" % (hours, minutes, seconds, fracseconds)


def parse_linklist(text, remove_tags=False):
    data = []

    for row in text.split('\n'):
        rowparts = row.strip().split(' ')
        if len(rowparts) < 2:
            break
        time = rowparts[0]
        if rowparts[1].startswith('<') and rowparts[1].endswith('>'):
            url = rowparts[1][1:-1]
            textparts = rowparts[2:]
        else:
            url = ''
            textparts = rowparts[1:]
        text = ' '.join(textparts)
        if remove_tags:
            text = html.remove_tags(text)
        data.append(
            {
                'time': time,
                'url': url,
                'text': text
            }
        )
    return data

def serialize_html_table(data):
    html = '<table>\n'
    for element in data:
        time = element['time']
        time_npt = _time_to_npt(time)
        url = element['url']
        text = element['text']
        html += '<tr><td><a href="#audio&t=%s">%s</a>' % (time_npt, time)
        if url == '':
            html += '<td>%s</td>' % text
        else:
            html += '<td><a href="%s">%s</a></td>' % (url, text)
        html += '\n'
    html += '</table>\n'
    return html

def serialize_webvtt(data, last_chapter_end):
    webvtt = 'WEBVTT\n'
    chapter_title = None
    chapter_start = None
    chapter_end = None
    for i, element in enumerate(data):
        chapter_title = element['text']
        chapter_start = _time_to_npt(element['time'], webvtt_timestamp=True)
        try:
            chapter_end = _time_to_npt(data[i+1]['time'], webvtt_timestamp=True)
        except IndexError:  # last chapter
            chapter_end = _time_to_npt(last_chapter_end, webvtt_timestamp=True)
        webvtt += "\n%s\n" % i
        webvtt += "%s --> %s\n" % (chapter_start, chapter_end)
        webvtt += "%s\n" % chapter_title
    return webvtt
