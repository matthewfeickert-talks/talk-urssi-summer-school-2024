import numpy as np
from pytest import approx
from scipy.optimize import minimize

from rosen_cpp import basic_math
from rosen_cpp.example import rosen, rosen_der


def test_example():
    x0 = np.array([1.3, 0.7, 0.8, 1.9, 1.2])
    result = minimize(rosen, x0, method="BFGS", jac=rosen_der, options={"disp": True})
    optimized_params = result.x
    assert approx(optimized_params.tolist()) == [
        1.00000004,
        1.0000001,
        1.00000021,
        1.00000044,
        1.00000092,
    ]


def test_basic_math():
    assert basic_math.add(1, 2) == 3
    assert basic_math.subtract(1, 2) == -1
