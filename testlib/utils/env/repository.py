#!/usr/bin/env python3
# coding=utf-8


class Repository:

    def __init__(self):
        self._object_dict = {}

    def get(self, key):
        return self._object_dict.get(key)

    def add(self, key, value):
        self._object_dict[key] = value

    def has_key(self, key):
        return True if key in self._object_dict else False

    def keys(self):
        return self._object_dict.keys()

    def values(self):
        return self._object_dict.values()

    def remove(self, key):
        if self.has_key(key):
            del self._object_dict[key]

    def remove_all(self):
        self._object_dict = {}

    def is_empty(self):
        return not bool(self._object_dict)
