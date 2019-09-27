#!/usr/bin/env python3
# coding=utf-8

from testlib.utils.logger import logger
from testlib.utils.env.service import ServiceRepository


class BbService:

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def bb_api(self, alias, interface, method='get', need_session=True, params=None, **data):
        bb = ServiceRepository().get(alias)
        is_success, result = bb.query(interface, method=method, need_session=need_session, params=params, **data)
        return is_success, result

    def env_get(self, alias, key):
        bb = ServiceRepository().get(alias)
        return bb.env_get(key)

