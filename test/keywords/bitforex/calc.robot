*** Settings ***
Library           ../../../testlib/service/bitforex/YxhyService.py
Library           ../../../testlib/service/bitforex/Calc.py
Library           ../../../testlib/service/common/MysqlService.py


*** Keywords ***
计算破产价格
    [Arguments]    ${HP}    ${R}    ${Accb}    ${Vol}    ${S}    ${IMR}
    [Documentation]    【功能】计算破产价格
    ...
    ...
    ...    【参数】
    ...    HP: 持仓价格
    ...    R：taker手续费
    ...    Accb：账户余额
    ...    Vol: 持仓数量
    ...    S：合约乘数
    ...    IMR: 起始保证金率
    ...    【返回值】
    ...    res：破产价格
    ${result}    brp    ${HP}    ${R}    ${Accb}    ${Vol}    ${S}    ${IMR}
    [Return]    ${result}