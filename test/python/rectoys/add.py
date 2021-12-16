"""Toy implementations of functions which recursively add two numbers."""


def naive_add(x: int, y: int) -> int:
    """A naive implementation which can blow the call stack."""
    if y == 0:
        return x
    return naive_add(x, y - 1) + 1


def tail_add(x: int, y: int) -> int:
    """A tail-recursive implementation which will run in constant space."""
    if y == 0:
        return x
    else:
        return tail_add(x + 1, y - 1)


def loop_add(x: int, y: int) -> int:
    """An imperative implementation using a loop and in-place mutation."""
    while y != 0:
        x += 1
        y -= 1
    return x
