def _time_to_npt(timestamp):
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
        if fracseconds == 0:
            return "%02d:%02d" % (minutes, seconds)
        else:
            return "%02d:%02d.%d" % (minutes, seconds, fracseconds)
    else:
        if fracseconds == 0:
            return "%d:%02d:%02d" % (hours, minutes, seconds)
        else:
            return "%d:%02d:%02d.%d" % (hours, minutes, seconds, fracseconds)

def parse_linklist(text):
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
        html += '<tr id="t=%s"><td><a href="#t=%s">%s</a>' % \
            (time_npt, time_npt, time)
        if url == '':
            html += '<td>%s</td>' % text
        else:
            html += '<td><a href="%s">%s</a></td>' % (url, text)
        html += '\n'
    html += '</table>\n'
    return html
