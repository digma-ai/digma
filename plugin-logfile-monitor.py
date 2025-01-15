#!/usr/bin/env python3

import time
import os
from sys import platform
from typing import Dict

search_terms = ["UI was frozen for", "Digma: Api call", "Digma: Exception"]


def get_inode(filename):
    stat_info = os.stat(filename)
    return stat_info.st_ino

def get_selected_idea_path():
    idepath = ''
    additional_folder =''
    if platform == "linux" or platform == "linux2":
        idepath = os.path.join(os.path.expanduser('~'), '.cache/JetBrains')
        additional_folder = 'log'
    elif platform == "darwin":
        idepath = os.path.join(os.path.expanduser('~'), 'Library/Logs/JetBrains')
    elif platform == "win32":
        idepath = f'{os.getenv("LOCALAPPDATA")}\JetBrains'
        additional_folder = 'log'
    dir_names = []
    for dir_name in os.listdir(idepath):
        if not dir_name.startswith('Idea') and not dir_name.startswith('Rider'):
            continue
        dir_names.append(dir_name)
    dir_names.sort()
    menu_options: Dict[int, str] = {}
    idx = 1
    for name in dir_names:
        menu_options[idx] = name
        print(idx, '--', name)
        idx = idx + 1
    option = int(input('Choose Idea: '))
    idea_path = os.path.join(idepath, menu_options[option])
    if additional_folder:
        return os.path.join(idea_path, additional_folder)
    return idea_path
def monitor_log(logfile):
    print(f'start monitoring: {logfile}')
    while True:
        with open(logfile, "r") as file:
            # Move the file pointer to the end of the file
            file.seek(0, 2)
            previous_inode = None
            while True:
                try:
                    current_inode = get_inode(logfile)
                    if previous_inode is not None and previous_inode != current_inode:
                        print(f"File '{logfile}' was moved and replaced, restart the monitor...")
                        break
                    previous_inode = current_inode
                    line = file.readline()
                    if line:
                        for term in search_terms:
                            if term in line:
                                print(line.strip())
                                break
                    else:
                        # Wait before checking again
                        time.sleep(0.1)
                except FileNotFoundError:
                    time.sleep(0.1)


def run():
    idea_path = get_selected_idea_path()
    monitor_log(os.path.join(idea_path, 'idea.log'))
if __name__ == "__main__":
    run()