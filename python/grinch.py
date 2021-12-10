#inp = 'gbp' # Box[Gift]
#inp = 'gbpbp' # Box[Box[Gift]] Box[Box[Gift]]
#inp = 'bgbpp' # Box[Box[];Gift] Box[Box[];Gift]
inp = 'gbpbpbbbpbpppbp' # Box[Box[Box[Box[Gift]];Box[];Box[Box[]]]]
                        # Box[Box[Box[Box[Gift]];Box[];Box[Box[]]]]

def deep_print(struct):
    msg = []
    for elem in struct:
        if isinstance(elem, list):
            msg.append('Box[' + deep_print(elem) + ']')
        else:
            msg.append('Gift')
    return ';'.join(msg)

def pack(inp):
    stack = []
    
    for char in inp:
        if char == 'g':
            stack.append('Gift')
        elif char == 'b':
            stack.append([])
        elif char == 'p':
            # положить что-то в коробку, когда перед эльфом ничего не было
            if len(stack) < 2:
                    return 'fail'
            # нельзя класть коробки в подарки
            if isinstance(stack[-1], list):
                box = stack.pop()
                item = stack.pop()
                box.insert(0, item)
                stack.append(box)
    return stack

stack = pack(inp)

# больше одного предмета недопустимо
if len(stack) > 1:
    print('fail')
else:
    print(deep_print(stack))
    

            