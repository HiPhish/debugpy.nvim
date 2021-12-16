from rectoys.add import naive_add, tail_add, loop_add

if __name__ == '__main__':
    x, y = 2, 3
    print(f'The sum of {x} and {y} is {naive_add(x, y)}.')
    print(f'The sum of {x} and {y} is {tail_add(x, y)}.')
    print(f'The sum of {x} and {y} is {loop_add(x, y)}.')
