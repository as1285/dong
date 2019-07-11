#!/usr/bin/env python3
# coding=utf-8


class HttpResult:

    def __init__(self, cmd=None):
        self._cmd = cmd
        self._success = True
        self._http_code = None
        self._headers = None
        self._cookies = None
        self._error = None
        self._input = None
        self._output = None

    @property
    def success(self):
        return self._success

    @success.setter
    def success(self, info):
        self._success = info

    @property
    def http_code(self):
        return self._http_code

    @http_code.setter
    def http_code(self, info):
        self._http_code = info

    @property
    def headers(self):
        return self._headers

    @headers.setter
    def headers(self, info):
        self._headers = info

    @property
    def cookies(self):
        return self._cookies

    @cookies.setter
    def cookies(self, info):
        self._cookies = info

    @property
    def error(self):
        return self._error

    @error.setter
    def error(self, info):
        self._error = info
        self.success = False

    @property
    def input(self):
        return self._input

    @input.setter
    def input(self, info):
        self._input = info

    @property
    def output(self):
        return self._output

    @output.setter
    def output(self, info):
        self._output = info
        self._success = True

    def to_dict(self):
        return {
            "success": self._success,
            "httpcode": self._http_code,
            "error": self._error,
            "headers": self._headers,
            "cookies": self._cookies,
            "input": self._input,
            "output": self._output
        }

    def __str__(self):
        return 'success: {0}, \nhttp_code: {1}, \nerror: {2} \nheaders: {3} \ncookies: {4} \ninput: {5} \noutput: {6}'.format(
            self._success, self._http_code, self._error, self._headers, self._cookies, self._input, self._output
            )
