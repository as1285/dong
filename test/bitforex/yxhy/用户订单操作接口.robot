*** Settings ***
Resource          ../../keywords/bitforex/yxhy.robot
#Resource          ../../keywords/bitforex/calc.robot
#Resource          ../../keywords/basic/mysql.robot
#Resource          ../../keywords/basic/util.robot
Library           DateTime

*** Test Cases ***
下单
    ${page}    set variable
    ${size}    set variable
    ${symbol}    set variable
    ${type}    set variable
    ${source}     set variable
    ${future}      set variable
    ${side}     set variable
    log    --loglevel DEBUG:DEBUG
    ${res}    yxhy_api调用    user_yj1    swap/order     method=post      page=${page}     size=${size}    symbol=${symbol}    type=${type}   source=${source}      future=${future}  side=${side}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
撤销订单
    ${orderId}    set variable
    ${price}   set variable
    ${symbol}    set variable
    ${source}   set variable
    ${res}    yxhy_api调用    user_yj1    swap/order   method=delete  orderId=${orderId}     price=${price}    symbol=${symbol}    source=${source}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200

撤销全部订单
    ${orderId}    set variable
    ${price}   set variable
    ${symbol}    set variable
    ${source}   set variable
    ${res}    yxhy_api调用    user_yj1    swap/order   method=delete  orderId=${orderId}     price=${price}    symbol=${symbol}    source=${source}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
批量下单
    ${page}    set variable
    ${size}    set variable
    ${symbol}    set variable
    ${type}    set variable
    ${source}     set variable
    ${future}      set variable
    ${side}     set variable
    log    --loglevel DEBUG:DEBUG
    ${res}    yxhy_api调用    user_yj1    swap/order     method=post      page=${page}     size=${size}    symbol=${symbol}    type=${type}   source=${source}      future=${future}  side=${side}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
批量撤单
    ${orderIds}    set variable
    ${symbol}    set variable
    ${source}   set variable
    ${res}    yxhy_api调用    user_yj1    swap/order/batch/   method=delete  orderId=${orderIds}        symbol=${symbol}    source=${source}

    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200

平仓
    ${orderId}    set variable
    ${price}   set variable
    ${symbol}    set variable
    ${source}   set variable
    ${res}    yxhy_api调用    user_yj1    swap/position   method=delete   orderId=${orderId}     price=${price}    symbol=${symbol}    source=${source}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
自成交
    ${orderQty}    set variable
    ${price}   set variable
    ${symbol}    set variable
    ${side}   set variable
    ${res}    yxhy_api调用    user_yj1    swap/orderSelf/   method=delete   orderQty=${orderQty}     price=${price}    symbol=${symbol}    side=${side}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200