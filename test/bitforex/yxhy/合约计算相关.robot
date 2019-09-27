*** Settings ***
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Library             DateTime

*** Test Cases ***
强平价格
    log  --loglevel DEBUG:DEBUG
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
    log  --loglevel DEBUG:DEBUG
