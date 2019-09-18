from data_script import data_script
from  testlib.service.bitforex.Calc import Calc
import  requests
from float_com import UtilService
from time import sleep
base_data=data_script()
formula=Calc()
float_compare=UtilService()
feeRateTaker=0.0006
feeRateMaker=0.0004
class qiangping():
    def __init__(self):
        self.host = 'http://192.168.199.151/'
        self.uid = None
        self.symbol=None
        self.price=None
        self.orderQty=None
        self.sellprice=None
        self.buyprice=None
    def Liq_price(self):#强平价格的计算比较
        base_data.order_nums('1')#下买多单
        sleep(0.5)
        account_data = base_data.account()#查询用户账户信息
        position_data=base_data.position()#查看用户仓位
        Accb=account_data['data']['accb']
        Vol=position_data['data']['currentPosition']
        HP=position_data['data']['avgCostPrice']
        R= float(Vol) /float(HP)*feeRateTaker
        print('taker手续费',R)
        liquidationPrice=position_data['data']['liquidationPrice']
        if int(Vol)<0:
            SIDE='2'
        else:
            SIDE='1'
        cal_liqp=formula.cal_liqp(HP, R, Accb, Vol, SIDE)
        print('浮点数比较',float_compare.compare_float(cal_liqp,liquidationPrice,0.1))
    def unrealisedPNL(self):#未实现盈亏的计算比较
        base_data.order_nums('1')#下买多单
        sleep(0.5)
        account_data = base_data.account()#查询用户账户信息
        position_data=base_data.position()#查看用户仓位
        common_data=base_data.commonInfo()#查看 指数价格标记价格等信息
        unrealisedPNL=account_data['data']['unrealisedPNL']
        FP=float(common_data['data']['flagPrice'])
        Vol=float(position_data['data']['currentPosition'])
        HP=float(position_data['data']['avgCostPrice'])
        margin=float(position_data['data']['margin'])
        if int(Vol)<0:
            SIDE='2'
        else:
            SIDE='1'
        formula.unrealisedPNL(SIDE, Vol, HP, FP)
        print('浮点数比较', float_compare.compare_float(formula.unrealisedPNL(SIDE, Vol, HP, FP), unrealisedPNL, 0.00000001))
        print('回报率',unrealisedPNL/margin)
    def Rate_of_return(self):
        position_data = base_data.position()
    def margin_rate(self):#保证金率
        account_data = base_data.account()  # 查询用户账户信息
        frozen=float(account_data['data']['frozen'])
        positionMargin=float(account_data['data']['positionMargin'])
        equity=float(account_data['data']['equity'])
        rate=(frozen+positionMargin)/equity
        print(rate)
        return rate
    def flagPrice(self):#标记价格的计算比较
        common_data = base_data.commonInfo()  # 查看 指数价格标记价格等信息
        formula.indexPrice=float(common_data['data']['indexPrice'])
        formula.fundRate = float(common_data['data']['fundRate'])
        formula.nextFundTime = float(common_data['data']['nextFundTime'])
        flagPrice=float(common_data['data']['flagPrice'])
        flag_price=formula.flagPrice()
        print(flag_price,'2')
        a=float_compare.compare_float(flag_price,flagPrice,0.1)
        print(a)
        return a
    def risk(self):#风险率

        account_data = base_data.account()
        equity = float(account_data['data']['equity'])
        print(formula.maintenanceMargins()/equity )
        return formula.maintenanceMargins()/equity


    def order(self,side):#买卖单撤单操作无需订单ID
        base_data.order_nums(side)
        base_data.delete_order_all()
        if side == '1':
            print('批量买单撤单')
        if side == '2':
            print('批量卖单撤单')

    def delete_order_by_id(self):#根据订单里面的列表撤单
        order_list=base_data.order_list()['data']['pageData']
        if order_list:
            for orderId in order_list:
                base_data.delete_order(orderId)
        else:
            print('委托列表为空')
    def frozen_count(self):#委托保证金的计算
        base_data.order_nums('1')
        sleep(0.5)
        position_data = base_data.position()
        account_data = base_data.account()
        formula.Vol=float(position_data['data']['currentPosition'])
        formula.HP=float(position_data['data']['avgCostPrice'])
        frozen_count=formula.frozen()
        frozen=float(account_data['data']['frozen'])
        a=float_compare.compare_float(frozen,frozen_count,0.000001)
        return a

    def margin(self):#仓位保证金
        position_data = base_data.position()
        account_data = base_data.account()
        formula.Vol=float(position_data['data']['currentPosition'])
        formula.HP=float(position_data['data']['avgCostPrice'])
        formula.Accb=float(account_data['data']['accb'])
        print(formula.iniMargins())
        return formula.iniMargins()
    def postion(self):#与持仓反向的委托是否优先平仓
        base_data.order_nums('1')
        position_data = base_data.position()
        Vol_start1 = int(position_data['data']['currentPosition'])
        base_data.orderQty=20000
        common_data = base_data.commonInfo()
        base_data.price=int(common_data['data']['flagPrice'][:-3])
        base_data.sell_order()
        sleep(0.3)
        position_data = base_data.position()
        Vol_end=int(position_data['data']['currentPosition'])
        print(Vol_start1,Vol_end)
        return Vol_end


    def buy_order1(self):#下买单

        a=base_data.order_nums('1')
        sleep(0.5)
        return a
    def sell_order1(self,vol):#下卖单
        base_data.orderQty=vol
        common_data = base_data.commonInfo()
        base_data.price=float(common_data['data']['indexPrice'][:-2])
        base_data.sell_order()
        return base_data.sell_order()

    def postion_clear(self):#持仓归0
        position_data = base_data.position()
        Vol1 = float(position_data['data']['currentPosition'])
        common_data = base_data.commonInfo()
        base_data.price = float(common_data['data']['indexPrice'][:-2])
        base_data.orderQty = 10000
        base_data.buy_order()
        sleep(1)
        position_data1 = base_data.position()
        base_data.orderQty = 200000
        Vol2 = float(position_data1['data']['currentPosition'])
        print(Vol2>20000,Vol1,Vol2)
        print(base_data.orderQty)
        print(base_data.buy_order())
        if Vol2>200000 and Vol1>Vol2:
            base_data.orderQty = 200000
            print(base_data.orderQty)
            print(base_data.buy_order())


    def send_post(self, url, data, header):
        result = requests.post(url=url, json=data, headers=header)
        return result
    def send_get(self, url, data, header):
        result = requests.get(url=url, json=data, headers=header)
        return result

    def send_delete(self, url, data, header):
        result = requests.delete(url=url, json=data, headers=header)
        return result

    def run_main(self, method, url=None, data=None, header=None):
        result = None
        if method == 'post':
            result = self.send_post(url, data, header)
        elif method == 'get':
            result = self.send_get(url, data, header)
        elif method == 'delete':
            result = self.send_delete(url, data, header)
        else:
            print("请求方式错误")
        return result
if __name__ == "__main__":
    run = qiangping()
    run.postion()

