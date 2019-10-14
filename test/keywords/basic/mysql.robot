*** Settings ***
Library           ../../../testlib/service/common/MysqlService.py

*** Keywords ***
Truncate数据表
    [Arguments]    ${alias}    ${table}
    [Documentation]    【功能】使用truncate table语句清空数据库表
    ...
    ...    【参数】
    ...    alias: mysql别名，也就env.json上对每个Mysql服务配置的id
    ...    table：表名
    ...
    ...
    ...
    ...
    ...    【返回值】
    ...    data: 执行sql语句的返回信息
    ${data}    MysqlService.truncate    ${alias}    ${table}
    [Return]    ${data}

刷新数据库表
    [Arguments]    ${alias}    ${sleep_seconds}=0
    [Documentation]    【功能】使用flush tables语句清空数据库表
    ...
    ...    【参数】
    ...    alias: mysql别名，也就env.json上对每个Mysql服务配置的id
    ...
    ...    sleepSeconds: flush之后的等待秒数
    ...
    ...
    ...    【返回值】
    ...    data: 执行sql语句的返回信息
    ${data}    MysqlService.flush_tables    ${alias}    ${sleep_seconds}
    [Return]    ${data}

执行指定SQL语句
    [Arguments]    ${alias}    ${sql}
    [Documentation]    【功能】执行指定SQL语句
    ...
    ...    【参数】
    ...    alias: mysql别名，也就env.json上对每个Mysql服务配置的id
    ...    sql: SQL 语句
    ...
    ...
    ...
    ...
    ...    【返回值】
    ...    data: 执行sql语句的返回信息
    ${data}    MysqlService.execute_sql    ${alias}     ${sql}
    [Return]    ${data}

根据SQL进行查询
    [Arguments]    ${alias}    ${sql}    ${todict}=${True}
    [Documentation]    【功能】执行指定SQL语句
    ...
    ...    【参数】
    ...    alias: mysql别名，也就env.json上对每个Mysql服务配置的id
    ...    sql: SQL 语句
    ...
    ...
    ...
    ...
    ...    【返回值】
    ...    data: 执行sql语句的返回信息
    ${data}    MysqlService.select_sql   ${alias}    ${sql}    ${todict}
    [Return]    ${data}

导入SQL文件
    [Arguments]    ${alias}    ${sqlFile}    ${db}=${None}
    [Documentation]    【功能】使用update更新数据
    ...
    ...    【参数】
    ...    alias: mysql别名，也就env.json上对每个Mysql服务配置的id
    ...    sqlFile:数据文件（全路径）
    ...    db：要导入的数据库名称
    ...
    ...
    ...    【返回值】
    ...    data: 执行source 语句的结果
    ${return}    MysqlService.source    ${alias}    ${sqlFile}    ${db}
    [Return]    ${return}

