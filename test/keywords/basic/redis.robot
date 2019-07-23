*** Settings ***
Library           ../../../testlib/service/common/RedisService.py

*** Keywords ***
清空Redis所有DB的数据
    [Arguments]    ${alias}
    [Documentation]    【功能】使用flush_all清空Redis数据库所有DB
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...
    ...    【返回值】
    ...    无
    RedisService.flush_all    ${alias}

清空Redis指定DB数据
    [Arguments]    ${alias}    ${db}=0
    [Documentation]    【功能】使用flush_db清空Redis数据库所有DB
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...
    ...    db： db编号
    ...
    ...    【返回值】
    ...    无
    RedisService.flush_db    ${alias}    ${db}

获取Redis键列表
    [Arguments]    ${alias}    ${keyParttern}=*    ${db}=0
    [Documentation]    【功能】使用keys命令获取满足键模式的键名
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    keyParttern：键模式
    ...    db： db编号
    ...
    ...    【返回值】
    ...    keys：满足键模式的键列表
    ${keys}    RedisService.keys    ${alias}    ${keyParttern}    ${db}
    [Return]    ${keys}

判断Redis是否包含键值
    [Arguments]    ${alias}    ${name}    ${db}=0
    [Documentation]    【功能】使用exists命令判断键名是否存在
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    name：键名
    ...    db： db编号
    ...
    ...    【返回值】
    ...    isExists：True， False
    ${isExists}    RedisService.exists    ${alias}    ${name}    ${db}
    [Return]    ${isExists}

获取Redis哈希键值指定域
    [Arguments]    ${alias}    ${name}    ${field}    ${db}=0    ${toDict}=${False}
    [Documentation]    【功能】使用hget命令获取Redis哈希键值指定域
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    name：键名
    ...    field: 域
    ...    db： db编号
    ...
    ...    【返回值】
    ...    value：域值
    ${value}    RedisService.hget    ${alias}    ${name}    ${field}    ${db}    ${toDict}
    [Return]    ${value}

获取Redis指定键值
    [Arguments]    ${alias}    ${name}    ${db}=0    ${toDict}=${False}
    [Documentation]    【功能】使用get命令获取Redis键值
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    name：键名
    ...    db： db编号
    ...    toDict: 使用json.loads字典化字符串
    ...
    ...    【返回值】
    ...    value：键值
    ${value}    RedisService.get    ${alias}    ${name}    ${db}    ${toDict}
    [Return]    ${value}

获取Redis哈希键值
    [Arguments]    ${alias}    ${name}    ${db}=0
    [Documentation]    【功能】使用hgetall命令获取Redis哈希键值
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    name：键名
    ...    db： db编号
    ...
    ...    【返回值】
    ...    value：键值
    ${value}    RedisService.hgetall    ${alias}    ${name}    ${db}
    [Return]    ${value}

获取Redis集合成员
    [Arguments]    ${alias}    ${name}    ${db}=0
    [Documentation]    【功能】使用smembers命令指定集合的成员
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    name：键名
    ...    db： db编号
    ...
    ...    【返回值】
    ...    members：集合成员
    ${members}    RedisService.smembers    ${alias}    ${name}    ${db}
    [Return]    ${members}

获取Redis有序集成元byscore
    [Arguments]    ${alias}    ${name}    ${min}=${None}    ${max}=${None}    ${start}=${None}    ${num}=${None}
    ...    ${withscores}=${True}    ${score_cast_func}=float    ${db}=0
    [Documentation]    【功能】使用zrangebyscore命令指定有序集合的满足条件成员
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    min: 默认为None，表示-inf
    ...    max: 默认为None， 表示+inf
    ...    返回有序集 key 中，所有 score 值介于 min 和 max 之间(包括等于 min 或 max )的成员。有序集成员按 score 值递增(从小到大)次序排列。
    ...    可选的 WITHSCORES 参数决定结果集是单单返回有序集的成员，还是将有序集成员及其 score 值一起返回。
    ...    db： db编号
    ...
    ...    【返回值】
    ...    names：成员
    ${names}    RedisService.zrangebyscore    ${alias}    ${name}    ${min}    ${max}    ${start}
    ...    ${num}    ${withscores}    ${score_cast_func}    ${db}
    [Return]    ${names}

删除Redis中指定键值
    [Arguments]    ${alias}    ${keys}    ${db}=0
    [Documentation]    【功能】使用DEL命令删除指定键值
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    keys：键，支持list方式删除多个
    ...    db： db编号
    ...
    ...    【返回值】
    ...    无
    RedisService.delete    ${alias}    ${keys}    ${db}

删除Redis中Hash键值
    [Arguments]    ${alias}    ${name}    ${keys}    ${db}=0
    [Documentation]    【功能】使用HDEL命令删除指定Hash键值
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    name: hash名
    ...    keys：键，支持list方式删除多个
    ...    db： db编号
    ...
    ...    【返回值】
    ...    无
    RedisService.hdel    ${alias}    ${name}    ${keys}    ${db}

获取Redis列表元素
    [Arguments]    ${alias}    ${name}    ${index}    ${db}=0
    [Documentation]    【功能】使用lindex命令指定列表的成员
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    name：键名
    ...    index: 索引
    ...    db： db编号
    ...
    ...    【返回值】
    ...    item：集合成员
    ${item}    RedisService.lindex    ${alias}    ${name}    ${index}    ${db}
    [Return]    ${item}

获取Redis列表长度
    [Arguments]    ${alias}    ${name}    ${db}=0
    [Documentation]    【功能】使用llen命令指定列表长度
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    name：键名
    ...    db： db编号
    ...
    ...    【返回值】
    ...    len：列表长度
    ${len}    RedisService.llen    ${alias}    ${name}    ${db}
    [Return]    ${len}

获取Redis列表slice
    [Arguments]    ${alias}    ${name}    ${start}    ${end}    ${db}=0
    [Documentation]    【功能】使用lirange命令指定列表的slice
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    name：键名
    ...    stat: 起始索引
    ...    end： 结束索引
    ...    db： db编号
    ...
    ...    【返回值】
    ...    slice：列表片段
    ${slice}    RedisService.lrange    ${alias}    ${name}    ${start}    ${end}    ${db}
    [Return]    ${slice}

获取Redis哈希表key的所有域
    [Arguments]    ${alias}    ${db}=0
    [Documentation]    【功能】使用hkeys命令获取Redis 哈希表的所有key值
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    db： db编号
    ...
    ...    【返回值】
    ...    value：键值
    ${value}    RedisService.hkeys    ${alias}    ${db}
    [Return]    ${value}

设置Redis指定键值
    [Arguments]    ${alias}    ${name}    ${value}    ${toJson}=${False}    ${db}=0    ${ex}=${None}
    ...    ${px}=${None}    ${nx}=${False}    ${xx}=${False}
    ${res}    RedisService.set    ${alias}    ${name}    ${value}    ${db}    ${toJson}
    ...    ${ex}    ${px}    ${nx}    ${xx}
    [Return]    ${res}

设置Redis哈希键值指定域
    [Arguments]    ${alias}    ${name}    ${field}    ${data}    ${db}=0    ${toJson}=${False}
    [Documentation]    【功能】使用hset命令设置Redis哈希键值指定域
    ...
    ...    【参数】
    ...    alias: 对应的领域层对象Id，也就env.json上对应的service的id
    ...    name：键名
    ...    field: 域
    ...    data:要写入的数据
    ...    db： db编号
    ...    toJson:data数据是否要json
    ...
    ...    【返回值】
    ...    无
    RedisService.hset    ${alias}    ${name}    ${field}    ${data}    ${db}    ${toJson}
