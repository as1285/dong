*** Settings ***
Resource          ../../keywords/bitforex/yxhy.robot
#Resource          ../../keywords/bitforex/calc.robot
#Resource          ../../keywords/basic/mysql.robot
#Resource          ../../keywords/basic/util.robot
Library           DateTime

*** Test Cases ***
临时活动接口
    log    --loglevel DEBUG:DEBUG
    ${symbol}    set variable    swap-usd-btc
    ${res}    yxhy_api调用    user_yj1    swap/tempActivity/confirm/   symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
登录时是否需要弹窗
    ${res}    yxhy_api调用    user_yj1    swap/tempActivity/loginPopup
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
交易对是否需要弹窗
    ${symbol}    set variable    swap-usd-btc
    ${res}    yxhy_api调用    user_yj1    swap/tempActivity/popup/   symbol=${symbol}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200