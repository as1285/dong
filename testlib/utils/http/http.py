#!/usr/bin/env python3
# coding=utf-8


import time
import json
import traceback
import requests
from testlib.utils.logger import logger
from testlib.utils.http.http_result import HttpResult
from testlib.utils.http.http_parse import HttpParser


def re_try_while_error_occured(times, interval):
    def _re_try(func):
        def __re_try(*args, **kargs):
            for index in range(times):
                http_result = func(*args, **kargs)
                if http_result.success:
                    break
                else:
                    logger.info(u'error is {0}, sleep: {1}seconds, and try again'.format(HttpResult.error, interval))
                    if index < times - 1:
                        time.sleep(interval)
            return http_result
        return __re_try
    return _re_try


class Http:

    def __init__(self, headers=None):
        self.headers = headers

    def headers_modify(self, headers=None):
        self.headers = headers

    def request(self, url, method='get', need_session=True, headers=None, cookies=None, timeout=None, params=None, **data):
        return self._request(url, method=method, need_session=need_session,  headers=headers, cookies=cookies, timeout=timeout, params=params, **data)

    @re_try_while_error_occured(3, 30)
    def request_re_try(self, url, method='get', need_session=True, headers=None, cookies=None, timeout=None, params=None, **data):
        return self._request(url, method=method, need_session=need_session,  headers=headers, cookies=cookies, timeout=timeout, params=params, **data)

    def _request(self, url, method='get', need_session=True, headers=None, cookies=None, timeout=None, params=None, **data):
        self.headers = headers
        if need_session:
            self.cookies = cookies
        else:
            self.cookies = None
        http_result = HttpResult(url)
        try:
            if not method:
                method = 'get'
            if method.lower() == 'get':
                res = requests.get(url, params=params, headers=self.headers, cookies=self.cookies, timeout=timeout)
            elif method.lower() == 'post':
                if data:
                    data = json.dumps(data)
                res = requests.post(url, params=params, data=data, headers=self.headers, cookies=self.cookies, timeout=timeout)
            elif method.lower() == 'delete':
                if data:
                    data = json.dumps(data)
                res = requests.delete(url, params=params, data=data, headers=self.headers, cookies=self.cookies, timeout=timeout)
            elif method.lower() == 'post':
                if data:
                    data = json.dumps(data)
                res = requests.delete(url, params=params, data=data, headers=self.headers, cookies=self.cookies, timeout=timeout)
            else:
                res = requests.get(url, params=params, data=data, headers=self.headers, cookies=self.cookies, timeout=timeout)
        except Exception as e:
            logger.warn(u'http requests error   : {0}'.format(e))
            traceback.print_exc()
            http_result.error = e
        else:
            HttpParser(self).parse(res, http_result)
        return http_result
