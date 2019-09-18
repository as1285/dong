import math
class UtilService:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def compare_float(self, float1, float2, abs_tol=0):

        float1=float(float1)
        float2 = float(float2)
        result = math.isclose(float1, float2, abs_tol=abs_tol)
        print(float1,float2)
        if not result:
            print('没有结果')

        print(result)
        return result
if __name__ == '__main__':

    result = UtilService().compare_float(1.00001, 1.00001, 0.00002)
    print(result)
