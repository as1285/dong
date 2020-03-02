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


    def brp(self, HP, Accb, Vol,side):  # 计算破产价格
        brp=0
        if side == '1':
            brp= HP * (0.0006 + 1) / (Accb * HP / Vol * 1 + (1 + IMR + 0.0006))
        elif side == '2':
            brp = HP * (0.0006 - 1) / (Accb * HP / Vol * 1 + (IMR + 0.0006 - 1))
        else:
            print('仓位方向side错误')
        print('破产价格;',brp)
        return brp

    def cal_liqp(self, HP, Accb, Vol, SIDE):
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
        Accb=float(Accb)

        if SIDE == '1':
            print('test')
            print(HP,R,Accb,Vol)
            result = HP * (R + 1) / (Accb * HP / Vol * S + (1 + IMR - MMR + R))
        if SIDE == '2':
            result = HP * (R - 1) / (Accb * HP / Vol * S + (IMR + R - 1 - MMR))
        print('强平价格=',result)
        return float(result)
if __name__=="__main__":
    run=Calc()
    run.cal_liqp(8057,-0.00000116-0.0000013156261636,1,'1')
    run.brp(8057,-0.00000116-0.0000013156261636,1,'1')