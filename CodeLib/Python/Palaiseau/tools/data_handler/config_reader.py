#encoding:utf-8

import ConfigParser
import os
import tools

#获取config配置文件
def getConfig(section, key,path):
    config = ConfigParser.ConfigParser()
    config.read(path)
    return config.get(section, key)


def freq_config(frequency):
    config_path = tools.get_config_file_path()
    frequency = frequency.lower()
    freq = getConfig('frequency', frequency, config_path)
    return freq

