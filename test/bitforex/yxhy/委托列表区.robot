*** Settings ***
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Library             DateTime

*** Test Cases ***
委托列表-买入委托的排序方式
    ${res}    yxhy_api调用    user_yj1    contract/swap/order/list/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${price1}       set variable    ${res['data']["pageData"][0]['price']}
    ${price2}       set variable    ${res['data']["pageData"][0]['price']}
    ${price3}       set variable    ${res['data']["pageData"][0]['price']}
    should be true  ${price1} >${price2}>${price3}
卖出委托的数量计算方式是否正确
    ${res}    yxhy_api调用    user_yj1    contract/swap/order/list/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
    ${price1}       set variable    ${res['data']["pageData"][0]['price']}
    ${price2}       set variable    ${res['data']["pageData"][0]['price']}
    ${price3}       set variable    ${res['data']["pageData"][0]['price']}
    should be true  ${price1} <${price2}<${price3}

委托的仓位方向是否正确
     ${side}       set variable    ${1}
     ${res}   根据买一价卖一价下单        ${side}
     ${code}    set variable    ${res['code']}
     should be equal as strings    ${code}    200
    ${res}    yxhy_api调用    user_yj1    contract/swap/order/list/swap-usd-btc
    ${code}    set variable    ${res['code']}
    should be equal as strings    ${code}    200
     ${side1}       set variable    ${res['data']["pageData"][0]['side']}
     should be equal  ${side1}  ${side}
委托保证金的计算是否正确
    ${res}     委托保证金的计算
    should be true   ${res}
    log  ${res}
    ${user_id}    获取user_id    user_yj1
    ${ret_mysql}    执行指定SQL语句并获取字典形式结果    mysql    select * from `p_perpetual`.`pp_assets` where u_id='${user_id}' and contract_id='10002'
    ${frozen_margin}    set variable    ${ret_mysql[0]['frozen_margin']}
    ${result}    浮点数比较    ${res}     ${frozen_margin}    ${0.00001}




