#!/usr/bin/env python3
# coding=utf-8

import math
from testlib.utils.logger import logger


class UtilService:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def compare_float(self, float1, float2, abs_tol=0):
        result = math.isclose(float1, float2, abs_tol=abs_tol)
        if not result:
            logger.error('{0} not equal {1}'.format(float1, float1))
        return result


if __name__ == '__main__':

    result = UtilService().compare_float(1.00001, 1.00001, 0.00002)
    print(result)
