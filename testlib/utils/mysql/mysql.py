#!/usr/bin/env python3
# coding=utf-8


import time
import pymysql
from testlib.utils.logger import logger
from testlib.utils.env.service import Service


class Mysql(Service):

    MYSQL_KEYWORDS = ['account', 'filter', 'json', 'instance', 'range', 'status', 'before', 'after', 'begin', 'starts',
                      'stop', 'add', 'string', 'cache', 'name', 'names', 'mode',
                      'month', 'mutex', 'new', 'next', 'open', 'option', 'point', 'read', 'real', 'recover', 'remove',
                      'reload', 'resume',
                      'row', 'rows', 'singal', 'slave', 'type', 'tpyes', 'usage', 'week', 'work', 'year', 'channel']

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

    def select(self, table, keys, conditions=None, is_distinct=False, todict=False):
        keys = self._handle_keys(keys, table)
        sql = self._get_select_sql(table, keys, conditions, is_distinct)
        data = self.fetch_all_rows(sql, todict)
        return data

    def select_sql(self, sql, todict=False):
        return self.fetch_all_rows(sql, todict)

    def insert(self, table, column_dict, values):
        sql = self._get_insert_sql(table, column_dict, values)
        return self.execute(sql)

    def update(self, table, value, conditions):
        sql = self._get_update_sql(table, value, conditions)
        return self.execute(sql)

    def delete(self, table, conditions):
        sql = self._get_delete_sql(table, conditions)
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

    def execute_and_get_result(self, sql, todict=False):
        if 'select' in sql.lower():
            self._update_connect()
        if todict:
            cursor = self._conn.cursor(cursor=pymysql.cursors.DictCursor)
        else:
            cursor = self._conn.cursor()
        try:
            logger.info("execute sql:{0}".format(sql))
            cursor.execute(sql)
            data = cursor.fetchall()
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

    def _dict_to_key_value_separate_by_comma(self, data):
        """将字典变成，key='value',key='value' 的形式"""
        tmp_list = []
        for key, value in data.items():
            item = "{0}='{1}'".format(str(key), self._safe(str(value)))
            tmp_list.append(" " + item + " ")
        return ",".join(tmp_list)

    def _dict_to_key_value_separate_by_and(self, data):
        """将字典变成，key='value' and key='value'的形式"""
        if isinstance(data, str):
            return data
        tmp_list = []
        for key, value in data.items():
            if isinstance(value, str):
                item = "{0}='{1}'".format(key, self._safe(value))
            else:
                item = "{0}={1}".format(key, self._safe(str(value)))
            tmp_list.append(item)
        #             print tmp_list
        #             print "and".join(tmp_list)
        return " and ".join(tmp_list)

    def _get_select_sql(self, table, keys, conditions, is_distinct=0):
        """
        生成select的sql语句
        @table，查询记录的表名
        @key，需要查询的字段
        @conditions,查询的条件数据字典
        @is_distinct,查询的数据是否不重复
        """
        if is_distinct:
            sql = "select distinct {0} ".format(self._handle_select_keys(keys))
        if isinstance(keys, list):
            sql = "select {0} ".format(self._handle_select_keys(keys))
        elif not keys:
            sql = "select * "
        else:
            sql = "select {0} ".format(self._handle_select_keys(keys))
        sql += "from {0}".format(table)
        if conditions:
            if self._is_advance_condition(conditions):
                sql += " {0}".format(self._dict_to_key_value_separate_by_and(conditions))
            else:
                sql += " where {0}".format(self._dict_to_key_value_separate_by_and(conditions))
        return sql

    def _is_advance_condition(self, conditions):
        if isinstance(conditions, str):
            conditions = conditions.strip().lower()
            for advance in ['order by', 'group by', 'having']:
                if conditions.startswith(advance):
                    return True
        return False

    def _get_update_sql(self, table, value, conditions):
        """
                              生成update的sql语句
        @table，查询记录的表名
        @value，需要更新的字段字典
        @conditions,更新的条件数据字典
        """
        sql = "update {0} set ".format(table)
        sql += self._dict_to_key_value_separate_by_comma(value)
        if conditions:
            sql += " where {0}".format(self._dict_to_key_value_separate_by_and(conditions))
        return sql

    def _get_insert_sql(self, table, columnDict, values):
        """
                            生成insert的sql语句
        @table，插入记录的表名
        @dict,插入的数据，字典
        """
        sql = "INSERT INTO {0}".format(table)
        sql += " (" + self._dict_to_key_value_separate_by_comma(columnDict) + ")"
        sql += " VALUES (" + self._dict_to_key_value_separate_by_comma(values) + ")"
        return sql

    def _get_delete_sql(self, table, conditions):
        """
        生成detele的sql语句
        @table，查询记录的表名
        @conditions,删除的条件数据字典
        """
        sql = "delete from {0}".format(table)
        if conditions:
            sql += " where {0}".format(self._dict_to_key_value_separate_by_and(conditions))
        return sql

    def _select_data_to_dict(self, data, keys):
        keys = [key.split(' ')[-1].strip('`') for key in keys]

        data_dict_list = []
        if isinstance(data, tuple):
            for item in data:
                data_dict_list.append(dict(zip(keys, item)))
        else:
            for item in data:
                data_dict_list.append({keys: item[0]})
        if 1 == len(data_dict_list):
            return data_dict_list[0]
        else:
            return data_dict_list

    def _handle_keys(self, keys, table=None):
        if isinstance(keys, str):
            if '*' == keys:
                struct = self.fetch_all_rows('desc {0};'.format(table))
                keys = [key[0] for key in struct]
            else:
                keys = [key.strip() for key in keys.split(',')]
        return keys

    def _handle_select_keys(self, keys):
        selectKeys = ''
        for key in keys:
            if key.lower() in self.MYSQL_KEYWORDS:
                selectKeys += '`{0}`,'.format(key)
            else:
                selectKeys += '{0},'.format(key)
        return selectKeys[:-1]

    def close(self):
        self.__del__()
