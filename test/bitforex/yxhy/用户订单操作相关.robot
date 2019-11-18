*** Settings ***
Resource          ../../keywords/bitforex/yxhy.robot
Resource          ../../keywords/bitforex/calc.robot
Resource          ../../keywords/basic/mysql.robot
Resource          ../../keywords/basic/redis.robot
Resource          ../../keywords/basic/util.robot
Library           DateTime

*** Test Cases ***
下买单-撤单
    ${res}      yxhy_api调用    user_yj1        /contract/swap/contract/listAll
    Log To Console      ${res['data']}
    ${data}    set variable     ${res['data']}
    Log To Console      ${data}
    ${length}        get length     ${data}
    :FOR    ${i}   IN RANGE  ${length}
    \   ${symbol}    set variable    ${data}[${i}][symbol]
    \   ${res}     根据买一价卖一价下单     1    123    ${data}[${i}][symbol]
    \   ${code}    set variable    ${res['code']}
    \   log    ${res['code']}
    \   should be equal as strings    ${code}    200
    \   ${res}    yxhy_api调用    user_yj1    /contract/swap/order/all   method=delete     symbol=${symbol}    source=1
    \   ${code}    set variable    ${res['code']}
    \   log    ${res['code']}
    \   should be equal as strings    ${code}    200
    \   ${res}    yxhy_api调用    user_yj1    /contract/swap/order/list/${symbol}
    \   ${code}    set variable    ${res['code']}
    \   log    ${res['code']}
    \   should be equal as strings    ${code}    200

