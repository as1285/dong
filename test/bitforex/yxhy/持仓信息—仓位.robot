*** Settings ***
Resource            ../../keywords/bitforex/yxhy.robot
Resource            ../../keywords/bitforex/calc.robot
Resource            ../../keywords/basic/mysql.robot
Resource            ../../keywords/basic/util.robot
Library             DateTime

*** Test Cases ***
持仓反向的委托是否优先平仓
#    ${side}    set variable   ${1}
    ${res}    下卖单根据指数价格和可用余额    1000

     log  ${res}
