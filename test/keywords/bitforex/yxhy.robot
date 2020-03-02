*** Settings ***
Library           ../../../testlib/service/bitforex/YxhyService.py
Library           ../../../testlib/service/common/MysqlService.py


*** Keywords ***
yxhy_api调用
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
    ${is_success}    ${result}    yxhy_api    ${alias}    ${interface}    method=${method}    need_session=${need_session}
    ...    params=${params}    &{data}
    should be true    ${is_success}
    [Return]    ${result}

yyhy_获取参数
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
    ${res}    env_get    ${alias}    ${key}
    [Return]    ${res}

获取user_id
    [Arguments]    ${alias}
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


    ${user}    yyhy_获取参数   ${alias}    user
    ${ret_mysql}    根据SQL进行查询    mysql    select user_id from `m_user`.`us_user_baseinfo` where email='${user}'
    ${user_id}    set variable    ${ret_mysql[0]['user_id']}
    [Return]    ${user_id}
获取用户资产
    [Arguments]    ${alias}
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


    ${user}    yyhy_获取参数   ${alias}    user
    ${ret_mysql}    根据SQL进行查询    mysql    select user_id from `m_user`.`us_user_baseinfo` where email='${user}'
    ${user_id}    set variable    ${ret_mysql[0]['user_id']}
    [Return]    ${user_id}
