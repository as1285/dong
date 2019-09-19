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


