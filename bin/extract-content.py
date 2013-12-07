import sys

def cleanup(line):
    return line.replace("&quot;", '"').replace('&#39;', "'").rstrip()

lining = False
for filename in sys.argv[1:]:
    with open(filename, 'r') as reader:
        filetype = None
        echo = False
        if lining:
            print '<hr/>'
        lining = True
        for line in reader:

            if (filetype is None) and ('<title>[]</title>' in line):
                filetype = 'ipynb'

            elif (filetype is None) and ('</head>' in line):
                filetype = 'md'

            elif filetype == 'md':
                if '<div class="row-fluid">' in line:
                    echo = True
                elif '<div class="footer">' in line:
                    echo = False
                if echo:
                    print cleanup(line)

            elif filetype == 'ipynb':
                if '</body>' in line:
                    echo = False
                if echo:
                    print cleanup(line)
                if '<body>' in line:
                    echo = True
