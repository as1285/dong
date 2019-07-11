#!/usr/bin/env python3
# coding=utf-8

from testlib.utils.env.service import ServiceRepository


class MysqlService:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def select(self, alias, table, keys, conditions, isdistinct=False, todict=False):
        return ServiceRepository().get(alias).select(table, keys, conditions, isdistinct, todict)

    def select_sql(self, alias, sql, todict=False):
        return ServiceRepository().get(alias).select_sql(sql, todict)

    def flush_tables(self, alias, sleep_seconds):
        return ServiceRepository().get(alias).flush_tables(int(sleep_seconds))

    def delete(self, alias, table, conditions):
        return ServiceRepository().get(alias).delete(table, conditions)

    def truncate(self, alias, table):
        return ServiceRepository().get(alias).truncate(table)

    def execute_sql(self, alias, sql, todict=False):
        return ServiceRepository().get(alias).execute(sql, todict)

    def execute_and_get_result(self, alias, sql, todict=False):
        return ServiceRepository().get(alias).execute_and_get_result(sql, todict)

    def source(self, alias, sql_file, db=None):
        return ServiceRepository().get(alias).source(sql_file, db)

    def update(self, alias, table, value, conditions):
        return ServiceRepository().get(alias).update(table, value, conditions)
