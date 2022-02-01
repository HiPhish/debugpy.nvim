import pytest
from .rectoys.add import naive_add


@pytest.mark.parametrize('x,y', [(2, 3), (0, 4), (7, 0)])
def test_test_naive_add(x: int, y: int):
    assert x + y == naive_add(x, y)
