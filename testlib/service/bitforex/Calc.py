import time
# 永续合约常量
S = 1.0 #合约乘数 #contractFactor
R = 0.0006 #提取方流动性手续费率
M = 0.0004 #提取方流动性手续费率
feeRateMaker=0.0004  #挂单手续费
feeRateTaker=0.0006  #吃单手续费
MMR=0
IMR=0
# IMR = 0.02=风险限额等级*0.01=RL*0.01 #起始保证金率
# MMR = 0.005 #维持保证金率
from testlib.conf.readexcel import ExcelUtil
class Calc:



    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    def __init__(self):
        self.Vol=None
        self.HP=None
        self.Accb=None
        self.side=None
        self.SP=None
        self.indexPrice=None#指数价格
        self.fundRate=None #资金费率
        self.R=None
        self.OP=None # 委托价格
        self.nextFundTime=None
        self.symbol = "swap-usd-btc"
        self.MMR=0.005
        self.IMR=0.01

    def data_load(self,symbol):
        run=ExcelUtil()
        data=run.dict_data()
        data_btc=data[0:10]
        data_eth=data[11:20]
        data_ltc=data[21:30]
        data_xrp=data[31:40]
        data_grin=data[41:50]
        if symbol=="swap-usd-btc":
            return data_btc
        if symbol=="swap-usd-eth":
            return data_eth
        if symbol=="swap-usd-ltc":
            return data_ltc
        if symbol=="swap-usd-xrp":
            return data_xrp
        if symbol=="swap-usd-grin":
            return data_grin
    def data(self,symbol,vol):#从Exce表里获取数据
        datas=self.data_load(symbol)
        for data in datas:
            vol_num=data['合约数量'].split('-')[-1]
            if  vol<=vol_num:
                self.MMR=data['MMR']
                self.IMR = data['IMR']
                break
            return data



    def brp(self, side,HP, Accb, Vol,IMR):  # 计算破产价格
        brp=0
        if side == '1':
            brp= HP * (0.0006 + 1) / (Accb * HP / Vol * 1 + (1 + IMR + 0.0006))
        if side == '2':
            brp = HP * (0.0006 - 1) / (Accb * HP / Vol * 1 + (IMR + 0.0006 - 1))
        else:
            print('仓位方向side错误')
        return brp
    def Brp(self,side):  # 计算破产价格
        brp = 0
        if side == '1':
            brp = self.HP * (R + 1) / (self.Accb * self.HP / self.Vol * S + (1 + IMR + R))
        if side == '2':
            brp = self.HP * (R - 1) / (self.Accb * self.HP / self.Vol * S + (IMR + R - 1))
        else:
            print('仓位方向side错误')
        return brp

    def cal_liqp(self, HP, R, Accb, Vol, SIDE):
        '''
        :param hp: 持仓均价
        :param r: taker手续费
        :param accb: 可用余额
        :param vol: 持仓数量
        :param imr: 起始保证金率
        :param mmr: 维持保证金率
        :param side: 仓位方向
        :return:1

        持多仓 强平价格（LiqP1）=HP*(R + 1)/[Ab*HP/Vol*S +(1 + IMR - MMR + R)]
        持空仓 强平价格（LiqP2）=HP*(R - 1)/[Ab*HP/Vol*S + (IMR + R - 1 - MMR)]
        '''

        result = 0.0001
        HP=float(HP)
        Vol=float(Vol)
        R=float(R)
        Accb=float(Accb)

        if SIDE == '1':
            print('test')
            print(HP,R,Accb,Vol)
            result = HP * (R + 1) / (Accb * HP / Vol * S + (1 + IMR - MMR + R))
        if SIDE == '2':
            result = HP * (R - 1) / (Accb * HP / Vol * S + (IMR + R - 1 - MMR))
        print('强平价格=',result)
        return float(result)

    # def Accb(self):
    #     return self.unrealisedPNL()
    def unrealisedPNL(self,side,Vol,HP,FP):#未实现盈亏
        print(type(HP),type(Vol),type(FP),type(S))
        if side=='1':#买
            return  Vol * S *(1/HP-1/FP)
        if side=='2':#卖
            return  Vol * S *(1/FP-1/HP)
    def pv(self):#仓位价值
        return self.Vol*S/self.HP
    def OV(self):#委托价值
        return self.Vol*S/self.HP #委托价格
    def iniMargins(self):#起始保证金
        return self.Vol*S*IMR/self.HP + self.Vol*S*R/self.HP

    def maintenanceMargins(self):#维持保证金
        print(self.Brp('1'),self.pv())
        return  0.005 * self.pv()+feeRateTaker*self.Vol/self.OP#按照破产价格算的
    def BF(self):#预估手续费
        return 2*self.Vol * S *R/self.OP
    def cal_pm(self,cost, IMR,HSide=None):  # [仓位]中的[保证金]
        IPM =self.Vol * S * IMR / self.HP + self.Vol * S * R /self.HP
        PM = 0.123
        if HSide == 1:
            Unrealised_PNL = float(self.Vol * S * (1 / self.HP - 1 / self.flagPrice()))  # 多仓未实现盈亏
            print("做多的未实现盈亏为:%f" % Unrealised_PNL)
            PM = IPM + min(0, (self.Accb - cost - IPM) * 1 + min(0, Unrealised_PNL))
            print("做多的[仓位]中的[保证金]为:%f" % PM)
        if HSide == 2:
            Unrealised_PNL = float(self.Vol * S * (1 / self.flagPrice() - 1 / self.HP))  # 空仓未实现盈亏
            print("做空的未实现盈亏为:%f" % Unrealised_PNL)
            PM = IPM + min(0, (self.Accb - cost - IPM) * 1 + min(0, Unrealised_PNL))
            print("做空的[仓位]中的[保证金]为:%f" % PM)
        return PM

    def frozen(self):#委托保证金
        # 委托保证金= self.iniMargins+预估手续费
        return self.iniMargins()+2*self.OV()*R




    def  ULP_LLP(self):#委托限价
            if  self.side=='1':
                return self.flagPrice()(1+0.02)
            else:
                return self.flagPrice()(1-0.02)
        # 委托价格跟当前标记价格偏差不能超过管理后台设置的限价百分比。
        # 如果委托是减仓方向，那么委托价格不能突破仓位破产价格。
        #买价<=标记价格*（1 +价格上限百分比）
        #标记价格*20>=卖价>=标记价格*（1- 价格下限百分比）
        # 如果委托是加仓方向，那么委托价格不能突破仓位强平价格。


    def flagPrice(self):
        now = int(time.time())
        return self.indexPrice*(1+self.fundRate*(self.nextFundTime/1000-now) /float(8*3600))
    #等于标的指数价格加上随时间递减的资金费用基差。
    # 标记价格=指数价格*（1+资金费率*（至下一个交付资金费用的时间/资金费用时间间隔）

# #盈亏率
#     def ROE(self):
#         return self.unrealisedPNL()/self.iniMargins()

#资金费用
    def F(self):
        return self.Vol*self.flagPrice()*self.fundRate
      #买方和卖方之间每隔 8 小时定期支付费用。 如果费率为正，多仓将支付 而 空仓将获得 资金费率，如果费率为负，则相反。 只有用户在资金时间戳时持有仓位，才需要支付或收取资金费用。
    def fundfee(self,Vol,flagPrice,fundRate):
        return Vol * flagPrice() * fundRate






# 可用保证金（AM）=账户余额 - 起始仓位保证金- 委托保证金 =》    AM= AccB - IPM - OM
# 做多的未实现盈亏为 Unrealised_PNL1 = float(Vol*S*(1/HP - 1/FP))
# 做空的未实现盈亏为 Unrealised_PNL2 = float(Vol*S*(1/FP - 1/HP))
# 做多的[仓位]中的[保证金]=仓位保证金 + 账户余额抵扣不足的浮动亏损     =》PM1=IPM + Min(0,(AccB - OM - IPM)*1 + Min(0, Unrealised_PNL1)    （亏损权重为1）
# 做空的[仓位]中的[保证金]=仓位保证金 + 账户余额抵扣不足的浮动亏损     =》PM1=IPM + Min(0,(AccB - OM - IPM)*1 + Min(0, Unrealised_PNL2)
