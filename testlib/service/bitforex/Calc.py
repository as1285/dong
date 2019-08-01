#!/usr/bin/env python3
# coding=utf-8


# 永续合约常量
S = 1.0 #合约乘数
IMR = 0.01 #起始保证金率
MMR = 0.005 #维持保证金率
R = 0.0006 #提取方流动性手续费率
M = 0.0004 #提取方流动性手续费率


class Calc:

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def brp(self, HP, R, Accb, Vol, S, IMR):  # 计算破产价格
        brp_buy = HP * (R + 1) / (Accb * HP / Vol * S + (1 + IMR + R))
        brp_sell = HP * (R - 1) / (Accb * HP / Vol * S + (IMR + R - 1))
        return brp_buy, brp_sell
