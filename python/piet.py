'''
    https://gabriellesc.github.io/piet/
'''

from collections import deque


class Interpreter:
    colors = [
        ['lr', 'ly', 'lg', 'lc', 'lb', 'lm'],
        ['nr', 'ny', 'ng', 'nc', 'nb', 'nm'],
        ['dr', 'dy', 'dg', 'dc', 'db', 'dm']
    ]

    commands = deque([
        deque(['pop', '*', 'not', 'switch', 'in(num)', 'out(char)']),
        deque([' ', '+', '/', '>', 'dup', 'in(char)']),
        deque(['push', '-', 'mod', 'pointer', 'roll', 'out(num)'])
    ])

    def __init__(self):
        self.path = [self.colors[1][0]]

    def get_size(self):
        return len(self.path)

    def get_path(self):
        return ' '.join(self.path)

    def outn(self):
        position = self.search('out(num)')
        self.commands.rotate()
        for i in range(3):
            self.commands[i].rotate(-1)
        self.path.append(self.colors[position[0]][position[1]])

    def dup(self):
        position = self.search('dup')
        for i in range(3):
            self.commands[i].rotate(-2)
        self.path.append(self.colors[position[0]][position[1]])

    def mul(self):
        position = self.search('*')
        self.commands.rotate(-1)
        for i in range(3):
            self.commands[i].rotate()
        self.path.append(self.colors[position[0]][position[1]])

    def push(self):
        position = self.search('push')
        self.commands.rotate()
        self.path.append(self.colors[position[0]][position[1]])

    def add(self):
        position = self.search('+')
        for i in range(3):
            self.commands[i].rotate()
        self.path.append(self.colors[position[0]][position[1]])

    def search(self, cmd):
        position = []
        for i in range(3):
            if cmd in self.commands[i]:
                position.append(i)
                position.append(self.commands[i].index(cmd))
        return position


def get_commands(num):
    # outn dup mul push add
    minc = {
        1: ['push'],
        2: ['push', 'push', 'add'],
        3: ['push', 'push', 'add', 'push', 'add'],
        4: ['push', 'push', 'add', 'dup', 'mul'],
        5: ['push', 'push', 'add', 'dup', 'mul', 'push', 'add'],
        6: ['push', 'push', 'add', 'dup', 'dup', 'add', 'add'],
        7: ['push', 'push', 'add', 'dup', 'dup', 'add', 'add', 'push', 'add'],
        8: ['push', 'push', 'add', 'dup', 'mul', 'dup', 'add'],
        9: ['push', 'push', 'add', 'push', 'add', 'dup', 'mul'],
       10: ['push', 'push', 'add', 'push', 'add', 'dup', 'mul', 'push', 'add'],
       11: ['push', 'push', 'add', 'push', 'add', 'dup', 'mul', 'push', 'add', 'push', 'add'],
       12: ['push', 'push', 'add', 'push', 'add', 'dup', 'dup', 'mul', 'add'],
       13: ['push', 'push', 'add', 'push', 'add', 'dup', 'dup', 'mul', 'add', 'push', 'add'],
       14: ['push', 'push', 'add', 'dup', 'dup', 'add', 'add', 'push', 'add', 'dup', 'add'],
       15: ['push', 'push', 'add', 'dup', 'mul', 'push', 'add', 'dup', 'dup', 'add', 'add'],
       16: ['push', 'push', 'add', 'dup', 'mul', 'dup', 'mul'],
       17: ['push', 'push', 'add', 'dup', 'mul', 'dup', 'mul', 'push', 'add'],
       18: ['push', 'push', 'add', 'push', 'add', 'dup', 'mul', 'dup', 'add'],
       19: ['push', 'push', 'add', 'push', 'add', 'dup', 'mul', 'dup', 'add', 'push', 'add'],
       20: ['push', 'push', 'add', 'dup', 'mul', 'dup', 'dup', 'mul', 'add'],
       21: ['push', 'push', 'add', 'dup', 'mul', 'dup', 'dup', 'mul', 'add', 'push', 'add'],
       22: ['push', 'push', 'add', 'dup', 'mul', 'dup', 'dup', 'mul', 'add', 'push', 'add', 'push', 'add'],
       23: ['push', 'push', 'add', 'dup', 'mul', 'dup', 'dup', 'mul', 'add', 'push', 'add', 'push', 'add', 'push', 'add'],
       24: ['push', 'push', 'add', 'push', 'add', 'dup', 'dup', 'mul', 'add', 'dup', 'add'],
       25: ['push', 'push', 'add', 'dup', 'mul', 'push', 'add', 'dup', 'mul'],
       26: ['push', 'push', 'add', 'dup', 'mul', 'push', 'add', 'dup', 'mul', 'push', 'add'],
    }
    # outn dup mul push add
    return minc[num]


piet = Interpreter()

for el in range(1, 27):
    commands = get_commands(el)
    for cmd in commands:
        getattr(piet, cmd)()
    piet.outn()

print(piet.get_size())
print(piet.get_path())


def check(string):
    colors = string.split()
    for ix, el in enumerate(colors[1:]):
        if colors[ix] == el:
            assert False


check(piet.get_path())
