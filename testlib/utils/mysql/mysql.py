#!/usr/bin/env python3
# coding=utf-8


import time
import pymysql
from testlib.utils.logger import logger
from testlib.utils.env.service import Service


class Mysql(Service):

    def init_env(self, env_dict=None):
        Service.init_env(self, env_dict)
        self._host = env_dict.get('host', env_dict.get('ip'))
        self._port = env_dict.get('dbport', 3306)
        self._user = env_dict.get('dbuser')
        self._passwd = env_dict.get('dbpwd')
        self._db = env_dict.get('db')
        self._charset = env_dict.get('charset', 'utf8')
        self._try_max_times = env_dict.get('times', 3)
        self._try_times = 0
        self._conn = self._connect()
        return self

    def __del__(self):
        if self._conn:
            self._conn.close()

    def _connect(self):
        logger.info('connect mysql')
        try:
            if self._db:
                conn = pymysql.connect(host=self._host, port=self._port, user=self._user, password=self._passwd, database=self._db, charset=self._charset)
            else:
                conn = pymysql.connect(host=self._host, port=self._port, user=self._user, password=self._passwd, charset=self._charset)
            conn.autocommit(1)
        except pymysql.Error as e:
            error_msg = "MySQL connect error! {0} {1}".format(e.args[0], e.args[1])
            logger.error(error_msg)
            if self._try_times < self._try_max_times:
                time.sleep(5)
                self._try_times += 1
                return self._connect()
            else:
                return False
        return conn

    def _update_connect(self):
        if self._conn:
            self._conn.close()
        self._conn = self._connect()
        logger.info('update pymysql connection success!!!!!')

    def select_sql(self, sql, todict=False):
        return self.fetch_all_rows(sql, todict)

    def execute_sql(self, sql):
        return self.execute(sql)

    def truncate(self, table):
        sql = 'TRUNCATE TABLE {0}'.format(table)
        return self.execute(sql)

    def flush_tables(self, sleep_seconds=None):
        cnt = self.execute('flush tables;')
        if sleep_seconds:
            time.sleep(sleep_seconds)
        return cnt

    def source(self, sql_file, is_local=False):
        cursor = self._conn.cursor()
        if is_local:
            with open(sql_file, 'rb') as rf:
                sql = rf.read()
                logger.info('sql: {0}'.format(sql))
        else:
            sql = self.exe_cmd('cat {0}'.format(sql_file)).output
        try:
            cursor.execute(sql)
            cursor.close()
            self._conn.commit()
        except Exception as e:
            self._conn.rollback()
            raise e

    def execute(self, sql, todict=False):
        if 'select' in sql.lower():
            self._update_connect()
        if todict:
            cursor = self._conn.cursor(cursor=pymysql.cursors.DictCursor)
        else:
            cursor = self._conn.cursor()
        try:
            logger.info("execute sql:{0}".format(sql))
            data = cursor.execute(sql)
            logger.info("execute result is: {0}".format(data))
            cursor.close()
            self._conn.commit()
        except pymysql.Error as e:
            logger.error("MySQL error! {0} {1}".format(e.args[0], e.args[1]))
            data = ()
        return data

    def fetch_all_rows(self, sql, todict=False):
        if todict:
            cursor = self._conn.cursor(cursor=pymysql.cursors.DictCursor)
        else:
            cursor = self._conn.cursor()
        try:
            logger.info("sql is: {0}".format(sql))
            cursor.execute(sql)
            data = cursor.fetchall()
            cursor.close()
            self._conn.commit()
            logger.info("execute result is: {0}".format(data))
        except pymysql.Error as e:
            logger.error("MySQL error! {0} {1}".format(e.args[0], e.args[1]))
            data = ()
        return data

    def fetch_one_row(self, sql, todict=False):
        if todict:
            cursor = self._conn.cursor(cursor=pymysql.cursors.DictCursor)
        else:
            cursor = self._conn.cursor()
        try:
            logger.info("sql is: {0}".format(sql))
            cursor.execute(sql)
            result = cursor.fetchone()
            cursor.close()
            self._conn.commit()
            logger.info("execute result is: {0}".format(result))
        except pymysql.Error as e:
            error_msg = "MySQL error! {0} {1}".format(e.args[0], e.args[1])
            logger.error(error_msg)
            result = ()
        return result

    def _safe(self, s):
        return pymysql.escape_string(s)

    def close(self):
        self.__del__()
