#!/usr/bin/env python3
# coding=utf-8


from testlib.utils.env.service import ServiceRepository


class RedisService:
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def flush_all(self, alias):
        "Delete all keys in all databases on the current host"
        ServiceRepository().get(alias).flush_all()

    def flush_db(self, alias, db=0):
        "Delete all keys in the current database"
        ServiceRepository().get(alias).flush_db(int(db))

    def keys(self, alias, key="*", db=0):
        return ServiceRepository().get(alias).keys(key, int(db))

    def delete(self, alias, names, db=0):
        return ServiceRepository().get(alias).delete(names, int(db))

    def exists(self, alias, name, db=0):
        return ServiceRepository().get(alias).exists(name, int(db))

    def hkeys(self, alias, key="*", db=0):
        return ServiceRepository().get(alias).hkeys(key, int(db))

    def hdel(self, alias, name, keys, db=0):
        return ServiceRepository().get(alias).hdel(name, keys, int(db))

    def get(self, alias, name, db=0, toDict=False):
        return ServiceRepository().get(alias).get(name, int(db), toDict)

    def set(self, alias, name, value, db=0):
        return ServiceRepository().get(alias).set(name, value, int(db))

    def hget(self, alias, name, field, db=0, toDict=False):
        return ServiceRepository().get(alias).hget(name, field, int(db), toDict)

    def hset(self, alias, name, field, data, db=0, toJson=False):
        return ServiceRepository().get(alias).hset(name, field, data, int(db), toJson)

    def hgetall(self, alias, name, db=0):
        return ServiceRepository().get(alias).hgetall(name, int(db))

    def smembers(self, alias, name, db=0):
        return ServiceRepository().get(alias).smembers(name, int(db))

    def lindex(self, alias, name, index, db=0):
        return ServiceRepository().get(alias).lindex(name, int(index), int(db))

    def llen(self, alias, name, db=0):
        return ServiceRepository().get(alias).llen(name, int(db))

    def lrange(self, alias, name, start, end, db=0):
        return ServiceRepository().get(alias).lrange(name, int(start), int(end), int(db))

    def zrangebyscore(self, alias, name, min=None, max=None, start=None, num=None,
                      withscores=True, score_cast_func='float', db=0):
        return ServiceRepository().get(alias).zrangebyscore(name, min, max, start, num,
                                                             withscores, score_cast_func, int(db))