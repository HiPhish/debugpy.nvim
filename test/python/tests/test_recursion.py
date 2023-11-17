import pytest
from rectoys.add import naive_add, loop_add


@pytest.mark.parametrize('x,y', [(2, 3), (0, 4), (7, 0)])
def test_naive_add(x: int, y: int):
    assert x + y == naive_add(x, y)


@pytest.mark.parametrize('x,y', [(2, 3), (0, 4), (7, 0)])
def test_loop_add(x: int, y: int):
    assert x + y == loop_add(x, y)
