#!/usr/bin/env python3
# coding=utf-8

import os
import logging.handlers


def get_logger():
    current_path = os.path.join(os.path.dirname(__file__))
    log_path = current_path + os.sep + 'logs'
    if not os.path.exists(log_path):
        os.mkdir(log_path)
    log_file = os.path.join(log_path, 'autotest.log')
    my_logger = logging.getLogger('autotest')
    my_logger.propagate = True
    my_logger.setLevel(logging.DEBUG)
    formatter = logging.Formatter("%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s")
    fhandler = logging.handlers.RotatingFileHandler(log_file, encoding='utf-8', maxBytes=10*1024*1024, backupCount=50)
    fhandler.setFormatter(formatter)
    fhandler.setLevel(logging.DEBUG)
    my_logger.addHandler(fhandler)
    stdhandler = logging.StreamHandler()
    stdhandler.setLevel(logging.DEBUG)
    stdhandler.setFormatter(formatter)
    my_logger.addHandler(stdhandler)
    return my_logger


logger = get_logger()
