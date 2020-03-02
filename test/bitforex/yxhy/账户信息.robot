*** Settings ***
Resource          ../../keywords/bitforex/yxhy.robot
Resource          ../../keywords/bitforex/calc.robot
Resource          ../../keywords/basic/mysql.robot
Resource          ../../keywords/basic/redis.robot
Resource          ../../keywords/basic/util.robot
Library           DateTime

*** Test Cases ***
账户信息1
    ${res}    yxhy_api调用    user_yj1       /contract/swap/account/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${accb}    set variable    ${res['data']['accb']}
    ${breakevened}    set variable    ${res['data']['breakevened']}
    ${frozen}    set variable    ${res['data']['frozen']}
    ${positionMargin}    set variable    ${res['data']['positionMargin']}
    ${user_id}    获取user_id    user_yj1
    ${ret_mysql}    根据SQL进行查询    mysql    select * from `p_perpetual`.`pp_assets` where u_id='${user_id}' and contract_id='10002'
    ${realised_pnl}    set variable    ${ret_mysql[0]['realised_pnl']}
    ${position_margin}    set variable    ${ret_mysql[0]['position_margin']}
    ${frozen_margin}    set variable    ${ret_mysql[0]['frozen_margin']}
    ${fixed_asset}    set variable    ${ret_mysql[0]['fixed_asset']}
    ${result}    浮点数比较       ${accb}      ${fixed_asset}    1
    should be true    ${result}
    ${result}    浮点数比较    ${positionMargin}    ${position_margin}    ${0.0001}
    should be true    ${result}
    ${result}    浮点数比较    ${frozen}    ${frozen_margin}    ${0.0001}
    should be true    ${result}
    ${result}    浮点数比较    ${breakevened}    ${realised_pnl}    ${0.0001}
    should be true    ${result}

我的资产-合约账户资产划转（金额等于可用余额）
    ${res}    yxhy_api调用    user_yj1    /contract/swap/account/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${accb}    set variable    ${res['data']['accb']}
    ${breakevened}    set variable    ${res['data']['breakevened']}
    ${frozen}    set variable    ${res['data']['frozen']}
    ${positionMargin}    set variable    ${res['data']['positionMargin']}
    ${availableBalance}    set variable    ${res['data']['availableBalance']}
    ${res}    yxhy_api调用    user_yj1    contract/swap/account/transfer?symbol=swap-usd-btc&number=${availableBalance}&type=transferPerpetualOutTradeIn
    ${code}    set variable    ${res['code']}
    ${message}    set variable    ${res['message']}
    should be equal as strings    ${code}    200
    should be equal as strings    ${message}    '成功'
    ${res}    yxhy_api调用    user_yj1    /contract/swap/account/swap-usd-btc
    ${availableBalance}    set variable    ${res['data']['availableBalance']}
    should be equal     ${availableBalance}     0

我的资产-合约账户资产划转（金额大于可用余额）
    ${res}    yxhy_api调用    user_yj1    /contract/swap/account/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${accb}    set variable    ${res['data']['accb']}
    ${breakevened}    set variable    ${res['data']['breakevened']}
    ${frozen}    set variable    ${res['data']['frozen']}
    ${positionMargin}    set variable    ${res['data']['positionMargin']}
    ${availableBalance}    set variable    ${res['data']['availableBalance']}+1
    ${res}    yxhy_api调用    user_yj1      contract/swap/account/transfer?symbol=swap-usd-btc&number=${availableBalance}&type=transferPerpetualOutTradeIn
    ${code}    set variable    ${res['code']}
    ${message}    set variable    ${res['message']}
    should be equal as strings    ${code}    200
    should be equal as strings    ${message}    '余额不足'
    ${res}    yxhy_api调用    user_yj1    /contract/swap/account/swap-usd-btc
    ${availableBalance1}    set variable    ${res['data']['availableBalance']}
    should be equal     ${availableBalance}         ${availableBalance1}


我的资产-合约账户资产划转（金额小于可用余额）
    ${res}    yxhy_api调用    user_yj1    /contract/swap/account/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200

    ${availableBalance}    set variable    ${res['data']['availableBalance']}/2
    ${res}    yxhy_api调用    user_yj1      contract/swap/account/transfer?symbol=swap-usd-btc&number=${availableBalance}&type=transferPerpetualOutTradeIn
    ${code}    set variable    ${res['code']}
    ${message}    set variable    ${res['message']}
    should be equal as strings    ${code}    200
    should be equal as strings    ${message}    '成功'

我的资产-合约账户资产划转（输入为0和负数余额）
    ${res}    yxhy_api调用    user_yj1      contract/swap/account/transfer?symbol=swap-usd-btc&number=0&type=transferPerpetualOutTradeIn
    ${code}    set variable    ${res['code']}
    ${message}    set variable    ${res['message']}
    should be equal as strings    ${code}    200
    should be equal as strings    ${message}    '金额非法'
    ${res}    yxhy_api调用    user_yj1      contract/swap/account/transfer?symbol=swap-usd-btc&number=-10&type=transferPerpetualOutTradeIn
    ${code}    set variable    ${res['code']}
    ${message}    set variable    ${res['message']}
    should be equal as strings    ${code}    200
    should be equal as strings    ${message}    '金额非法'


我的资产-合约账户资产划转（划转所有的合约币种的可用余额到币币）
    ${res}      yxhy_api调用    user_yj1        /contract/swap/contract/listAll
    Log To Console      ${res['data']}
    ${data}    set variable     ${res['data']}
    Log To Console      ${data}
    ${length}        get length     ${data}
    :FOR    ${i}   IN RANGE  ${length}
    \   ${symbol}    set variable    ${data}[${i}][symbol]
    \   ${res}    yxhy_api调用    user_yj1    /contract/swap/account/${symbol}
    \   ${availableBalance}    set variable    ${res['data']['availableBalance']}
    \   ${res}    yxhy_api调用    user_yj1      contract/swap/account/transfer?symbol=${symbol}&number=${availableBalance}&type=transferPerpetualOutTradeIn
    \   ${message}    set variable    ${res['message']}
    \   should be equal as strings    ${message}    '成功'
    \   ${res}    yxhy_api调用    user_yj1    /contract/swap/account/${symbol}
    \   ${availableBalance}    set variable    ${res['data']['availableBalance']}
    \   should be equal     ${availableBalance}     0

我的资产-合约账户资产划转（划转所有的合约币种的可用余额到钱包）
    ${res}      yxhy_api调用    user_yj1        /contract/swap/contract/listAll
    Log To Console      ${res['data']}
    ${data}    set variable     ${res['data']}
    Log To Console      ${data}
    ${length}        get length     ${data}
    :FOR    ${i}   IN RANGE  ${length}
    \   ${symbol}    set variable    ${data}[${i}][symbol]
    \   ${res}    yxhy_api调用    user_yj1    /contract/swap/account/${symbol}
    \   ${availableBalance}    set variable    ${res['data']['availableBalance']}
    \   ${res}    yxhy_api调用    user_yj1      contract/swap/account/transfer?symbol=${symbol}&number=${availableBalance}&type=transferIn
    \   ${message}    set variable    ${res['message']}
    \   should be equal as strings    ${message}    '成功'
    \   ${res}    yxhy_api调用    user_yj1    /contract/swap/account/${symbol}
    \   ${availableBalance}    set variable    ${res['data']['availableBalance']}
    \   should be equal     ${availableBalance}     0


我的资产-合约账户资产划转（划转所有的合约币种的可用余额到钱包）
    ${res}      yxhy_api调用    user_yj1        /contract/swap/contract/listAll
    Log To Console      ${res['data']}
    ${data}    set variable     ${res['data']}
    Log To Console      ${data}
    ${length}        get length     ${data}
    :FOR    ${i}   IN RANGE  ${length}
    \   ${symbol}    set variable    ${data}[${i}][symbol]
    \   ${res}    yxhy_api调用    user_yj1    /contract/swap/account/${symbol}
    \   ${availableBalance}    set variable    ${res['data']['availableBalance']}
    \   ${res}    yxhy_api调用    user_yj1      contract/swap/account/transfer?symbol=${symbol}&number=${availableBalance}&type=transferIn
    \   ${message}    set variable    ${res['message']}
    \   should be equal as strings    ${message}    '成功'
    \   ${res}    yxhy_api调用    user_yj1    /contract/swap/account/${symbol}
    \   ${availableBalance}    set variable    ${res['data']['availableBalance']}
    \   should be equal     ${availableBalance}     0

