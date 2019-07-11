#!/usr/bin/env python3
# coding=utf-8


from testlib.utils.env.service import ServiceRepository


class YxhyService:

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def yxhy_api(self, alias, interface, method='get', need_session=True, params=None, **data):
        yxhy = ServiceRepository().get(alias)
        is_success, result = yxhy.query(interface, method=method, need_session=need_session, params=params, **data)
        return is_success, result

    def env_get(self, alias, key):
        yxhy = ServiceRepository().get(alias)
        return yxhy.env_get(key)
