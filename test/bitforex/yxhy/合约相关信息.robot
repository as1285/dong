*** Settings ***
Resource          ../../keywords/bitforex/yxhy.robot
#Resource          ../../keywords/bitforex/calc.robot
#Resource          ../../keywords/basic/mysql.robot
#Resource          ../../keywords/basic/util.robot
Library           DateTime

*** Test Cases ***
同意协议
    log    --loglevel DEBUG:DEBUG
    ${res}    yxhy_api调用    user_yj1    swap/account/agreement
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
账户资金费用收取列表
    ${res}    yxhy_api调用    user_yj1    swap/account/fundList/
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
获取协议状态
    ${res}    yxhy_api调用    user_yj1    swap/account/getAgreement
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
得到用户的资产汇总
    ${res}    yxhy_api调用    user_yj1    swap/account/sumFound
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
资产划转
    ${res}    yxhy_api调用    user_yj1    swap/account/transfer
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
主账户系统回调
    ${res}    yxhy_api调用    user_yj1    swap/account/transferCallback
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
账户信息
    ${res}    yxhy_api调用    user_yj1    swap/account/
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
合约公共信息
    ${res}    yxhy_api调用    user_yj1    swap/contract/commonInfo/
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
合约最大持仓量
    ${res}    yxhy_api调用    user_yj1    swap/contract/contractDetail/opebpost/
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
合约信息明细
    ${res}    yxhy_api调用    user_yj1    swap/contract/contractDetail/
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
合约信息列表
    ${res}    yxhy_api调用    user_yj1    swap/contract/list
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
合约信息列表（全）
    ${res}    yxhy_api调用    user_yj1    swap/contract/listAll
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
