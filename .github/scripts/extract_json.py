#!/usr/bin/env python3
import sys
import re

def extract_from_text(s: str) -> str:
    # Find first '{' or '[' and return from there
    idxs = [i for i in (s.find('{'), s.find('[')) if i != -1]
    if idxs:
        return s[min(idxs):]
    # Try to strip a leading terraform show command line and search again
    m = re.search(r".*?terraform[-_\w/\\.]*\s+show[^\n]*\n(.*)", s, re.S)
    if m:
        tail = m.group(1)
        idxs = [i for i in (tail.find('{'), tail.find('[')) if i != -1]
        if idxs:
            return tail[min(idxs):]
    return ''


def main():
    if len(sys.argv) < 2:
        print('Usage: extract_json.py <input-file> [output-file]', file=sys.stderr)
        sys.exit(2)
    infile = sys.argv[1]
    outfile = sys.argv[2] if len(sys.argv) > 2 else None
    data = open(infile, 'rb').read().decode('utf-8', 'ignore')
    out = extract_from_text(data)
    if outfile:
        open(outfile, 'w', encoding='utf-8').write(out)
    else:
        sys.stdout.write(out)


if __name__ == '__main__':
    main()
