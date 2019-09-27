#!/usr/bin/env python3
# coding=utf-8

from testlib.utils.env.service import ServiceRepository


class MysqlService:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def select_sql(self, alias, sql, todict=False):
        return ServiceRepository().get(alias).select_sql(sql, todict)

    def flush_tables(self, alias, sleep_seconds):
        return ServiceRepository().get(alias).flush_tables(int(sleep_seconds))

    def execute_sql(self, alias, table, conditions):
        return ServiceRepository().get(alias).execute_sql(table, conditions)

    def truncate(self, alias, table):
        return ServiceRepository().get(alias).truncate(table)

    def source(self, alias, sql_file, db=None):
        return ServiceRepository().get(alias).source(sql_file, db)

