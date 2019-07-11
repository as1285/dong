#!/usr/bin/env python3
# coding=utf-8

from testlib.utils.env.class_import import ClassImport
from testlib.utils.env.repository import Repository
from testlib.utils.singleton import singleton


class Service:

    def init_env(self, env_dict=None):
        self.env_dict = env_dict

    def delete(self, *args, **kargs):
        pass

    @property
    def alias(self):
        return self.env_dict.get('id')


@singleton
class ServiceRepository(Repository):

    def __init__(self):
        super().__init__()

    def get(self, ident):
        if self.has_key(ident):
            return super().get(ident)
        else:
            service = ClassImport.class_import(ident)
            Repository.add(self, ident, service)
            return service
