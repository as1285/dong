#查看数据库，后期扩展重点，数据来源
from settings import *
import pymysql

class MySQLOperate():
    '''
        mysql执行器
    '''
    def __init__(self,DB):

        self.db = pymysql.Connect(
            host=DB_IP,
            user=DB_NAME,
            password=DB_PASSWORD,
            database=DB,
            port=PORT
        )

    def execute_sql(self,sql):
        '''
        执行sql
        :param sql: 增删改查
        :return:
        '''
        cursor = self.db.cursor(cursor=pymysql.cursors.DictCursor)#取数据库表的字段
        result = cursor.execute(sql)
        if sql.lower().startswith("select"):

            if result==1:
                return cursor.fetchone()#从结果中取第一条数据
            if 2000<result:
                return cursor.fetchmany(1000)
            else:
                return cursor.fetchall()
        else:
            self.db.commit()
            return result



if __name__ == '__main__':
    print(MySQLOperate("m_user").execute_sql("select user_id from m_user.us_user_baseinfo" ))