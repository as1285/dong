#!/usr/bin/env python3
# coding=utf-8


from testlib.utils.http.http import Http


class HttpService:

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def request(self, url, method='get', need_session=False, headers=None, cookies=None, timeout=None, params=None, **data):
        http_result = Http().request(url, method=method, need_session=need_session, headers=headers, cookies=cookies, timeout=timeout, params=params, **data)
        return http_result.to_dict()
