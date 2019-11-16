import requests
from encrypt_decrypt import EncryptDecrypt
import random
from time import sleep
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
class data_script:

    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    def __init__(self):
        self.host = 'http://192.168.199.151/'
        self.uid = '2195580'
        self.symbol="swap-usd-btc"
        self.price=None
        self.orderQty=1
        self.sellprice=None
        self.buyprice=None

    def get_url(self, api):
        return self.host + api

    def header(self):
        header = {'accept': 'application/json',
                  'Host': '192.168.199.151',
                  'accept-encoding': 'gzip, deflate',
                  'accept-charset': 'UTF-8,*;q=0.5',
                  "Referer": "http://192.168.199.151/cn/userCenter/userBfToken",
                  "user-agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36",
                  "cookies": 'secure=true; HttpOnly=true; gr_user_id=d5d78f94-5aba-4f32-863b-e34d42a425b1; grwng_uid=4679ba99-8f67-4c8e-9b08-78ed4dadc373; _hjid=ed556ba2-6ee5-42ab-ba01-f1e1c2bf5916; lang=cn; hideLanguageSelect=true; JSESSIONID=575527F064166053A3583037AAB1D44B-n1; 945b4bd5a264805a_gr_session_id=d023f20d-9444-41db-a6a2-e2657fd117a0; 945b4bd5a264805a_gr_session_id_d023f20d-9444-41db-a6a2-e2657fd117a0=true; valuationCurrency=CNY; valuationSymbol=%A5; _ga=GA1.1.718150525.1565837257; _gid=GA1.1.586740127.1565837257',
                  }
        user_id_hash = EncryptDecrypt().encrypt(self.uid)
        header["UserId"] = user_id_hash
        return header
    def order_by_OP(self,side,orderQty,symbol):#根据买一价，卖一价下单
        api = '/contract/mkapi/v2/tickers'
        url = self.get_url(api)
        header = self.header()
        data = {}
        res = self.run_main('get', url, data, header)
        print(res.json())
        price=0
        if side==1:
            price = res.json()["data"]["swap-usd-btc"]["high"]  # 卖一价
        if side==2:
            price = res.json()["data"]["swap-usd-btc"]["low"]  # 卖一价
        api ='contract/swap/order'
        data={"symbol": symbol, "side": side, "source": "1", "type": 1, "orderQty": orderQty, "price": price}
        url=self.get_url(api)
        res = self.run_main('get', url, data, header)
        print('根据买一价，卖一价下单',res.json(),data)
        return res.json()

    def buy_order(self):#买
        api = 'contract/swap/order'
        url = self.get_url(api)
        header = self.header()
        data = {"symbol": self.symbol, "side": 1, "source": "1", "type": 1, "orderQty": self.orderQty, "price": self.price}
        res = self.run_main('post', url, data, header)
        print('买单',res.text,data)
        return res.json()
    def order_by_param(self,side,orderQty,price):#下单传参数
        api = 'contract/swap/order'
        url = self.get_url(api)
        header = self.header()
        data = {"symbol": self.symbol, "side": side, "source": "1", "type": 1, "orderQty": orderQty, "price": price}
        res = self.run_main('post', url, data, header)
        print('买单',res.text,data)
        return res.json()
    def order_by_flagPrice(self,side):#根据标记价格下单
        flagPrice=self.commonInfo()["data"]["flagPrice"]
        self.price=float(flagPrice[:-2])
        if side=='1':
            res=self.buy_order()
            return  res
        elif side=='2':
            return self.sell_order()
    def order_by_indexPrice(self):#根据指数价格下单
        indexPrice=self.commonInfo()["data"]["indexPrice"]
        self.buyprice = float(indexPrice[:-2])
        return  self.buy_order()

    def order_nums(self,side):#根据可用余额下单
        accb=self.account()['data']['accb']
        if accb*10000+float(self.position()['data']['currentPosition'])<200000 and accb*10000<100000:
            self.orderQty=accb*10000
        else:
            self.orderQty = accb

        return self.order_by_flagPrice(side)
    def sell_order(self):#卖
        api = 'contract/swap/order'
        url = self.get_url(api)
        header = self.header()
        data = {"symbol": self.symbol, "side": 2, "source": "1", "type": 1, "orderQty": self.orderQty, "price": self.price}
        res = self.run_main('post', url, data, header)
        print('卖单',res.text,data)
        return res.json()

    def delete_order(self,orderId):#撤销订单
        api = 'contract/swap/order'
        url = self.get_url(api)
        header = self.header()
        data = {"symbol": self.symbol, "orderId": orderId, "source": "1"}
        res = self.run_main('delete', url, data, header)
        print(res.text)
        return res.json()

    def delete_order_all(self):#撤销全部订单
        api = 'contract/swap/order/all'
        url = self.get_url(api)
        header = self.header()
        data = {"symbol": self.symbol, "source": "1"}
        res = self.run_main('delete', url, data, header)
        print(res.text)
        return res.json()

    def batch_order(self):#批量下单
        api = 'contract/swap/order/batch'
        url = self.get_url(api)
        header = self.header()
        data = [
            {
                "future": 0,
                "orderQty": self.orderQty,
                "price": self.price,
                "side": 1,
                "source": "1",
                "symbol": self.symbol,
                "type": 1
            }
        ]
        res = self.run_main('post', url, data, header)
        print(res.text,data)
        return res.json()
    def delete_batch_order(self):#批量撤单
        api = 'contract/swap/order/batch'
        url = self.get_url(api)
        header = self.header()
        orderIds=self.batch_order()['data']
        data = {
            "orderIds": [],
            "source": "1",
            "symbol": self.symbol
        }
        data["orderIds"]=orderIds
        res = self.run_main('delete', url, data, header)
        print(res.text,data)
        return res.json()
    def order_list(self):#委托列表
        api="contract/swap/order/list/swap-usd-btc"
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print('委托列表',res.text,data)
        return res.json()
    def  get_orderids(self):#委托列表获取订单ID集合
        res=self.order_list()
        orderids=[]
        for i in range(len(res['data']['pageData'])):
            orderids.append(['data']['pageData'][i]['entrustId'])
        return orderids
    def order_list_num(self):#委托列表数量
        res=self.order_list()
        volume=res['data']['pageData'][0]["volume"]
        side=res['data']['pageData'][0]["side"]
        return volume


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
        try:
            if method == 'post':
                result = self.send_post(url, data, header)
            elif method == 'get':
                result = self.send_get(url, data, header)
            elif method == 'delete':
                result = self.send_delete(url, data, header)
            else:
                print("请求方式错误")
            return result
        except:
            return result
    def createdatalist(self,n):#跑单
        api='/contract/mkapi/v2/tickers'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        buyprice=res.json()["data"]["swap-usd-btc"]["high"]#卖一价
        sellprice=res.json()["data"]["swap-usd-btc"]["low"]#卖一价
        for i  in  range(n):
            self.price=str(buyprice)
            message1=self.buy_order()["message"]
            if message1 =="委托失败! 超过最大持仓上限！":
                self.delete_order_all()
            self.price=str(sellprice)
            message2 = self.sell_order()["message"]
            if message2 =="委托失败! 超过最大持仓上限！":
                self.delete_order_all()


    def ok_depth_get(self, symbol, size=10):
        url = 'https://www.okex.com/api/swap/v3/instruments/{0}-USD-SWAP/depth?size={1}'.format(symbol, size)
        req = requests.get(url, verify=False)
        res = req.content.decode()
        print(res)
        return res
    def contractDetail(self):#合约信息明细
        api="/contract/swap/contract/contractDetail/swap-usd-btc"
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print('合约信息明细',res.text)
        return res.json()
    def sumFound(self):#得到用户的资金的汇总
        api='/contract/swap/account/sumFound'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print('得到用户的资金的汇总',res.text)
        return res.json()
    def account(self):#用户btc的资产信息
        api='/swap/account/swap-usd-btc'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print('用户btc的资产信息',res.text)
        return res.json()
    def getDigitalCoinInfos(self):#得到所有币种的列表
        api='/server/userFund.act?cmd=getDigitalCoinInfos'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print(res.text)
    def history(self):#获取用户历史订单
        api='/contract/swap/order/history/swap-usd-btc'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print(res.text)
        return res.json()
    def getChannelUser(self):#获取用户信息
        api='swap/commission/getChannelUser'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print(res.text)
    def historicalBill(self):#委托历史
        api='swap/order/historicalBill/swap-usd-btc'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print(res.text)
    def order_has_trade(self):#已成交
        api='contract/swap/order/trade/swap-usd-btc'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print(res.text)
        return res.json()
    def position(self):#用户持仓
        api='/contract/swap/position/swap-usd-btc'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print('用户持仓列表',res.text)
        return res.json()
    def commonInfo(self):#获取指数价格标记价格
        api="contract/swap/contract/commonInfo/swap-usd-btc"
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print('获取指数价格标记价格',res.text)
        return res.json()
    def get_flagprice(self):#获取标记价格
        return self.commonInfo()["data"]["flagPrice"]
    def get_indexprice(self):#获取指数价格
        return self.commonInfo()["data"]["indexPrice"]
    def  ULP_LLP(self,side):#委托限价
            if  side=='1':
                return self.get_flagprice()(1+0.02)
            else:
                return self.get_flagprice()(1-0.02)
    def account_fundList(self):#资金费用收取列表
        api='swap/contract/list'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print('资金费用收取列表',res.text)
        return res.json()
    def mkapi(self):#成交量信息
        api='/contract/mkapi/v2/tickers'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print('成交量信息',res.text)
        return res.json()
    def orderSelf(self):#自成交
        api='swap/orderSelf/'
        url = self.get_url(api)
        header = self.header()
        data={"symbol": "swap-usd-btc", "side": 1, "source": "1", "type": 1, "orderQty": 1,"price": 9800.0}
        res = self.run_main('delete', url, data, header)
        print('成交量信息',res.text)
        return res.json()
    def listAll(self):#合约所以币对信息
        api='contract/swap/contract/listAll'
        url = self.get_url(api)
        header = self.header()
        data={}
        res = self.run_main('get', url, data, header)
        print('合约所以币对信息',res.text)
        for i  in res.json()['data']:
            print(i)
        return res.json()

if __name__ == "__main__":
    run = data_script()
    run.host = 'http://192.168.199.151/'
    run.uid='2195580'
    # user_ids = MySQLOperate("m_user").execute_sql("select user_id from m_user.us_user_baseinfo")
    # user_list=[]
    run.price="9760.5"#下单价格
    # run.orderQty=str(random.randint(1,9))#单数量
    run.orderQty=1
    run.symbol="swap-usd-btc"#币种对
    run.position()


    # print('{:.8f}'.format(4.27167877E-8) ,4.27167877E-8/0.00010679)
    # run.sellprice="10239"
    # for i in user_ids[-20:-1]:
    #     run.uid = str(i['user_id'])
    #     print(run.uid)
    #     MySQLOperate("p_perpetual").execute_sql("update  pp_assets set fixed_asset=10000 where u_id=%s" % run.uid)
    #
    #     n=10#下单次数
    #     run.createdatalist(n)#跑单
    # run.ok_depth_get('BTC')
    # for i in range(n):#撤销全部订单
    #     run.delete_order_all()

