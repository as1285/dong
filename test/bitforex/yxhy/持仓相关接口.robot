*** Settings ***
Resource          ../../keywords/bitforex/yxhy.robot
Resource          ../../keywords/bitforex/calc.robot
Resource          ../../keywords/basic/mysql.robot
Resource          ../../keywords/basic/util.robot
Library           DateTime

*** Test Cases ***
#获取强平未处理订单数量
#    log    --loglevel DEBUG:DEBUG
#    ${res}    yxhy_api调用    user_yj1    swap/order/getLiqCount
#    ${code}    set variable    ${res['code']}
#    log    ${res['code']}
#    should be equal as strings    ${code}    200
获取用户历史账单
    ${page}    set variable         ${1}
    ${size}    set variable
    ${symbol}    set variable
    ${type}    set variable
    ${res}    yxhy_api调用    user_yj1    swap/order/historicalBill/     page=${page}     size=${size}    symbol=${symbol}    type=${type}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200

获取用户历史委托列表
    ${page}    set variable
    ${size}    set variable
    ${symbol}    set variable
    ${res}    yxhy_api调用    user_yj1    swap/order/history/     page=${page}     size=${size}    symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
获取用户当前委托列表
    ${page}    set variable
    ${size}    set variable
    ${symbol}    set variable
    ${res}    yxhy_api调用    user_yj1    swap/order/list/    page=${page}     size=${size}    symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
获取用户已成交列表
    ${res}    yxhy_api调用    user_yj1    swap/order/trade/
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
用户持仓
    ${symbol}    set variable
    ${res}    yxhy_api调用    user_yj1    swap/position/      symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
