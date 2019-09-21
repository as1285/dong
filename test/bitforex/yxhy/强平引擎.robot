*** Settings ***
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Resource            ../../keywords/basic/redis.robot
Library             DateTime

*** Test Cases ***
强平触发
    ${res}    yxhy_api调用    user_yj1    /swap/position/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${liquidationPrice}    set variable    ${res['data']['liquidationPrice']}
    ${alias}   set variable    flagprince
    ${name}        set variable        current
    ${field}     set variable      perpetual
    ${data}         set variable        ["java.math.BigDecimal",${liquidationPrice}]
    ${db}       set variable            0
    ${toJson}   set variable
    RedisService.hset   ${alias}    ${name}    ${field}    ${data}    ${db}    ${toJson}=${False}
    ${res}    yxhy_api调用    user_yj1    swap/account/sumFound
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${accb}    set variable    ${res['data']['accb']}
    should be equal as strings    ${accb}       0


最高限价
    ${side}    set variable    '1'
    ${res}     委托限价    ${side}
    ${price}    set variable    ${res}
    ${orderQty}    set variable    ${1}
    ${source}    set variable    1
    ${symbol}    set variable   swap-usd-btc
    ${type}    set variable    ${1}
    ${res}    yxhy_api调用    user_yj1    /swap/order    method=post       orderQty=${orderQty}    price=${price}    side=${side}    source=${source}    symbol=${symbol}    type=${type}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    should be true  ${res['data']}


最低限价
    ${side}    set variable    '2'
    ${res}     委托限价    ${side}
    ${price}    set variable    ${res}
    ${orderQty}    set variable    ${1}
    ${source}    set variable    1
    ${symbol}    set variable   swap-usd-btc
    ${type}    set variable    ${1}
    ${res}    yxhy_api调用    user_yj1    /swap/order    method=post       orderQty=${orderQty}    price=${price}    side=${side}    source=${source}    symbol=${symbol}    type=${type}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    should be true  ${res['data']}

补仓后重新计算强平价格
    ${res}    yxhy_api调用    user_yj1    /swap/position/swap-usd-btc    ${none}    ${True}    ${None}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${hp}    set variable    ${res['data']['avgCostPrice']}
    ${vol}    set variable    ${res['data']['currentPosition']}
    ${side}    set variable    ${res['data']['side']}
    ${liquidationPrice}    set variable    ${res['data']['liquidationPrice']}
    ${ret_mysql}    执行指定SQL语句并获取字典形式结果    mysql    select * from `p_perpetual`.`pp_contract_config`
    ${r}    set variable    ${ret_mysql[0]['fee_rate_taker']}
    ${imr}    set variable    ${ret_mysql[0]['init_margins']}
    ${mmr}    set variable    ${ret_mysql[0]['maintenance_margins']}
    ${s}    set variable    ${ret_mysql[0]['unit_quantity']}
    ${res1}    yxhy_api调用    user_yj1    /swap/account/swap-usd-btc
    ${code1}    set variable    ${res1['code']}
    should be equal as strings    ${code1}    200
    ${accb}    set variable    ${res1['data']['accb']}
    ${cal_liqp}    计算强平价格    ${hp}   ${r}    ${accb}    ${vol}    ${imr}    ${mmr}    ${s}    ${side}
    ${result}    浮点数比较    ${liquidationPrice}    ${cal_liqp}    ${0.01}
    should be true    ${result}
    ${orderQty}     set variable    ${vol}
    ${price}            set variable   获取指数价格
    ${res}     下买单传参数  ${orderQty}     ${price}
    ${code1}    set variable    ${res1['code']}
    should be equal as strings    ${code1}    200




