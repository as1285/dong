import os
# 获取项目路径
BASE_PATH = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
# 定义测试用例的路径
TESTCASE_PATH =  os.path.join(BASE_PATH,'case/case.xls')
# 定义测报告的路径
REPORT_PATH =  os.path.join(BASE_PATH,'report/')
# 定义日志文件的路径
LOG_PATH = os.path.join(BASE_PATH,'logs/logs.txt')
uid='2195585'
host='http://192.168.199.151'

# # mysql数据库的连接信息  166环境数据库
# DB_NAME = 'root'
# DB_PASSWORD = 'root'
# DB_IP = '192.168.199.202'
# PORT = 3306


# mysql数据库的连接信息  151环境数据库
DB_NAME = 'bit_dev'
DB_PASSWORD = 'K2Jk!AzgLhae##Ex'
DB_IP = '192.168.199.150'
PORT = 3306


#发送邮件配置
email_host = 'smtp.qq.com'
send_user = '498771018@qq.com'
password = 'ikcwnwolsdzjbicf'#邮箱的smtp验证码,不是 邮箱密码
user_list = ['dong1285@126.com']#收件人列表，后面用;隔开

