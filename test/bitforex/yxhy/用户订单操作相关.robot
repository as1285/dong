*** Settings ***
Resource          ../../keywords/bitforex/yxhy.robot
Resource          ../../keywords/bitforex/calc.robot
Resource          ../../keywords/basic/mysql.robot
Resource          ../../keywords/basic/redis.robot
Resource          ../../keywords/basic/util.robot
Library           DateTime

*** Test Cases ***
下买单-撤单
    ${future}    set variable    ${0}
    ${orderQty}    set variable    ${1234}
    ${price}    set variable    ${11111}
    ${side}    set variable    ${1}
    ${source}    set variable    1
    ${symbol}    set variable    swap-usd-btc
    ${type}    set variable    ${1}
    ${res}    yxhy_api调用    user_yj1    /swap/order    method=post    future=${future}    orderQty=${orderQty}    price=${price}    side=${side}    source=${source}    symbol=${symbol}    type=${type}
    should be equal as strings    ${res['code']}    200
    ${orderId}    set variable    ${res['data']}
    ${res}    yxhy_api调用    user_yj1    /swap/order    method=delete    orderId=${orderId}    price=${price}    source=${source}    symbol=${symbol}
    should be equal as strings    ${res['code']}    200

下卖单-撤单
    ${future}    set variable    ${0}
    ${orderQty}    set variable    ${1234}
    ${price}    set variable    ${11111}
    ${side}    set variable    ${2}
    ${source}    set variable    1
    ${symbol}    set variable    swap-usd-btc
    ${type}    set variable    ${1}
    ${res}    yxhy_api调用    user_yj1    /swap/order    method=post    future=${future}    orderQty=${orderQty}    price=${price}    side=${side}    source=${source}    symbol=${symbol}    type=${type}
    should be equal as strings    ${res['code']}    200
    ${orderId}    set variable    ${res['data']}
    ${res}    yxhy_api调用    user_yj1    /swap/order    method=delete    orderId=${orderId}    price=${price}    source=${source}    symbol=${symbol}
    should be equal as strings    ${res['code']}    200
    log  --loglevel DEBUG:DEBUG


