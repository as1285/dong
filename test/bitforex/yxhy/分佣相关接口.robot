*** Settings ***
Resource          ../../keywords/bitforex/yxhy.robot
#Resource          ../../keywords/bitforex/calc.robot
#Resource          ../../keywords/basic/mysql.robot
#Resource          ../../keywords/basic/util.robot
Library           DateTime

*** Test Cases ***
获取用户信息
    log    --loglevel DEBUG:DEBUG
    ${res}    yxhy_api调用    user_yj1    swap/commission/getChannelUser
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
获取统计汇总数据
    ${res}    yxhy_api调用    user_yj1    swap/commission/getUserStatistics
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
