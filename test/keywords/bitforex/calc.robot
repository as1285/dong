*** Settings ***
Library           ../../../testlib/service/bitforex/YxhyService.py
Library           ../../../testlib/service/bitforex/Calc.py
Library           ../../../testlib/service/common/MysqlService.py
Library           data_script.py
Library           qiangping.py
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Resource            ../../keywords/basic/redis.robot
Library             DateTime
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
撤销订单传Id
    [Arguments]        ${orderId}
    [Documentation]  【功能】撤销订单传Id
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}    delete order  ${orderId}
    [Return]    ${result}
撤销全部订单
    [Arguments]
    [Documentation]  【功能】撤销全部订单
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      delete order all
    [Return]    ${result}
批量下单
    [Arguments]
    [Documentation]  【功能】批量下单
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      batch order
    [Return]    ${result}
批量撤单
    [Arguments]
    [Documentation]  【功能】批量撤单
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      delete batch order
    [Return]    ${result}
订单列表
    [Arguments]
    [Documentation]  【功能】订单列表
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      order list
    [Return]    ${result}
强平价格的计算比较
    [Arguments]
    [Documentation]  【功能】强平价格的计算比较
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      Liq price
    [Return]    ${result}
未实现盈亏的计算比较不传参数
    [Arguments]
    [Documentation]  【功能】未实现盈亏的计算比较
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      unrealisedPNL
    [Return]    ${result}
保证金率无需传参
    [Arguments]
    [Documentation]  【功能】保证金率的计算
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      margin rate
    [Return]    ${result}
标记价格的计算比较
    [Arguments]
    [Documentation]  【功能】标记价格的计算比较
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      flagPrice
    [Return]    ${result}
风险率
    [Arguments]
    [Documentation]  【功能】风险率
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      risk
    [Return]    ${result}
买卖单撤单操作无需订单ID
    [Arguments]         ${side}
    [Documentation]  【功能】买卖单撤单操作无需订单ID
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      order    ${side}
    [Return]    ${result}
根据订单里面的列表撤单
    [Arguments]
    [Documentation]  【功能】根据订单里面的列表撤单
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}      delete order by id
    [Return]    ${result}
委托保证金的计算
    [Arguments]
    [Documentation]  【功能】委托保证金的计算
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}    frozen count
    [Return]    ${result}
仓位保证金
    [Arguments]
    [Documentation]  【功能】仓位保证金
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}    margin
    [Return]    ${result}
下单传参数
    [Arguments]     ${side}      ${orderQty}     ${price}
    [Documentation]  【功能】下买单传参数
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}   order by param     ${side}      ${orderQty}     ${price}
    [Return]    ${result}
仓位价值
    [Arguments]
    [Documentation]  【功能】仓位价值
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}    pv
    [Return]    ${result}
回报率
    [Arguments]
    [Documentation]  【功能】回报率
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}    return rate
    [Return]    ${result}
委托数量
    [Arguments]
    [Documentation]  【功能】委托数量
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}    order list num
    [Return]    ${result}
根据买一价卖一价下单

    [Arguments]     ${side}    ${orderQty}  ${symbol}
    [Documentation]  【功能】根据买一价，卖一价下单
    ...
    ...    【参数】${side}
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}    order by OP        ${side}    ${orderQty}  ${symbol}
    [Return]    ${result}
从Exce表里获取数据
     [Arguments]     ${symbol}      ${vol}
    [Documentation]  【功能】从Exce表里获取数据
    ...
    ...    【参数】${symbol}      ${vol}
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}   data    ${symbol}      ${vol}
    [Return]    ${result}
获取标记价格
     [Arguments]
    [Documentation]  【功能】获取标记价格
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}   get_flagprice
    [Return]    ${result}
获取指数价格
     [Arguments]
    [Documentation]  【功能】获取指数价格
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}   get_indexprice
    [Return]    ${result}
委托限价
     [Arguments]  ${side}
    [Documentation]  【功能】获取指数价格
    ...
    ...    【参数】${side}
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}  ULP_LLP     ${side}
    [Return]    ${result}

杠杆合约倍数配置
     [Arguments]  ${symbol}
    [Documentation]  【功能】杠杆合约倍数配置
    ...
    ...    【参数】${symbol}
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${ret_mysql}    根据SQL进行查询  select * from `p_perpetual`.`pp_contract_risk_level_config ` where symbol='${symbol}'
    [Return]    ${ret_mysql}


委托列表获取订单ID集合
     [Arguments]
    [Documentation]  【功能】委托列表获取订单ID集合
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}  get_orderids
    [Return]    ${result}

计算破产价格1
    [Arguments]         ${side}    ${HP}   ${Accb}    ${Vol}   ${IMR}
    [Documentation]  【功能】计算破产价格
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}  brp      ${side}    ${HP}   ${Accb}    ${Vol}   ${IMR}
    [Return]    ${result}

资金费用
    [Arguments]       ${Vol}   ${flagPrice}    ${fundRate}
    [Documentation]  【功能】资金费用
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}  fundfee      ${Vol}   ${flagPrice}    ${fundRate}
    [Return]    ${result}



委托限价1
    [Arguments]       ${side}   ${flagPrice}
    [Documentation]  【功能】委托限价
    ...
    ...    【参数】  委托价格跟当前标记价格偏差不能超过管理后台设置的限价百分比。

    ...                  如果委托是减仓方向，那么委托价格不能突破仓位破产价格。
    ...                     买价<=标记价格*（1 +价格上限百分比）
    ...                 标记价格*20>=卖价>=标记价格*（1- 价格下限百分比）
    ...                         如果委托是加仓方向，那么委托价格不能突破仓位强平价格。
    ...    【返回值】
    ...    result:
    ${result}  limit_price      ${side}   ${flagPrice}
    [Return]    ${result}

账号初始化，增币
    [Arguments]       ${uid}   ${amount}
    [Documentation]  【功能】账号初始化，增币
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}  create_coin       ${uid}   ${amount}
    [Return]    ${result}
批量下单接口
    [Arguments]       ${orderQty}       ${price}    ${side}     ${symbol}       ${num}
    [Documentation]  【功能】批量下单
    ...
    ...    【参数】
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}  batch_order       ${orderQty}       ${price}    ${side}     ${symbol}       ${num}
    [Return]    ${result}

起始保证金
IniMargins1(self,Vol,IMR,HP):#起始保证金
    [Arguments]       ${Vol}       ${IMR}    ${HP}
    [Documentation]  【功能】起始保证金
    ...
    ...    【参数】起始保证金率  ${IMR}
    ...
    ...
    ...
    ...    【返回值】
    ...    result:
    ${result}  batch_order      ${Vol}       ${IMR}    ${HP}
    [Return]    ${result}