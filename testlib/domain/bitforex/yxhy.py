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
        # self.headers()

    # def user_get(self):
    #     return self.env_dict.get('user')


