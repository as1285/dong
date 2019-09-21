*** Settings ***
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Library             DateTime

*** Test Cases ***
下单

    ${price}    set variable     获取指数价格
    ${size}    set variable         1
    ${symbol}    set variable       swap-usd-btc
    ${type}    set variable     1
    ${source}     set variable      1
    ${orderQty}      set variable         1
    ${side}     set variable            1
    log    --loglevel DEBUG:DEBUG
    ${res}    yxhy_api调用    user_yj1    swap/order     method=post      price=${price}     size=${size}    symbol=${symbol}    type=${type}   source=${source}      orderQty=${orderQty}  side=${side}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${orderid}    set variable        ${res['data']}
    ${user_id}    获取user_id    user_yj1
    ${ret_mysql}    执行指定SQL语句并获取字典形式结果    mysql    select * from `p_perpetual`.`pp_order_btcusdt` where u_id='${user_id}' and d=' ${orderid}'
    ${side1}    set variable    ${ret_mysql[0]['side']}
    ${price1}   set variable    ${ret_mysql[0]['price']}
    ${deal_volume}   set variable    ${ret_mysql[0]['deal_volume']}
    ${volume}   set variable    ${ret_mysql[0]['volume']}
    ${source1}   set variable    ${ret_mysql[0]['source']}
    should not be equal   ${deal_volume}+${volume}=${orderQty}
    should not be equal   ${price1}   ${price}
    should not be equal   ${side1}       ${side}
    should not be equal   ${source1}       ${source}

    should be equal as strings    ${code}    200

撤销订单
    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/list/swap-usd-btc

    ${code}    set variable    ${res['code']}

    should be equal as strings    ${code}    200

    ${price}    set variable       ${res['data']['pageData'][0]['prince']}
    ${volume}    set variable       ${res['data']['pageData'][0]['volume']}
    ${orderId}    set variable       ${res['data']['pageData'][0]['entrustId']}
    ${symbol}    set variable         swap-usd-btc
    ${source}   set variable            1
    ${res}    yxhy_api调用    user_yj1    swap/order   method=delete  orderId=${orderId}     price=${price}    symbol=${symbol}    source=${source}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200

    ${ret_mysql}    执行指定SQL语句并获取字典形式结果    mysql    select * from `p_perpetual`.`pp_order_btcusdt` where id='${orderId}'
    ${status}    set variable    ${ret_mysql[0]['status']}
    ${price1}   set variable    ${ret_mysql[0]['price']}
    ${volume1}   set variable    ${ret_mysql[0]['volume']}
    should be equal  ${status}   4
    should be equal  ${price1}   ${price}
    should be equal  ${volume1}    ${volume}

撤销全部订单
    ${symbol}    set variable       swap-usd-btc
    ${source}   set variable        1
    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/all   method=delete     symbol=${symbol}    source=${source}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/list/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${source}    set variable

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

    ${orderIds}    set variable     委托列表获取订单ID集合

    ${symbol}    set variable     swap-usd-btc
    ${source}   set variable    1
    ${res}    yxhy_api调用    user_yj1    swap/order/batch/   method=delete  orderId=${orderIds}        symbol=${symbol}    source=${source}

    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${orderId}    set variable   ${none}
    evaluate  for ${orderId} in ${orderIds}

        ${ret_mysql}    执行指定SQL语句并获取字典形式结果    mysql    select * from `p_perpetual`.`pp_order_btcusdt` where id='${orderId}'
        ${status}    set variable    ${ret_mysql[0]['status']}

        should be equal  ${status}   4



平仓

    ${future}    set variable    ${0}
    ${orderQty}    set variable    ${1234}
    ${price}    set variable    获取指数价格
    ${side}    set variable    ${1}
    ${source}    set variable    1
    ${symbol}    set variable    swap-usd-btc
    ${type}    set variable    ${1}
    ${res}    yxhy_api调用    user_yj1    /swap/order    method=post    future=${future}    orderQty=${orderQty}    price=${price}    side=${side}    source=${source}    symbol=${symbol}    type=${type}
    should be equal as strings    ${res['code']}    200
    ${orderId}    set variable    ${res['data']}
    ${future}    set variable    ${0}
    ${orderQty}    set variable    ${1234}
    ${price}    set variable    获取指数价格
    ${side}    set variable    ${2}
    ${source}    set variable    1
    ${symbol}    set variable    swap-usd-btc
    ${type}    set variable    ${1}
    ${res}    yxhy_api调用    user_yj1    /swap/order    method=post    future=${future}    orderQty=${orderQty}    price=${price}    side=${side}    source=${source}    symbol=${symbol}    type=${type}
    should be equal as strings    ${res['code']}    200
    ${orderId}    set variable    ${res['data']}


自成交
    ${orderQty}    set variable     1
    ${price}   set variable         9800
    ${symbol}    set variable       swap-usd-btc
    ${side}   set variable          1
    ${res}    yxhy_api调用    user_yj1    swap/orderSelf/   method=delete   orderQty=${orderQty}     price=${price}    symbol=${symbol}    side=${side}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200