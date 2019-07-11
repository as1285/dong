#!/usr/bin/env python3
# coding=utf-8


from testlib.utils.env.service import Service
from testlib.utils.http.http import Http
from testlib.utils.logger import logger
from testlib.utils.encrypt_decrypt import EncryptDecrypt
from testlib.service.common.MysqlService import MysqlService


class Bitforex(Service):

    def __init__(self):

        self._http = Http(headers={"Content-Type": "application/json"})
        self._cookies = {}

    def init_env(self, env_dict=None):
        super().init_env(env_dict=env_dict)
        self.env_dict = env_dict
        self.url = 'http://{0}:{1}'.format(env_dict['ip'], env_dict['serviceport'])

    def env_get(self, key):
        return self.env_dict.get(key)

    def headers_create(self):
        sql = "select `user_id` from m_user.`us_user_baseinfo` where email='{0}'".format(self.env_dict.get('user'))
        data = MysqlService().select_sql('mysql', sql)
        user_id = str(data[0][0])
        user_id_hash = EncryptDecrypt().encrypt(user_id)
        headers = {
            "Content-Type": "application/json",
            "UserId": user_id_hash
        }
        return headers

    def query(self, path, method='get', need_session=True, timeout=None, params=None, **data):
        self.headers = self.headers_create()
        url = '{0}/{1}'.format(self.url, path)
        logger.info('url is {0}, data is {1}'.format(url, data))
        # if headers and 'Cookie' in headers and not self._cookies:
        #     cookie_list = [cookiesStr.split('=') for cookiesStr in headers.get('Cookie').split(';')]
        #     for cookieKey, value in cookie_list:
        #         self._cookies[cookieKey] = value

        if need_session:
            key = 'cookies_{0}'.format(self.env_dict.get('id'))
            cookies = self.env_dict.get(key)
            self._http.headers_modify(headers=self.headers)
        else:
            cookies = None

        logger.info('after  response cookies {0}'.format(self._cookies))
        http_result = self._http.request(url, method=method, need_session=need_session, headers=self.headers, cookies=cookies, timeout=timeout, params=params, **data)

        if http_result.success:
            return True, http_result.output
        return False, http_result.error

    def _set_cookies(self, headers=None):
        headers = headers or {}
        headers['Cookie'] = ';'.join(['{0}={1}'.format(key, value) for key, value in self._cookies.items()])
        return headers

    def _get_url(self, path):
        return '{0}/{1}'.format(self.url, path)
