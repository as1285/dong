*** Settings ***
Library           ../../../testlib/service/bitforex/BbService.py
Library           ../../../testlib/service/common/MysqlService.py


*** Keywords ***
bb_api调用
    [Arguments]    ${alias}    ${interface}    ${method}=${None}    ${need_session}=${True}    ${params}=${None}    &{data}
    [Documentation]    【功能】可用于api的各种接口调用
    ...
    ...
    ...    【参数】
    ...    interface: api路径 比如/server/user_account.act
    ...    need_session：是否需要登录,默认需要登录
    ...    params: api中url参数
    ...    data：api发送body
    ...
    ...
    ...
    ...    【返回值】
    ...    res：查询的结果
    ${is_success}    ${result}    bb_api    ${alias}    ${interface}    method=${method}    need_session=${need_session}
    ...    params=${params}    &{data}
    should be true    ${is_success}
    [Return]    ${result}

bb_获取参数
    [Arguments]    ${alias}    ${key}
    [Documentation]    【功能】获取env.json中key对应的值
    ...
    ...
    ...    【参数】
    ...    key: env.json中key
    ...
    ...
    ...
    ...    【返回值】
    ...    res：key对应的value
    ${res}    BbService.env_get    ${alias}    ${key}
    [Return]    ${res}

