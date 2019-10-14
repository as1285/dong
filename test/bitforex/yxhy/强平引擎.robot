*** Settings ***
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Resource            ../../keywords/basic/redis.robot
Library             DateTime

*** Test Cases ***
强平触发
    根据SQL进行查询   mysql       update p_perpetual.pp_assets set fixed_asset=0.1 where u_id=2195580
    ${res}    yxhy_api调用    user_yj1    swap/position/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${liquidationPrice}    set variable    ${res['data']['liquidationPrice']}
    ${alias}    set variable    redis
    ${name}        set variable        perpetual:swap-usd-btc_flag_price
    ${data}        set variable       ["com.bitforex.perpetual.service.orderservice.vo.FlagPrice",{"symbol":"swap-usd-btc","fundRate":["java.math.BigDecimal",-0.003],"indexPrice":["java.math.BigDecimal",8356.79],"current":["java.math.BigDecimal",${liquidationPrice}-10],"flagPriceDiff":["java.math.BigDecimal",-19.69],"flagPriceDiffRate":["java.math.BigDecimal",-0.00235565],"quoteRate":["java.math.BigDecimal",0],"baseRate":["java.math.BigDecimal",0],"lastIndexPriceTime":1570873412919,"loanRate":["java.math.BigDecimal",0],"thirdPriceWeight":"BitStamp,25.00;GEMINI,25.00","nextFundTime":1570896000000}]
    ${toJson}   set variable
    设置Redis指定键值   ${alias}    ${name}      ${data}
    ${res}    yxhy_api调用    user_yj1    swap/account/sumFound
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${accb}    set variable    ${res['data']['accounts']['swap-usd-btc']['accb']}
    should be equal as strings    ${accb}       0


最高限价
    根据SQL进行查询   mysql       update p_perpetual.pp_assets set fixed_asset=0.1 where u_id=2195580
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
    ${ret_mysql}    根据SQL进行查询    mysql    select * from `p_perpetual`.`pp_contract_config`
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
    ${res}    yxhy_api调用    user_yj1    /swap/position/swap-usd-btc    ${none}    ${True}    ${None}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${hp}    set variable    ${res['data']['avgCostPrice']}
    ${vol}    set variable    ${res['data']['currentPosition']}
    ${side}    set variable    ${res['data']['side']}
    ${liquidationPrice1}    set variable    ${res['data']['liquidationPrice']}
    ${ret_mysql}    根据SQL进行查询    mysql    select * from `p_perpetual`.`pp_contract_config`
    ${r}    set variable    ${ret_mysql[0]['fee_rate_taker']}
    ${imr}    set variable    ${ret_mysql[0]['init_margins']}
    ${mmr}    set variable    ${ret_mysql[0]['maintenance_margins']}
    ${s}    set variable    ${ret_mysql[0]['unit_quantity']}
    ${res1}    yxhy_api调用    user_yj1    /swap/account/swap-usd-btc
    ${code1}    set variable    ${res1['code']}
    should be equal as strings    ${code1}    200
    ${accb}    set variable    ${res1['data']['accb']}
    ${cal_liqp}    计算强平价格    ${hp}   ${r}    ${accb}    ${vol}    ${imr}    ${mmr}    ${s}    ${side}
    ${result}    浮点数比较    ${liquidationPrice1}    ${cal_liqp}    ${0.01}
    should be true    ${result}
    should not be equal  ${liquidationPrice1}   ${liquidationPrice}


用户强制平仓后的账户余额情况
    ${res}    yxhy_api调用    user_yj1    /swap/position/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${liquidationPrice}    set variable    ${res['data']['liquidationPrice']}
    ${alias}    set variable    redis
    ${name}        set variable        perpetual:swap-usd-btc_flag_price
    ${data}        set variable       ["com.bitforex.perpetual.service.orderservice.vo.FlagPrice",{"symbol":"swap-usd-btc","fundRate":["java.math.BigDecimal",-0.003],"indexPrice":["java.math.BigDecimal",8356.79],"current":["java.math.BigDecimal",${liquidationPrice}-10],"flagPriceDiff":["java.math.BigDecimal",-19.69],"flagPriceDiffRate":["java.math.BigDecimal",-0.00235565],"quoteRate":["java.math.BigDecimal",0],"baseRate":["java.math.BigDecimal",0],"lastIndexPriceTime":1570873412919,"loanRate":["java.math.BigDecimal",0],"thirdPriceWeight":"BitStamp,25.00;GEMINI,25.00","nextFundTime":1570896000000}]
    ${toJson}   set variable
    设置Redis指定键值   ${alias}    ${name}      ${data}
    ${res}    yxhy_api调用    user_yj1    swap/account/sumFound
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${accb}    set variable    ${res['data']['accb']}
    should be equal as strings    ${accb}       0
    ${res}    yxhy_api调用    user_yj1     /swap/account/swap-usd-btc
    ${code}    set variable    ${res['code']}
    log    ${res['code']}

    ${equity}       set variable    ${res['data']['equity']}
    ${accb}       set variable    ${res['data']['accb']}
    ${breakevened}       set variable    ${res['data']['breakevened']}
    ${frozen}       set variable    ${res['data']['frozen']}
    ${positionMargin}       set variable    ${res['data']['positionMargin']}
    ${availableBalance}       set variable    ${res['data']['availableBalance']}
    ${canWithdrawAmount}       set variable    ${res['data']['canWithdrawAmount']}
    should be equal  ${equity}  0
    should be equal  ${accb}  0
    should be equal  ${breakevened}  0
    should be equal  ${frozen}  0
    should be equal  ${positionMargin}  0
    should be equal  ${availableBalance}  0
    should be equal  ${canWithdrawAmount}  0

当价格临近强平价格时候，反向平仓，查看用户账户情况
    ${res}    yxhy_api调用    user_yj1    /swap/position/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${liquidationPrice}    set variable    ${res['data']['liquidationPrice']}
    ${alias}    set variable    redis
    ${name}        set variable        perpetual:swap-usd-btc_flag_price
    ${data}        set variable       ["com.bitforex.perpetual.service.orderservice.vo.FlagPrice",{"symbol":"swap-usd-btc","fundRate":["java.math.BigDecimal",-0.003],"indexPrice":["java.math.BigDecimal",8356.79],"current":["java.math.BigDecimal",${liquidationPrice}-10],"flagPriceDiff":["java.math.BigDecimal",-19.69],"flagPriceDiffRate":["java.math.BigDecimal",-0.00235565],"quoteRate":["java.math.BigDecimal",0],"baseRate":["java.math.BigDecimal",0],"lastIndexPriceTime":1570873412919,"loanRate":["java.math.BigDecimal",0],"thirdPriceWeight":"BitStamp,25.00;GEMINI,25.00","nextFundTime":1570896000000}]
    ${toJson}   set variable
    设置Redis指定键值   ${alias}    ${name}      ${data}
    ${res}    yxhy_api调用    user_yj1    swap/account/sumFound
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${accb}    set variable    ${res['data']['accb']}
    should not be equal  {accb}       0
强平后是否还能下单
    ${res}    yxhy_api调用    user_yj1    /swap/position/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${liquidationPrice}    set variable    ${res['data']['liquidationPrice']}
    ${alias}    set variable    redis
    ${name}        set variable        perpetual:swap-usd-btc_flag_price
    ${data}        set variable       ["com.bitforex.perpetual.service.orderservice.vo.FlagPrice",{"symbol":"swap-usd-btc","fundRate":["java.math.BigDecimal",-0.003],"indexPrice":["java.math.BigDecimal",8356.79],"current":["java.math.BigDecimal",${liquidationPrice}-10],"flagPriceDiff":["java.math.BigDecimal",-19.69],"flagPriceDiffRate":["java.math.BigDecimal",-0.00235565],"quoteRate":["java.math.BigDecimal",0],"baseRate":["java.math.BigDecimal",0],"lastIndexPriceTime":1570873412919,"loanRate":["java.math.BigDecimal",0],"thirdPriceWeight":"BitStamp,25.00;GEMINI,25.00","nextFundTime":1570896000000}]
    ${toJson}   set variable
    设置Redis指定键值   ${alias}    ${name}      ${data}
    ${res}    yxhy_api调用    user_yj1    swap/account/sumFound
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${accb}    set variable    ${res['data']['accb']}
    should be equal as strings    ${accb}       0
    ${res}  根据买一价卖一价下单
    should be equal  ${res['data']}  '保证金不足'








