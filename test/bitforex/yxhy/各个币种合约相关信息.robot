*** Settings ***
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Resource            ../../keywords/basic/redis.robot
Library             DateTime


*** Test Cases ***
合约信息列表（全）各个币种的信息核对
    ${res}    yxhy_api调用    user_yj1    swap/contract/listAll
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${symbol1}      set variable    ${res['data'][0]['symbol']}
    ${symbolid1}      set variable    ${res['data'][0]['id']}
    ${initMargins1}      set variable    ${res['data'][0]['initMargins']}
    ${leverageLevel1}      set variable    ${res['data'][0]['leverageLevel']}
    ${maxOrderPrice1}      set variable    ${res['data'][0]['maxOrderPrice']}
    ${maxOrderVolume1}      set variable    ${res['data'][0]['maxOrderVolume']}
    ${maxUserVolume1}      set variable    ${res['data'][0]['maxUserVolume']}
    ${minChangePrice1}      set variable    ${res['data'][0]['minChangePrice']}

     ${symbol2}      set variable    ${res['data'][1]['symbol']}
    ${symbolid2}      set variable    ${res['data'][1]['id']}
    ${initMargins2}      set variable    ${res['data'][1]['initMargins']}
    ${leverageLevel2}      set variable    ${res['data'][1]['leverageLevel']}
    ${maxOrderPrice2}      set variable    ${res['data'][1]['maxOrderPrice']}
    ${maxOrderVolume2}      set variable    ${res['data'][1]['maxOrderVolume']}
    ${maxUserVolume2}      set variable    ${res['data'][1]['maxUserVolume']}
    ${minChangePrice2}      set variable    ${res['data'][1]['minChangePrice']}

     ${symbol3}      set variable    ${res['data'][2]['symbol']}
    ${symbolid3}      set variable    ${res['data'][2]['id']}
    ${initMargins3}      set variable    ${res['data'][2]['initMargins']}
    ${leverageLevel3}      set variable    ${res['data'][2]['leverageLevel']}
    ${maxOrderPrice3}      set variable    ${res['data'][2]['maxOrderPrice']}
    ${maxOrderVolume3}      set variable    ${res['data'][2]['maxOrderVolume']}
    ${maxUserVolume3}      set variable    ${res['data'][2]['maxUserVolume']}
    ${minChangePrice3}      set variable    ${res['data'][2]['minChangePrice']}

     ${symbol4}      set variable    ${res['data'][3]['symbol']}
    ${symbolid4}      set variable    ${res['data'][3]['id']}
    ${initMargins4}      set variable    ${res['data'][3]['initMargins']}
    ${leverageLevel4}      set variable    ${res['data'][3]['leverageLevel']}
    ${maxOrderPrice4}      set variable    ${res['data'][3]['maxOrderPrice']}
    ${maxOrderVolume4}      set variable    ${res['data'][3]['maxOrderVolume']}
    ${maxUserVolume4}      set variable    ${res['data'][3]['maxUserVolume']}
    ${minChangePrice4}      set variable    ${res['data'][3]['minChangePrice']}

    ${symbol5}      set variable    ${res['data'][4]['symbol']}
    ${symbolid5}      set variable    ${res['data'][4]['id']}
    ${initMargins5}      set variable    ${res['data'][4]['initMargins']}
    ${leverageLevel5}      set variable    ${res['data'][4]['leverageLevel']}
    ${maxOrderPrice5}      set variable    ${res['data'][4]['maxOrderPrice']}
    ${maxOrderVolume5}      set variable    ${res['data'][4]['maxOrderVolume']}
    ${maxUserVolume5}      set variable    ${res['data'][4]['maxUserVolume']}
    ${minChangePrice5}      set variable    ${res['data'][4]['minChangePrice']}
    should be equal   ${symbolid1}    10002
    should be equal   ${symbolid2}    10003
    should be equal   ${symbolid3}    10004
    should be equal   ${symbolid4}    10211
    should be equal   ${symbolid5}    10258
    should be equal  ${initMargins1} 0.01
    should be equal  ${initMargins2} 0.01
    should be equal  ${initMargins3} 0.01
    should be equal  ${initMargins4} 0.01
    should be equal  ${initMargins5} 0.01

    should be equal  ${leverageLevel1}  100

    should be equal  ${leverageLevel5}  100

    should be equal  ${leverageLevel5}  100

    should be equal  ${leverageLevel5}  25

    should be equal  ${leverageLevel5}  10

    should be equal  ${maxOrderVolume1}  2000000
    should be equal  ${maxOrderVolume2}  350000
    should be equal  ${maxOrderVolume3}  400000
    should be equal  ${maxOrderVolume4}  100000
    should be equal  ${maxOrderVolume5}  40000
合约最大持仓量
    ${res}    yxhy_api调用    user_yj1    contract/swap/contract/listAll
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200

    ${symbol1}       set variable     ${res['data'][0]['symbol']}
    ${maxOrderVolume1}            set variable     ${res['data'][0]['maxOrderVolume']}

    ${leverageLevel1}            set variable     ${res['data'][0]['leverageLevel']}

    ${ret_mysql}    根据SQL进行查询    mysql    select * from `p_perpetual`.`pp_contract_risk_level_config ` where symbol='${symbol1} ' and max_user_leverage='${leverageLevel1}'
    ${max_volume}    set variable    ${ret_mysql[0]['max_volume']}

    should be equal   ${max_volume}         ${maxOrderVolume1}

杠杆合约倍数数据

     ${symbol1}       set variable      swap-usd-btc
     ${ret_mysql}            杠杆合约倍数配置       ${symbol1}
     ${min_volume}       set variable        ${ret_mysql[0]['min_volume']}
     ${max_volume}       set variable        ${ret_mysql[0]['max_volume']}
     ${init_margins}       set variable        ${ret_mysql[0]['init_margins']}
     ${maintenance_margins}       set variable        ${ret_mysql[0]['maintenance_margins']}
     ${max_user_leverage}       set variable        ${ret_mysql[0]['max_user_leverage']}



超過最大下單量限制下單
    ${res}    yxhy_api调用    user_yj1    swap/contract/listAll
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${orderQty}      set variable    ${res['data'][0]['maxOrderVolume']}+1
    ${price}        set variable    获取指数价格
    ${res}          下单传参数       1      ${orderQty}     ${price}
    ${code}    set variable    ${res['code']}
    log    ${res['code']}
    should be equal as strings    ${code}    200
    ${message}    set variable    ${res['message']}
    should be equal as strings      ${message}     '下单数量不合法'










