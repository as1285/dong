#!/usr/bin/env python3
# coding=utf-8


import redis
from testlib.utils.logger import logger
from testlib.utils.env.service import Service


class Redis(Service):

    def init_env(self, env_dict=None):
        Service.init_env(self, env_dict)
        self._ip = env_dict['ip']
        self._port = int(env_dict['dbport'])
        self._passwd = env_dict.get('dbpwd', None)
        self._redis = {0: redis.Redis(host=self._ip, port=self._port, password=self._passwd, db=0)}

    def flush_all(self):
        "Delete all keys in all databases on the current host"
        self._redis[0].flushall()

    def flush_db(self, db=0):
        "Delete all keys in the current database"
        self._check_add_redis(db)
        logger.info("redis flush db {0}".format(db))
        self._redis[db].flushdb()

    def keys(self, key="*", db=0):
        self._check_add_redis(db)
        return self._redis[db].keys(key)

    def delete(self, names, db=0):
        self._check_add_redis(db)
        return self._redis[db].delete(*names)

    def exists(self, key, db=0):
        self._check_add_redis(db)
        return self._redis[db].exists(key)

    def hkeys(self, key="*", db=0):
        self._check_add_redis(db)
        return self._redis[db].hkeys(key)

    def hdel(self, name, keys, db=0):
        self._check_add_redis(db)
        return self._redis[db].hdel(name, *keys)

    def set(self, name, value, db, ex=None, px=None, nx=False, xx=False):
        self._check_add_redis(db)
        result = self._redis[db].set(name, value, ex, px, nx, xx)
        logger.debug('set key {0} to redis, and the result is {1}'.format(name, result))
        return result

    def get(self, name, db=0):
        self._check_add_redis(db)
        result = self._redis[db].get(name)
        logger.debug('get key {0} from redis, and the result is {1}'.format(name, result))
        return result

    def hget(self, name, field, db=0):
        self._check_add_redis(db)
        return self._redis[db].hget(name, field)

    def hset(self, name, field, value, db=0):
        self._check_add_redis(db)
        return self._redis[db].hset(name, field, value)

    def hgetall(self, name, db=0):
        self._check_add_redis(db)
        return self._redis[db].hgetall(name)

    def smembers(self, name, db=0):
        self._check_add_redis(db)
        return self._redis[db].smembers(name)

    def zrangebyscore(self, name, min, max, start=None, num=None,
                      withscores=False, score_cast_func=float, db=0):
        self._check_add_redis(db)
        return self._redis[db].zrangebyscore(name, min, max, start, num,
                                             withscores, score_cast_func)

    def exe_cmd_by_action(self, action, *args, **kargs):
        func = getattr(self._redis[0], action.lower())
        return func(*args, **kargs)

    def exe_cmd_in_any_db_by_action(self, action, db, *args, **kargs):
        self._check_add_redis(db)
        func = getattr(self._redis[db], action.lower())
        return func(*args, **kargs)

    def _check_add_redis(self, db):
        if db not in self._redis:
            self._redis[db] = redis.Redis(host=self._ip, port=self._port, password=self._passwd, db=db)