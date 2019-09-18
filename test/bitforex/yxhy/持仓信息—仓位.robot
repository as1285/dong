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
    ${res}    下买单传参数        ${orderQty}     ${price}
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
    ${res}    下买单传参数        ${orderQty1}     ${price1}
    ${code}    set variable    ${res['code']}
    ${orderQty2}      set variable    ${200}
    ${price2}    set variable            ${10378}
    ${res}    下买单传参数        ${orderQty2}     ${price2}
    ${code}    set variable    ${res['code']}
    ${orderQty3}      set variable    ${200}
    ${price3}    set variable            ${10378}
    ${res}    下买单传参数        ${orderQty3}     ${price3}
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
    ${res}    下买单传参数        ${orderQty}     ${price}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    委托数量
    should be equal  ${res}     ${orderQty}
委托价格是否正确
    ${orderQty}      set variable    ${200}
    ${price}    set variable            ${10378}
    ${res}    下买单传参数        ${orderQty}     ${price}
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
    ${res}    下买单传参数        ${orderQty}     ${price}
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
    ${res}    下买单传参数        ${orderQty}     ${price}
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/trade/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${price1}       set variable    ${res['data']["pageData"][0]['price']}
    should be true  ${price}    =   ${price1}








