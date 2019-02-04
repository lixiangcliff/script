#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import time
import sys
import argparse
from termcolor import colored

EASY_QUESTION_COUNT_PER_SESSION = 3
MEDIUM_QUESTION_COUNT_PER_SESSION = 2
HARD_QUESTION_COUNT_PER_SESSION = 1

EASY_QUESTION_DURATION = 15
MEDIUM_QUESTION_DURATION = 25
HARD_QUESTION_DURATION = 50

SESSION_BELL_COUNT = 3
BREAK_BELL_COUNT = 5

parser = argparse.ArgumentParser(description='This script is set timer for different sessions, each session is about 50 minutes + 10 minutes break')
parser.add_argument("-e", default=1, type=int, help="easy session count(each easy session contains 3 easy questions)")
parser.add_argument("-m", default=1, type=int, help="medium session count(each medium session contains 2 medium questions)")
parser.add_argument("-d", default=1, type=int, help="hard session count(each hard session contains 1 hard question)")
args = parser.parse_args()

easy_session_count = args.e
medium_session_count = args.m
hard_session_count = args.d


def countdown(duration):
    #convert to second
    duration *= 60
    duration = int(duration)
    while duration >= 0:
        try:
            mins, secs = divmod(duration, 60)
            timeformat = '{:02d}:{:02d}'.format(mins, secs)
            print(timeformat, end='\r')
            time.sleep(1)
            duration -= 1
        except KeyboardInterrupt:
            print ('\nPausing...  (Hit ENTER to continue, type "done" to finish this session.)')
            try:
                response = input()
                if response == 'done':
                    print ('Done!')
                    break
            except KeyboardInterrupt:
                print ('Resuming...')
                continue


def session(title, color, minute, bell_count):
    print(colored('%s (%s minutes) in progress...' % (title, minute), color))
    countdown(minute)
    ring_bell(bell_count)
    print(colored('\n%s done!\n' % title, color))


def ring_bell(bell_count):
    for i in range(bell_count):
        sys.stdout.write('\a')
        sys.stdout.flush()
        time.sleep(0.2)


def easy_session():
    for i in range(EASY_QUESTION_COUNT_PER_SESSION):
        session("Easy_" + str(i + 1), 'green', EASY_QUESTION_DURATION, SESSION_BELL_COUNT)


def medium_session():
    for i in range(MEDIUM_QUESTION_COUNT_PER_SESSION):
        session("Medium_" + str(i + 1), 'yellow', MEDIUM_QUESTION_DURATION, SESSION_BELL_COUNT)


def hard_session():
    for i in range(HARD_QUESTION_COUNT_PER_SESSION):
        session("Hard_" + str(i + 1), 'red', HARD_QUESTION_DURATION, SESSION_BELL_COUNT)


def break_session():
    session("Break", 'blue', 10, BREAK_BELL_COUNT)

#sample cmd: python3 python/timer.py -e 1 -m 1 -d 1
def main():
    for i in range(easy_session_count):
        easy_session()
        break_session()

    for i in range(medium_session_count):
        medium_session()
        break_session()

    for i in range(hard_session_count):
        hard_session()
        break_session()

    print("All sessions have finished!")

if __name__ == '__main__':
    main()