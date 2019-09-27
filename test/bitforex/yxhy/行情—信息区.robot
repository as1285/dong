*** Settings ***
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Library             DateTime

*** Test Cases ***
指数价格-指数价格刷新时间间隔5秒钟刷新一次
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/commonInfo/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${indexPrice1}    set variable    ${res['data']['indexPrice']}

    sleep  6
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/commonInfo/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${indexPrice2}    set variable    ${res['data']['indexPrice']}
    should not be equal  ${indexPrice1}  ${indexPrice2}
标记价格的计算是否正确
    ${res}    标记价格的计算比较
    should be true  ${res}
动态数据-资金费率刷新时间
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/commonInfo/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${fundRate1}    set variable    ${res['data']['fundRate']}

    sleep  6
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/commonInfo/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${fundRate2}    set variable    ${res['data']['fundRate']}
    should not be equal  ${fundRate1}  ${fundRate2}
动态数据-下一个资金费用时间刷新时间
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/commonInfo/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${nextFundTime1}    set variable    ${res['data']['nextFundTime']}

    sleep  6
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/commonInfo/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${nextFundTime2}    set variable    ${res['data']['nextFundTime']}
    should not be equal  ${nextFundTime1}  ${nextFundTime2}

动态数据-标记价格刷新时间
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/commonInfo/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${flagPrice1}    set variable    ${res['data']['flagPrice1']}
    sleep  6
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/commonInfo/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${flagPrice2}    set variable    ${res['data']['flagPrice']}
    should not be equal  ${flagPrice1}  ${flagPrice2}
动态数据-未平仓合约数量（当前单边持仓量）刷新时间
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/contractDetail/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${notBalanceNum1}    set variable    ${res['data']['notBalanceNum']}
    sleep  6
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/contractDetail/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${notBalanceNum2}    set variable    ${res['data']['notBalanceNum']}
    should not be equal  ${notBalanceNum1}  ${notBalanceNum2}
动态数据-24小时营业额（动态24h，单边总成交名义价值）刷新时间
    ${res}    yxhy_api调用    user_yj1    /contract/mkapi/v2/tickers
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${productvol1}    set variable    ${res['data']["swap-usd-btc"]['productvol']}
    sleep  6
    ${res}    yxhy_api调用    user_yj1    /contract/mkapi/v2/tickers
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${productvol2}    set variable    ${res['data']["swap-usd-btc"]['productvol']}
    should not be equal  ${productvol1}  ${productvol2}
动态数据-总交易量（自合约增加以来一共交易的合约数量）刷新时间
    ${res}    yxhy_api调用    user_yj1    /contract/mkapi/v2/tickers
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${allVol1}    set variable    ${res['data']["swap-usd-btc"]['allVol']}
    sleep  6
    ${res}    yxhy_api调用    user_yj1    /contract/mkapi/v2/tickers
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${allVol2}    set variable    ${res['data']["swap-usd-btc"]['allVol']}
    should not be equal  ${allVol1}  ${allVol2}


