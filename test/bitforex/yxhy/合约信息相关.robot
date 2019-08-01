*** Settings ***
Resource          ../../keywords/bitforex/yxhy.robot
Resource          ../../keywords/bitforex/calc.robot
Resource          ../../keywords/basic/mysql.robot
Resource          ../../keywords/basic/redis.robot
Resource          ../../keywords/basic/util.robot
Library           DateTime

*** Test Cases ***
账户信息
    ${res}    yxhy_api调用    user_yj1    /swap/account/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${accb}    set variable    ${res['data']['accb']}
    ${breakevened}    set variable    ${res['data']['breakevened']}
    ${frozen}    set variable    ${res['data']['frozen']}
    ${positionMargin}    set variable    ${res['data']['positionMargin']}
    ${user_id}    获取user_id    user_yj1
    ${ret_mysql}    执行指定SQL语句并获取字典形式结果    mysql    select * from `p_perpetual`.`pp_assets` where u_id='${user_id}' and contract_id='10002'
    ${realised_pnl}    set variable    ${ret_mysql[0]['realised_pnl']}
    ${position_margin}    set variable    ${ret_mysql[0]['position_margin']}
    ${frozen_margin}    set variable    ${ret_mysql[0]['frozen_margin']}
    ${fixed_asset}    set variable    ${ret_mysql[0]['fixed_asset']}
    ${result}    浮点数比较    ${accb}    ${fixed_asset}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${positionMargin}    ${position_margin}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${frozen}    ${frozen_margin}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${breakevened}    ${realised_pnl}    ${0.00001}
    should be true    ${result}

合约公共信息
    ${res}    yxhy_api调用    user_yj1    /swap/contract/commonInfo/swap-usd-btc
    should be equal as strings    ${res['code']}    200
    #    {'data': {'symbol': 'swap-usd-btc', 'indexPrice': '11449.85', 'flagPrice': '11172.00', 'fundRate': '-0.003', 'nextFundTime': 1562587200000, 'loanRate': 0.0001, 'thirdPriceWeight': 'GEMINI,33.34;Kraken,33.33;BitStamp,33.33'}, 'code': '200', 'message': '成功'}

合约信息列表
    ${res}    yxhy_api调用    user_yj1    /swap/contract/list
    should be equal as strings    ${res['code']}    200

合约信息明细
    ${res}    yxhy_api调用    user_yj1    /swap/contract/contractDetail/swap-usd-btc
    should be equal as strings    ${res['code']}    200
    ${ret_mysql}    执行指定SQL语句并获取字典形式结果    mysql    select * from `p_perpetual`.`pp_contract_config` where symbol='swap-usd-btc'
    should be equal as strings    ${res['data']['symbol']}    ${ret_mysql[0]['symbol']}
    should be equal as strings    ${res['data']['endDate']}    永续
    should be equal as strings    ${res['data']['baseSymbol']}    ${ret_mysql[0]['base_symbol']}
    should be equal as strings    ${res['data']['priceSymbol']}    ${ret_mysql[0]['quote_symbol']}
    should be equal as strings    ${res['data']['premiumSymbol']}    ${ret_mysql[0]['fund_preminum_symbol']}
    #    should be equal as strings    ${res['data']['fundRate']}    ${ret_mysql[0]['quote_symbol']}    #资金费率
    #    should be equal as strings    ${res['data']['nextFundRateTime']}    ${ret_mysql[0]['fund_period']}
    #    should be equal as strings    ${res['data']['isAutoReduce']}    ${ret_mysql[0]['is_auto_reduce']}    #返回的事bool类型,数据库中的是0/1
    #    should be equal as strings    ${res['data']['notBalanceNum']}    ${ret_mysql[0]['fund_preminum_symbol']} #未平仓合约数
    should be equal as strings    ${res['data']['contractType']}    ${ret_mysql[0]['contract_type']}
    should be equal as strings    ${res['data']['pricePrecision']}    ${ret_mysql[0]['price_precision']}
    should be equal as strings    ${res['data']['basePrecision']}    ${ret_mysql[0]['base_precision']}
    should be equal as strings    ${res['data']['priceOrderPrecision']}    ${ret_mysql[0]['price_order_precision']}
    should be equal as strings    ${res['data']['baseShowPrecision']}    ${ret_mysql[0]['base_show_precision']}
    should be equal as strings    ${res['data']['deepJoinNum']}    ${ret_mysql[0]['deep_join_num']}
    ${result}    浮点数比较    ${res['data']['iniMargins']}    ${ret_mysql[0]['init_margins']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['maintenanceMargins']}    ${ret_mysql[0]['maintenance_margins']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['iniMargins']}    ${ret_mysql[0]['init_margins']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['fundRatePeriod']}    ${ret_mysql[0]['fund_period']}    ${0.00001}
    should be true    ${result}
    ##    ${result}    浮点数比较    ${res['data']['flagPrice']}    ${ret_mysql[0]['init_margins']}    ${0.00001}
    ${result}    浮点数比较    ${res['data']['limitQuota']}    ${ret_mysql[0]['limit_quota']}    ${0.00001}
    should be true    ${result}
    ##    ${result1}    浮点数比较    ${res['data']['contractFactor']}    ${ret_mysql[0]['fund_period']}    ${0.00001} #合约乘数
    ${result}    浮点数比较    ${res['data']['minChangePrice']}    ${ret_mysql[0]['min_change_price']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['maxUserVolume']}    ${ret_mysql[0]['max_user_volume']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['maxDelegateNum']}    ${ret_mysql[0]['max_order_volume']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['minDelegateNum']}    ${ret_mysql[0]['min_order_volume']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['feeRateTaker']}    ${ret_mysql[0]['fee_rate_taker']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['feeRateMaker']}    ${ret_mysql[0]['fee_rate_maker']}    ${0.00001}
    should be true    ${result}
    #    ${result}    浮点数比较    ${res['data']['baseLoanRate']}    ${ret_mysql[0]['min_order_volume']}    ${0.00001}
    #    should be true    ${result}
    #    ${result}    浮点数比较    ${res['data']['quotaLoanRate']}    ${ret_mysql[0]['min_order_volume']}    ${0.00001}
    #    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['openBuyLimitRateMax']}    ${ret_mysql[0]['open_buy_limit_rate_max']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['openSellLimitRateMax']}    ${ret_mysql[0]['open_sell_limit_rate_max']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['openBuyLimitRateMin']}    ${ret_mysql[0]['open_buy_limit_rate_min']}    ${0.00001}
    should be true    ${result}
    ${result}    浮点数比较    ${res['data']['openSellLimitRateMin']}    ${ret_mysql[0]['open_sell_limit_rate_min']}    ${0.00001}
    should be true    ${result}
    #    should be true    ${result}
