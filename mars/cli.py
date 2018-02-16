#!/usr/bin/env python

import sys, getopt
from colorama import Fore, Style


class CommandLineInterface(object):

    def __init__(self):
        self.file_name = ''
        self.verbose_flag = False
        self.log_flag = False

    def display_title(self):
        title = '  _ __ ___   __ _ _ __ ___ ' + '\n' + \
                ' | \'_ ` _ \ / _` | \'__/ __|' + '\n' + \
                ' | | | | | | (_| | |  \__ \\' + '\n' + \
                ' |_| |_| |_|\__,_|_|  |___/'

        print(Fore.RED + title)
        print(Style.RESET_ALL)

        print(' Multi-Agent Robotic Simulator')
        print(' ')
        print(' Copyright (c) 2018, Donato Di Paola')
        print(' Released under BSD 3-Clause License')
        print(' ')

    def display_help(self):
        print(' ')
        print('Usage:')
        print('    mars -c <configuration_file> [options] ')
        print('Options:')
        print('    -h, --help                           show this help message and exit')
        print('    -c <configuration_file> [required]   load configuration from file')
        print('    -v, --verbose                        print status messages')
        print('    -l, --log                            log status messages to a file')
        print(' ')

    def parse(self):

        try:
            opts, args = getopt.getopt(sys.argv[1:], "c:hvl", ["help", "verbose", "log"])
        except getopt.GetoptError as err:
            print('[ERROR] ' + str(err))
            self.display_help()
            return False
        for opt, arg in opts:
            if opt == "-c":
                self.file_name = arg
            elif opt in ("-h", "--help"):
                self.display_help()
                return False
            elif opt in ("-v", "--verbose"):
                self.verbose_flag = True
            elif opt in ("-l", "--log"):
                self.log_flag = True
            else:
                print('[ERROR] Invalid option')
                self.display_help()
                return False

        if not '-c' in sys.argv:
            print('[ERROR] Missing required parameter: -c <configuration_file>')
            self.display_help()
            return False

        return True

