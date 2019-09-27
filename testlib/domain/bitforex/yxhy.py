#!/usr/bin/env python3
# coding=utf-8


from testlib.domain.bitforex.common import Bitforex
from testlib.utils.encrypt_decrypt import EncryptDecrypt
from testlib.utils.logger import logger
from testlib.utils.mysql.mysql import Mysql


class Yxhy(Bitforex):

    def __init__(self):
        super().__init__()

    def init_env(self, env_dict=None):
        super().init_env(env_dict=env_dict)

    def query(self, path, method='get', need_session=True, timeout=None, params=None, **data):
        self.headers_create()
        return super().query(path, method=method, need_session=need_session, timeout=timeout, params=params, **data)


