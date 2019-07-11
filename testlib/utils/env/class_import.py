#!/usr/bin/env python3
# coding=utf-8


import importlib
from testlib.utils.env.class_map import class_map
from testlib.utils.env.env import Env
from testlib.utils.logger import logger


def create_obj(class_path, *args, **kwargs):
    logger.info('class_map: {0}'.format(class_path))
    (module_name, class_name) = class_path.rsplit('.', 1)
    module_meta = importlib.import_module(module_name)
    class_meta = getattr(module_meta, class_name)
    return class_meta(*args, **kwargs)


class ClassImport:

    @staticmethod
    def class_import(ident):
        service, parent_dict = Env().get_attr_by_id(ident)
        logger.info('service {0}, id: {1}  parent_dict{2}'.format(service, ident, parent_dict))
        assert bool(service), 'please check if env.json is ok!!!!'
        class_type = service['type']
        map_class = class_map[class_type]
        obj = create_obj(map_class)
        ClassImport._set_env(obj, service, parent_dict)
        return obj

    @staticmethod
    def _set_env(obj, service, parent_dict):
        env_dict = Env().update_parent_dict(parent_dict, service.copy())
        if 'ref' in env_dict:
            ref_dict = env_dict.pop('ref')
            ClassImport._set_ref(obj, ref_dict)
        if hasattr(obj, 'init_env'):
            obj.init_env(env_dict)
        if 'services' not in service:
            return
        services = service['services']
        for service_dict in services:
            sub_services = ClassImport._find_sub_service(obj, service_dict)
            for sub in sub_services:
                ClassImport._set_env(sub, service_dict, env_dict.copy())

    @staticmethod
    def _set_ref(obj, ref_dict):
        for key, ident in ref_dict.items():
            if hasattr(obj, key):
                logger.info('set ref : {0}'.format(key))
                ref_obj = ClassImport.class_import(ident)
                setattr(obj, key, ref_obj)

    @staticmethod
    def _find_sub_service(obj, service_dict):
        class_type = service_dict['type']
        class_full_name = class_map[class_type]
        all_attr = [getattr(obj, attr) for attr in dir(obj) if not attr.startswith("__")]
        return [attr for attr in all_attr if class_full_name == ClassImport._get_full_name(attr)]

    @staticmethod
    def _get_full_name(attr):
        return "{0}.{1}".format(attr.__class__.__module__, attr.__class__.__name__)
