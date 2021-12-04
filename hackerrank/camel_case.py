# Enter your code here. Read input from STDIN. Print output to STDOUT
import sys

def process(line):
    result = ''
    if line[0] == 'S':
        for char in line[4:]:
            if char.isupper():
                result = result + ' ' + char.lower()
            else:
                result += char
        if result[-1] == ')':
            result = result[:-2]
    elif line[0] == 'C':
        parts = line[4:].split()
        if line[2] == 'C':
            parts[0] = parts[0].capitalize()
        result = ''.join([parts[0]] + [part.capitalize() for part in parts[1:]])
        if line[2] == 'M':
            result += '()'

    print(result.strip())
        
    


for line in sys.stdin:
    process(line.strip())
