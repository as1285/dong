*** Settings ***
Resource          ../../keywords/bitforex/yxhy.robot
Resource          ../../keywords/bitforex/calc.robot
Resource          ../../keywords/basic/mysql.robot
Resource          ../../keywords/basic/redis.robot
Resource          ../../keywords/basic/util.robot
Library           DateTime

*** Test Cases ***
下买多单然后平空计算收益
    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/trade/swap-usd-btc
#    查询已成交的合约信息
    should be equal as strings    ${res['code']}    200
    ${orderId}    set variable    ${res['data']['pageData'][0]['entrustId']}
    ${future}    set variable       ${0}
    ${orderQty}    set variable    ${res['data']['pageData'][0]['dealVolume']}
    ${price}      Evaluate  int(${res['data']['pageData'][0]['dealPrice']})
    ${side}    set variable    ${res['data']['pageData'][0]['side']}
    ${source}    set variable    1
    ${symbol}    set variable    ${res['data']['pageData'][0]['symbol']}
    ${type}    set variable    ${1}
    ${shouxufee}    set variable    ${res['data']['pageData'][0]['fee']}
    ${res}    yxhy_api调用    user_yj1    /swap/order    method=post    future=${future}    orderQty=${orderQty}    price=${price}    side=${side}    source=${source}    symbol=${symbol}    type=${type}
    #买多
    should be equal as strings    ${res['code']}    200
    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/trade/swap-usd-btc
    #    查询已成交的合约信息
    should be equal as strings    ${res['code']}    200
    ${orderId}    set variable    ${res['data']}
    ${side}    set variable    ${2}
    ${type}     set variable    ${1}
    ${orderQty}     set variable    ${1}
   #买多平仓（卖出方向）
    ${res}    yxhy_api调用    user_yj1    /swap/order    method=post    orderQty=${orderQty}      side=${side}     price=${price}     symbol=${symbol}    type=${type}
    should be equal as strings    ${res['code']}    200

    ${res}    yxhy_api调用    user_yj1    /contract/swap/order/list/swap-usd-btc
    #查看当前的委托列表
    should be equal as strings    ${res['code']}    200
    #查看仓位接口
    ${res}    yxhy_api调用    user_yj1    /contract/swap/position/swap-usd-btc
    should be equal as strings    ${res['code']}    200
    #avgCostPrice  开仓均价
    ${avgCostPrice}    set variable    ${res['data']['avgCostPrice']}
    #currentPosition  仓位数量
    ${currentPosition}    set variable    ${res['data']['currentPosition']}
    #markPrice  标记价格
    ${markPrice}    set variable    ${res['data']['markPrice']}
    #margin 保证金
    ${margin}    set variable    ${res['data']['margin']}
    #liquidationPrice 强平价格
    ${liquidationPrice}    set variable    ${res['data']['liquidationPrice']}
    #realizedPnl 已实现盈亏
    ${realizedPnl}    set variable    ${res['data']['realizedPnl']}


#账户信息
#    ${res}    yxhy_api调用    user_yj1    /swap/account/swap-usd-btc
#    ${code}    set variable    ${res['code']}
#    should be equal as strings    ${code}    200
#    #账户权益
#    ${accb}    set variable    ${res['data']['accb']}
#    #已实现盈亏
#    ${breakevened}    set variable    ${res['data']['breakevened']}
#    #委托保证金
#    ${frozen}    set variable    ${res['data']['frozen']}
#    #仓位保证金
#    ${positionMargin}    set variable    ${res['data']['positionMargin']}
#    #availableBalance 可用余额
#    ${availableBalance}    set variable    ${res['data']['availableBalance']}
#    #风险率 = (维持保证金 / 账户权益) * 100%
#    ${user_id}    获取user_id    user_yj1
#    ${ret_mysql}    执行指定SQL语句并获取字典形式结果    mysql    select * from `p_perpetual`.`pp_assets` where u_id='${user_id}' and contract_id='10002'
#    ${realised_pnl}    set variable    ${ret_mysql[0]['realised_pnl']}
#    ${position_margin}    set variable    ${ret_mysql[0]['position_margin']}
#    ${frozen_margin}    set variable    ${ret_mysql[0]['frozen_margin']}
#    ${fixed_asset}    set variable    ${ret_mysql[0]['fixed_asset']}
#    ${result}    浮点数比较    ${accb}    ${fixed_asset}    ${0.00001}
#    should be true    ${result}
#    ${result}    浮点数比较    ${positionMargin}    ${position_margin}    ${0.00001}
#    should be true    ${result}
#    ${result}    浮点数比较    ${frozen}    ${frozen_margin}    ${0.00001}
#    should be true    ${result}
#    ${result}    浮点数比较    ${breakevened}    ${realised_pnl}    ${0.00001}
#    should be true    ${result}





