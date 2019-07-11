*** Settings ***
Library           ../../../testlib/service/common/UtilService.py

*** Keywords ***
浮点数比较
    [Arguments]    ${float1}    ${float2}    ${abs_tol}
    [Documentation]    【功能】使用select语句查询指定表格，并获取数据
    ...
    ...    【参数】
    ...    float1: 浮点数1
    ...    float2: 浮点数2
    ...    abs_tol：精度,如: 0.0001
    ...    【返回值】
    ...    result: float1-float2 < abs_tol返回True,否则返回False
    ${result}    UtilService.compare_float    ${float1}    ${float2}    abs_tol=${abs_tol}
    [Return]    ${result}

