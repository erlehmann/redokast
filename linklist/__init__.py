def parse_linklist(text):
    data = []

    for row in text.split('\n'):
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
        text = ' '.join(textparts)
        data.append(
            {
                'timestamp': timestamp,
                'url': url,
                'text': text
            }
        )
    return data
