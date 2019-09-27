*** Settings ***
Resource            ../../keywords/bitforex/bb.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Resource            ../../keywords/basic/redis.robot
Library             DateTime


*** Test Cases ***
下单撤单
    ${nonce}    evaluate    int(round(time.time() * 1000))    modules=time
    &{params}    create dictionary    symbol=coin-btc-eth    ordersData=[{"price": 0.02063908,"amount": 0.02, "tradeType": 1}]    nonce=${nonce}
    ${res}    bb_api调用    bb_yj    /api/v1/trade/placeMultiOrder    post    params=&{params}
    should be true    ${res['success']}
    ${order_id}    set variable    ${res['data'][0]['orderId']}

    sleep    1
    ${nonce}    evaluate    int(round(time.time() * 1000))    modules=time
    &{params}    create dictionary    symbol=coin-btc-eth    orderIds=${order_id}    nonce=${nonce}
    ${res}    bb_api调用    bb_yj    /api/v1/trade/cancelMultiOrder    post    params=&{params}
    should be true    ${res['success']}







