*** Settings ***
Library           ../../../testlib/service/common/MysqlService.py

*** Keywords ***
查询指定表并获取数据
    [Arguments]    ${alias}    ${table}    ${keys}    ${conditions}=${None}    ${isdistinct}=${False}    ${todict}=${True}
    [Documentation]    【功能】使用select语句查询指定表格，并获取数据
    ...
    ...    【参数】
    ...    alias: mysql别名，也就env.json上对每个Mysql服务配置的id
    ...    table：表名
    ...    keys：字段名，list形式
    ...    condition：查询where条件，dict形式，and连接；或字符串形式
    ...    isdistinct: 查询结果是否去重
    ...    todict：查询结果是否应该转为dict形式，注：多个数据最终以list返回，每个item为dict形式
    ...
    ...
    ...    【返回值】
    ...    data: 执行select sql语句的查询结果
    ${data}    MysqlService.select    ${alias}    ${table}    ${keys}    ${conditions}    ${isdistinct}    ${todict}
    [Return]    ${data}

删除指定表数据
    [Arguments]    ${alias}    ${table}    ${conditions}
    [Documentation]    【功能】使用delete语句删除指定表格的指定数据
    ...
    ...    【参数】
    ...    alias: mysql别名，也就env.json上对每个Mysql服务配置的id
    ...    table：表名
    ...    condition：查询where条件，dict形式，and连接；或字符串形式
    ...
    ...
    ...
    ...    【返回值】
    ...    data: 执行sql语句的返回信息
    ${data}    MysqlService.delete    ${alias}    ${table}    ${conditions}
    [Return]    ${data}

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
    ${data}    MysqlService.execute_sql    ${alias}    ${sql}
    [Return]    ${data}

执行指定SQL语句并获取字典形式结果
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
    ${data}    MysqlService.execute_and_get_result    ${alias}    ${sql}    ${todict}
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

更新指定表中指定数据
    [Arguments]    ${alias}    ${table}    ${values}    ${conditions}
    [Documentation]    【功能】使用update更新数据
    ...
    ...    【参数】
    ...    alias: mysql别名，也就env.json上对每个Mysql服务配置的id
    ...    table：表名
    ...    values:需要更新的字段字典 如：{'id':'newId','number':'newNumber'}
    ...    condition：查询where条件，dict形式，and连接；或字符串形式
    ...
    ...
    ...    【返回值】
    ...    data: 执行update sql语句的结果
    ${return}    MysqlService.update    ${alias}    ${table}    ${values}    ${conditions}
    [Return]    ${return}

执行指定sql语句并获取结果
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
    ${data}    MysqlService.execute_and_get_result    ${alias}    ${sql}
    [Return]    ${data}
