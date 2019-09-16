#!/usr/bin/env python3
# coding=utf-8


import json
from testlib.utils.logger import logger


class HttpParser:

    def __init__(self, http):
        self._http = http

    def parse(self, res, http_result):
        self._parse_headers(res, http_result)
        self._parse_cookies(http_result)
        self._parse_http_code(res, http_result)
        self._parse_body(res, http_result)

    def _parse_headers(self, res, http_result):
        headers = res.headers
        http_result.headers = headers

    def _parse_body(self, res, http_result):
        content = res.content.decode()
        try:
            http_result.output = content
            if len(content) > 2000:
                logger.info('http response is  : {0}...'.format(content[0:2000]))
            else:
                logger.info('http response is  : {0}'.format(content))
            try:
                output = json.loads(content)
            except Exception as e:
                logger.info('body is not json format: {0}'.format(e))
                output = None
            http_result.output = output
        except Exception as e:
            logger.info('parse body error: {0}'.format(e))

    def _parse_http_code(self, res, http_result):
        http_result.http_code = res.status_code

    def _parse_cookies(self, http_result):
        cookies = self._http.cookies
        if cookies:
            cookies_dict = {}
            for k, v in cookies.items():
                cookies_dict[k] = v
            http_result.cookies = cookies_dict
