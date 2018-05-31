#!/usr/bin/env python
# -*- coding: utf-8 -*-
# https://github.com/mozillazg/python-pinyin
# http://eyed3.readthedocs.io/en/latest/

import os
import re
from pypinyin import pinyin, lazy_pinyin, Style
import argparse
import eyed3
from eyed3.id3 import Tag

# this script is customized for peppa pig
parser = argparse.ArgumentParser(description='This script is used to change tv shows name')
parser.add_argument("dir_path", type=str, help="directory path")
parser.add_argument("album_number", type=str, help="album number")
parser.add_argument("dry_run", type=str, help="dry_run")

args = parser.parse_args()
dir_path = args.dir_path
album_number = args.album_number
dry_run = args.dry_run


def get_pinyin_by_chinese(str):
    pinyin_list = lazy_pinyin(str, style=Style.TONE)
    # ài_wǒ_bié_zǒu
    pinyin = '_'.join(pinyin_list)
    # if it is artist str
    return pinyin.replace('_&_', '&')


def get_either_index(file, char1, char2):
    idx = -1
    if file.find(char1) >= 0:
        idx = file.find(char1)
    elif file.find(char2) >= 0:
        idx = file.find(char2)
    if idx < 0:
        raise ValueError
    return idx


def get_title(file):
    # remove all space before '('
    idx = get_either_index(file, '(', '（')
    return file[:idx].replace(" ", "")


def get_artists(file):
    # remove all space after ')'
    # use & if there is space within '()'
    start_idx = get_either_index(file, '(', '（')
    end_idx = get_either_index(file, ')', '）')
    # remove left and right space
    artists = file[(start_idx + 1):end_idx].strip()
    # convert multiple space into single space
    artists = re.sub(' +', ' ', artists)
    # replace space with &
    artists = artists.replace(' ', '&')
    return artists


def preprocess_file(file):
    file = file.replace(" (", "(")


def main():
    extension = '.mp3'
    for file in os.listdir(dir_path):
        if file.lower().endswith(extension):
            file_without_extension = file[:-len(extension)]
            title = get_pinyin_by_chinese(get_title(file_without_extension))
            artists = get_pinyin_by_chinese(get_artists(file_without_extension))

            old_name = os.path.join(dir_path, file)
            new_name = os.path.join(dir_path, title + '(' + artists + ')' + extension)
            if dry_run == 'False':
                # rename file
                os.rename(old_name, new_name)
                # edit mp3 tags
                audiofile = eyed3.load(new_name)
                audiofile.initTag()
                audiofile.tag.title = title
                audiofile.tag.artist = artists
                audiofile.tag.album = 'jīng_diǎn_gē_qǔ-' + album_number

                # audiofile.tag.save(version=eyed3.id3.ID3_DEFAULT_VERSION, encoding='utf-8')
                audiofile.tag.save()

            print(new_name)


if __name__ == '__main__':
    main()
