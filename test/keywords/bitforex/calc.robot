*** Settings ***
Library           ../../../testlib/service/bitforex/YxhyService.py
Library           ../../../testlib/service/bitforex/Calc.py
Library           ../../../testlib/service/common/MysqlService.py
Library           data_script.py
Library           qiangping.py

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

计算强平价格
    [Arguments]    ${hp}    ${r}    ${accb}    ${vol}    ${imr}    ${mmr}    ${s}    ${side}
    [Documentation]  【功能】计算仓位的强平价格
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    log many    ${hp}    ${r}    ${accb}    ${vol}    ${imr}    ${mmr}    ${s}    ${side}
    ${result}    cal_liqp    ${hp}    ${r}    ${accb}    ${vol}    ${imr}    ${mmr}    ${s}    ${side}
    [Return]    ${result}
计算未实现盈亏
    [Arguments]      ${side}    ${vol}      ${hp}     ${FP}
    [Documentation]  【功能】计算未实现盈亏
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    log many    ${side}    ${vol}      ${hp}     ${FP}
    ${result}    unrealisedPNL  ${side}    ${vol}      ${hp}     ${FP}
    [Return]    ${result}
根据可用余额下单
    [Arguments]      ${side}
    [Documentation]  【功能】根据可用余额下单
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    log many    ${side}
    ${result}    order_nums  ${side}
    [Return]    ${result}

与持仓反向的委托是否优先平仓
    [Arguments]
    [Documentation]  【功能】与持仓反向的委托是否优先平仓
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}    postion
    [Return]    ${result}

下买单根据指数价格和可用余额
    [Arguments]
    [Documentation]  【功能】下买单根据指数价格和可用余额
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}    buy order1
    [Return]    ${result}
下卖单根据指数价格和可用余额
    [Arguments]        ${vol}
    [Documentation]  【功能】下卖单根据指数价格和可用余额
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}    sell order1    ${vol}
    [Return]    ${result}