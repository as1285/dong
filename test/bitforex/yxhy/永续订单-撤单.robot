*** Settings ***
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Library             DateTime

*** Test Cases ***
开仓撤单-多-修改订单状态是否成功
    ${res}     根据买一价卖一价下单     1    123    swap-usd-btc
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
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

    ${ret_mysql}    根据SQL进行查询    mysql    select * from `p_perpetual`.`pp_order_btcusdt` where id='${orderId}'
    ${status}    set variable    ${ret_mysql[0]['status']}
    ${price1}   set variable    ${ret_mysql[0]['price']}
    ${volume1}   set variable    ${ret_mysql[0]['volume']}
    should be equal  ${status}   4
    should be equal  ${price1}   ${price}
    should be equal  ${volume1}    ${volume}

当前委托-全部撤单
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

比特币批量下单
    ${orderQty}    set variable    ${123}
    ${price}    set variable    获取指数价格
    ${side}    set variable    ${1}
    ${symbol}    set variable    swap-usd-btc
    ${num}    set variable    ${10}
    ${res}    批量下单接口     ${orderQty}       ${price}    ${side}     ${symbol}       ${num}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${data}    set variable       ${res['data']}
    should not be empty      ${data}

比特币批量撤单

    ${orderIds}    set variable     委托列表获取订单ID集合

    ${symbol}    set variable     swap-usd-btc
    ${source}   set variable    1
    ${res}    yxhy_api调用    user_yj1    swap/order/batch/   method=delete  orderId=${orderIds}        symbol=${symbol}    source=${source}

    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${orderId}    set variable   ${none}
    evaluate  for ${orderId} in ${orderIds}

        ${ret_mysql}    根据SQL进行查询    mysql    select * from `p_perpetual`.`pp_order_btcusdt` where id='${orderId}'
        ${status}    set variable    ${ret_mysql[0]['status']}

        should be equal  ${status}   4


开仓撤单-多-解冻用户委托保证金
    ${res}     根据买一价卖一价下单     1    123    swap-usd-btc
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1        /contract/swap/account/sumFound
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${frozen}    set variable    ${res['data']['accounts']['swap-usd-btc']['frozen']}
    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/list/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200

    ${price}    set variable       ${res['data']['pageData'][0]['prince']}
    ${orderId}    set variable       ${res['data']['pageData'][0]['entrustId']}
    ${symbol}    set variable         swap-usd-btc
    ${source}   set variable            1
    ${res}    yxhy_api调用    user_yj1    swap/order   method=delete  orderId=${orderId}     price=${price}    symbol=${symbol}    source=${source}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1        /contract/swap/account/sumFound
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${frozen1}    set variable    ${res['data']['accounts']['swap-usd-btc']['frozen']}
    should be equal    ${frozen1}     0



开仓撤单-空-解冻用户委托保证金
    ${res}     根据买一价卖一价下单     2    123    swap-usd-btc
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1        /contract/swap/account/sumFound
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${frozen}    set variable    ${res['data']['accounts']['swap-usd-btc']['frozen']}
    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/list/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200

    ${price}    set variable       ${res['data']['pageData'][0]['prince']}
    ${orderId}    set variable       ${res['data']['pageData'][0]['entrustId']}
    ${symbol}    set variable         swap-usd-btc
    ${source}   set variable            1
    ${res}    yxhy_api调用    user_yj1    swap/order   method=delete  orderId=${orderId}     price=${price}    symbol=${symbol}    source=${source}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1        /contract/swap/account/sumFound
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${frozen1}    set variable    ${res['data']['accounts']['swap-usd-btc']['frozen']}
    should be equal    ${frozen1}     0

全部撤单-对所有币种当前委托进行撤单
    ${res}      yxhy_api调用    user_yj1        /contract/swap/contract/listAll
    Log To Console      ${res['data']}
    ${data}    set variable     ${res['data']}
    Log To Console      ${data}
    ${length}        get length     ${data}
    :FOR    ${i}   IN RANGE  ${length}
    \   Log To Console    ${data}[${i}][symbol]
    \   ${symbol}    set variable    ${data}[${i}][symbol]
    \   ${res}     根据买一价卖一价下单     1    123    ${data}[${i}][symbol]
    \   ${code}    set variable    ${res['code']}
    \   log    ${res['code']}
    \   should be equal as strings    ${code}    200
    \   ${res}    yxhy_api调用    user_yj1    /contract/swap/order/all   method=delete     symbol=${symbol}    source=1
    \   ${code}    set variable    ${res['code']}
    \   log    ${res['code']}
    \   should be equal as strings    ${code}    200
    \   ${res}    yxhy_api调用    user_yj1    /contract/swap/order/list/${symbol}
    \   ${code}    set variable    ${res['code']}
    \   log    ${res['code']}
    \   should be equal as strings    ${code}    200

