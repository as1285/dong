#!/usr/bin/env python3
# coding=utf-8


import hmac
from testlib.domain.bitforex.common import Bitforex
from testlib.utils.logger import logger


class Bb(Bitforex):

    def __init__(self):
        super().__init__()

    def init_env(self, env_dict=None):
        super().init_env(env_dict=env_dict)

    def sign(self, dic, path):
        s = path + '?'
        for k in sorted(dic):
            s += '{0}={1}&'.format(k, str(dic.get(k)))
        if s.endswith("&"):
            s = s[:-1]
        s_sign = hmac.HMAC(self.secret_key.encode(), s.encode(), digestmod='SHA256')
        return s_sign.hexdigest()

    def query(self, path, method='get', need_session=True, timeout=None, params=None, **data):
        url = '{0}/{1}'.format(self.url, path)
        logger.info('url is {0}, data is {1}'.format(url, data))
        self.access_key = self.env_dict.get('access_key')
        self.secret_key = self.env_dict.get('secret_key')
        if params:
            params['accessKey'] = self.access_key
            sign_data = self.sign(params, path)
            params['signData'] = sign_data
        return super().query(path, method=method, need_session=need_session, timeout=timeout, params=params, **data)



