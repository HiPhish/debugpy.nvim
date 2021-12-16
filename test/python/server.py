"""An infinite loop toy program which the debugger can attach to."""

from rectoys.add import naive_add, tail_add, loop_add
from random import randint
from time import sleep
from debugpy import listen  # type: ignore

(host, port) = listen(5678)

print(f'Listening on {host}:{port}')

if __name__ == '__main__':
    while True:
        for f in [naive_add, tail_add, loop_add]:
            x, y = randint(1, 10), randint(1, 10)
            print(f'The sum of {x} and {y} is {f(x, y)}.')
            sleep(1)
