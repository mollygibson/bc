import sys

def cleanup(line):
    return line.replace("&quot;", '"').replace('&#39;', "'").rstrip()

lining = False
for filename in sys.argv[1:]:
    if lining:
        print '<hr/>'
    lining = True

    with open(filename, 'r') as reader:
        echo = False
        for line in reader:
            if '<div class="row-fluid">' in line:
                echo = True
            elif '<div class="footer">' in line:
                echo = False
            if echo:
                print cleanup(line)
