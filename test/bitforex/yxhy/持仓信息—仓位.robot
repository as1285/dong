*** Settings ***
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Library             DateTime

*** Test Cases ***
持仓反向的委托是否优先平仓
    ${res}    与持仓反向的委托是否优先平仓
    should be true  ${res}
    log  ${res}

仓位数量是否正确
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${vol1}    set variable    ${res['data']['currentPosition']}
    ${orderQty}      set variable    ${200}
    ${price}    set variable            ${10378}
    ${res}    下单传参数     1        ${orderQty}     ${price}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    should be true  ${res}
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${vol2}    set variable    ${res['data']['currentPosition']}
    should be true      ${vol1}+${orderQty}=${vol2}
仓位价值是否计算正确
    ${res}    仓位价值
    should be true      ${res}
开仓均价是否正确
    ${orderQty1}      set variable    ${200}
    ${price1}    set variable            ${10378}
    ${res}    下单传参数     1     ${orderQty1}     ${price1}
    ${code}    set variable    ${res['code']}
    ${orderQty2}      set variable    ${200}
    ${price2}    set variable            ${10378}
    ${res}    下单传参数     1      ${orderQty2}     ${price2}
    ${code}    set variable    ${res['code']}
    ${orderQty3}      set variable    ${200}
    ${price3}    set variable            ${10378}
    ${res}    下单传参数    1       ${orderQty3}     ${price3}
    ${code}    set variable    ${res['code']}
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200

    ${avgCostPrice}  set variable    ${res['data']['avgCostPrice']}
    should be true   ${avgCostPrice}=(${orderQty1}*${price1}+${orderQty2}*${price2}+${orderQty3}*${price3})/(${orderQty1}+${orderQty2}+${orderQty3})
标记价格是否计算正确
    ${res}    标记价格的计算比较
    should be true  ${res}
保证金是否计算正确
    ${res}    仓位保证金
    should be true  ${res}
    ${res}    委托保证金的计算
    should be true  ${res}
    ${res}    保证金率无需传参
    should be true  ${res}
    log      ${res}
未实现盈亏
    ${res}    yxhy_api调用    user_yj1    /swap/position/swap-usd-btc    ${none}    ${True}    ${None}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${hp}    set variable    ${res['data']['avgCostPrice']}
    ${vol}    set variable    ${res['data']['currentPosition']}
    ${side}    set variable    ${res['data']['side']}
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/commonInfo/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${FP}       set variable    ${res['data']['flagPrice']}
    ${side}    ${vol}      ${hp}     ${FP}
    ${res}    计算未实现盈亏   ${side}    ${vol}      ${hp}     ${FP}
    should be true  ${res}
    ${res1}    未实现盈亏的计算比较不传参数
    should be equal         ${res}      ${res1}

回报率是否计算正确
    ${res}    回报率
    should be true  ${res}

委托数量是否正确
    ${orderQty}      set variable    ${200}
    ${price}    set variable            ${10378}
    ${res}    下单传参数     1       ${orderQty}     ${price}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    委托数量
    should be equal  ${res}     ${orderQty}
委托价格是否正确
    ${orderQty}      set variable    ${200}
    ${price}    set variable            ${10378}
    ${res}    下单传参数     1        ${orderQty}     ${price}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1    contract/swap/order/list/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${price1}       set variable    ${res['data']["pageData"][0]['price']}
    should be equal  ${price}      ${price1}
成交数量是否正确
    ${orderQty}      set variable    ${200}
    ${price}    set variable            ${10378}
    ${res}    下单传参数     1       ${orderQty}     ${price}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1    contract/swap/order/list/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${volume}       set variable    ${res['data']["pageData"][0]['volume']}
    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/trade/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${dealVolume}       set variable    ${res['data']["pageData"][0]['dealVolume']}
    should be true  ${orderQty}=${dealVolume} + ${volume}
全部撤单是否成功
     ${res}    批量撤单
     ${code}    set variable    ${res['code']}
     should be equal as strings    ${code}    200
成交价格是否显示正确
    ${orderQty}      set variable    ${200}
    ${price}    set variable            ${10378}
    ${res}    下单传参数     ${side}        ${orderQty}     ${price}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/trade/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${price1}       set variable    ${res['data']["pageData"][0]['price']}
    should be true  ${price}    =   ${price1}
用户加仓后保证金是否增加

    ${symbol}    set variable       swap-usd-btc
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/    symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${orderQty}      set variable    ${200}
    ${price}    set variable            获取指数价格
    ${margin}       set variable    ${res['data']['margin']}
    ${res}          下单传参数     1      ${price}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200

    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/    symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${margin1}       set variable    ${res['data']['margin']}
    should be true  ${margin1} >${margin}

反向开仓数量大于现有仓位
    ${symbol}       set variable    swap-usd-btc
    ${side}       set variable    ${1}
    ${orderQty}      set variable    ${10}
    ${price}    set variable            获取指数价格
    ${res}        下单传参数     ${side}  ${orderQty}         ${price}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/    symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${currentPosition}       set variable    ${res['data']['currentPosition']}
    ${avgCostPrice}       set variable    ${res['data']['avgCostPrice']}
    ${side}       set variable    ${res['data']['side']}
    should be equal   ${side}  1
    should be equal   ${avgCostPrice} ${price}
    should be equal  ${orderQty}    ${currentPosition}
    ${side}       set variable    ${2}
    ${orderQty1}      set variable    ${20}
    ${price}    set variable            获取指数价格
    ${res}        下单传参数     ${side}  ${orderQty1}         ${price}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/    symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${currentPosition}       set variable    ${res['data']['currentPosition']}
    ${avgCostPrice}       set variable    ${res['data']['avgCostPrice']}
    ${side}       set variable    ${res['data']['side']}
    should be equal   ${side}  2
    should be equal   ${avgCostPrice} ${price}
    should be true  ${orderQty1} - ${orderQty}=  ${currentPosition}
反向开仓数量少于于现有仓位
    ${symbol}       set variable    swap-usd-btc
    ${side}       set variable    ${1}
    ${orderQty}      set variable    ${10}
    ${price}    set variable            获取指数价格
    ${res}        下单传参数     ${side}  ${orderQty}         ${price}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/    symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${currentPosition}       set variable    ${res['data']['currentPosition']}
    ${avgCostPrice}       set variable    ${res['data']['avgCostPrice']}
    ${side}       set variable    ${res['data']['side']}
    should be equal   ${side}  1
    should be equal   ${avgCostPrice} ${price}
    should be equal  ${orderQty}    ${currentPosition}
    ${side}       set variable    ${2}
    ${orderQty1}      set variable    ${5}
    ${price}    set variable            获取指数价格
    ${res}        下单传参数     ${side}  ${orderQty1}         ${price}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/    symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${currentPosition}       set variable    ${res['data']['currentPosition']}
    ${avgCostPrice}       set variable    ${res['data']['avgCostPrice']}
    ${side}       set variable    ${res['data']['side']}
    should be equal   ${side}  1
    should be equal   ${avgCostPrice} ${price}
    should be true  ${orderQty} -${orderQty1}=  ${currentPosition}
[setup]  账号初始化，增币
买一价购买数量比较大的张数
    ${symbol}       set variable    swap-usd-btc
    ${orderQty}     set variable    100000
    ${res}       根据买一价卖一价下单    1     ${orderQty}    ${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${orderid}    set variable    ${res['data']}
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/    symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${currentPosition}       set variable    ${res['data']['currentPosition']}
    ${avgCostPrice}       set variable    ${res['data']['avgCostPrice']}
    ${side}       set variable    ${res['data']['side']}
    should be equal   ${side}  1
    SHOULD BE EQUAL  ${currentPosition} 10000
    ${user_id}    获取user_id    user_yj1      select * from pp_order_btcusdt	 where 	uid=2195580
    ${ret_mysql}    根据SQL进行查询   mysql    select * from `p_perpetual`.`pp_order_btcusdt` where where uid=2195580 and id = ${orderid}'
    ${volume}    set variable    ${ret_mysql[0]['volume']}
    ${deal_volume}    set variable    ${ret_mysql[0]['deal_volume']}
    should be true  ${deal_volume} +${volume}=${orderQty}

买一价挂大数量的订单只成交了一部分验证仓位数量和委托数量的关系
    ${symbol}       set variable    swap-usd-btc
    ${orderQty}     set variable    100000
    ${res}       根据买一价卖一价下单    1     ${orderQty}    ${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${orderid}    set variable    ${res['data']}
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/    symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${currentPosition}       set variable    ${res['data']['currentPosition']}
    ${side}       set variable    ${res['data']['side']}
    should be equal   ${side}  1
    ${user_id}    获取user_id    user_yj1      select * from pp_order_btcusdt	 where 	uid=2195580
    ${ret_mysql}    根据SQL进行查询   mysql    select * from `p_perpetual`.`pp_order_btcusdt` where where uid=2195580 and id = ${orderid}'
    ${volume}    set variable    ${ret_mysql[0]['volume']}
    ${deal_volume}    set variable    ${ret_mysql[0]['deal_volume']}
    should be true  ${deal_volume} +${volume}=${orderQty}





















