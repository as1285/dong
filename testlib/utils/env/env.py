#!/usr/bin/env python3
# coding=utf-8


import os
import json
import copy
from testlib.utils.singleton import singleton
from testlib.utils.logger import logger


@singleton
class Env(object):

    def __init__(self, env_file=None):
        self._service_key = 'services'
        self._env = {'env': []}
        if not env_file:
            env_dir = os.path.dirname(__file__) + os.sep + '..' + os.sep + '..' + os.sep + 'conf'
            env_file = os.path.abspath(os.path.join(env_dir, "env.json"))
        if env_file and os.path.exists(env_file):
            with open(env_file) as f:
                self._env = json.load(f)
        logger.info('env: {0}'.format(self._env))

    def get_env_by_id(self, ident):
        pservice, parent_dict = self.get_attr_by_id(ident)
        parent_dict = parent_dict if parent_dict else {}
        return self.update_parent_dict(parent_dict, pservice)

    def get_attr_by_id(self, ident):
        logger.info('begin get id {0} service'.format(ident))
        envs = (copy.deepcopy(self._env))['envs']
        for env in envs:
            if 'id' in env and env['id'] == ident:
                return env, None
            find, service, parent_dict = self._find_signal_service(ident, env.copy(), {})
            if find:
                return service, parent_dict
        return None, None

    def get_ids_by_type(self, service_type):
        logger.info('begin get ids {0}  service'.format(service_type))
        found_service_list = self.find_all_service_by_key_value('type', service_type)
        logger.info('found_service_list {0} '.format(found_service_list))
        if not found_service_list:
            return []
        return [service['id'] for service, _ in found_service_list]

    def get_id_by_attr_pair(self, key, value):
        for env in self._env.get('envs', []):
            for service in env.get('services', []):
                if service.get(key, None) == value:
                    return service
        return None

    def find_env_by_pservice_id(self, service_id):
        for env in self._env.get('envs', []):
            for service in env.get('services', []):
                if service.get('id', None) == service_id:
                    return env
        return None

    def get_all_services(self):
        services = []
        for env in self._env.get('envs', []):
            for service in env.get('services', []):
                services.append(service['id'])
        return services

    def insert_pservice_in_env(self, env_id, pservice_dict):
        for env in self._env.get('envs', []):
            if env['id'] == env_id:
                env['services'].append(copy.deepcopy(pservice_dict))
                break
        logger.info('self._env: {0}'.format(self._env))

    def delete_pservice_in_env(self, pservice_id):
        for env in self._env.get('envs', []):
            for pservice in env['services']:
                if pservice['id'] == pservice_id:
                    env['services'].remove(pservice)
                    break
        logger.info('self._env: {0}'.format(self._env))

    def get_attrs_of_env(self, env_id):
        for env in self._env.get('envs', []):
            if env['id'] == env_id:
                return copy.deepcopy(env)

    def find_all_service_by_key_value(self, key, value):
        envs = (copy.deepcopy(self._env))['envs']
        found_service_list = []
        for env in envs:
            self._find_all_service(value, env.copy(), {}, key, found_service_list=found_service_list)
        return found_service_list

    def _find_all_service(self, value,  service_parent, parent_dict={}, key='type', found_service_list=[]):
        if self._service_key not in service_parent:
            return found_service_list
        services = copy.deepcopy(service_parent[self._service_key])
        self.update_parent_dict(parent_dict, service_parent)
        for service in services:
            if key in service and service[key] == value:
                logger.info('find in  {0}, service {1}'.format(service[key], service))
                found_service_list.append((service, parent_dict))
            else:
                self._find_all_service(value, service, parent_dict, key, found_service_list)

    def _find_signal_service(self, value, service_parent, parent_dict={}, key='id'):
        if self._service_key not in service_parent:
            return False, None, None
        services = copy.deepcopy(service_parent[self._service_key])
        self.update_parent_dict(parent_dict, service_parent)
        for service in services:
            if key in service and service[key] == value:
                logger.info('find in  {0}, service {1}'.format(service[key], service))
                return True, service, parent_dict
            else:
                find, service,  _ = self._find_signal_service(value, service, parent_dict, key)
                if find:
                    return True, service,  parent_dict
        return False, None, None

    def update_parent_dict(self, parent_dict, service_parent):
        if parent_dict is None:
            return service_parent
        if self._service_key in service_parent:
            service_parent.pop(self._service_key)
        if 'type' in parent_dict:
            parent_dict.pop('type')
        parent_dict.update(service_parent)
        return parent_dict

    def get_sub_service_by_type(self, parent_id, sub_type):
        for env in self._env['envs']:
            service = self._get_service_by_id(env, parent_id)
            if service:
                logger.info("service:{0}".format(service))
                return self._get_service_by_type(service, sub_type)

    def _get_service_by_id(self, env, ident):
        for service in env.get('services', []):
            if ident == service.get('id', None):
                logger.info("id1:{0}".format(service.get('id', None)))
                return service
            else:
                logger.info("id2:{0}".format(service.get('id', None)))
                return self._get_service_by_id(service, ident)

    def _get_service_by_type(self, services, stype):
        for service in services.get('services', []):
            if stype == service.get('type', None):
                logger.info("type1:{0}".format(service.get('type', None)))
                return service
            else:
                logger.info("type2:{0}".format(service.get('type', None)))
                return self._get_service_by_id(service, type)


if __name__ == '__main__':
    app = Env()
