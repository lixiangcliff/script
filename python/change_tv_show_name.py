#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import re
import argparse
# this script is customized for peppa pig
parser = argparse.ArgumentParser(description='This script is used to change tv shows name')
parser.add_argument("dir_path", type=str, help="directory path")
parser.add_argument("show_name", type=str, help="name of tv show")
parser.add_argument("season_number", type=str, help="season number")
args = parser.parse_args()

dir_path = args.dir_path
show_name = args.show_name
season_number = args.season_number


def get_modified_peppa_name(file):
    episode_number = get_episode_number(file)
    new_file = file
    # make chinese_episode_number two digits
    chinese_episode_number = find_strings_in_between(file, '第', '集')
    if len(chinese_episode_number) == 1 and 1 <= int(chinese_episode_number) <= 9:
        new_chinese_episode_number = '0' + chinese_episode_number
        new_file = file.replace('第' + chinese_episode_number + '集', '第' + new_chinese_episode_number + '集')

    file = show_name + ' - s' + season_number + 'e' + episode_number + ' ' + new_file
    return file


def find_strings_in_between(str, left, right):
    result = re.search('(.*)' + left + '(.*)' + right + '(.*)', str)
    return result.group(2)


def get_episode_number(file):
    episode_number = find_strings_in_between(file, '.EP', '.1080P')
    return episode_number


def main():
    for file in os.listdir(dir_path):
        if file.lower().endswith(".mp4"):
            # 粉红猪小妹 第4集 Peppa.Pig.S01.2004.WEB-DL.EP04.1080P.H265.AAC-JBY@WEBHD.mp4
            old_name = os.path.join(dir_path, file)
            new_name = os.path.join(dir_path, get_modified_peppa_name(file))
            os.rename(old_name, new_name)
            print 'new name: ' + new_name


if __name__ == '__main__':
    main()