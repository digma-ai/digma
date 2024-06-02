#!/usr/bin/env python3

import os
from sys import platform
from typing import Dict


def delete_lines_containing(filename, text):
    with open(filename, 'r') as file:
        lines = file.readlines()

    lines_to_remove = [line for line in lines if text in line]
    new_lines = [ln for ln in lines if ln not in lines_to_remove]

    with open(filename, 'w') as file:
        file.writelines(new_lines)
    return lines_to_remove


def run():
    idepath = ''
    if platform == "linux" or platform == "linux2":
        idepath = os.path.join(os.path.expanduser('~'), '.config/JetBrains')
    elif platform == "darwin":
        idepath = os.path.join(os.path.expanduser('~'), 'Library/Application Support/JetBrains')
    elif platform == "win32":
        idepath = f'{os.getenv("APPDATA")}\JetBrains'
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
    selected_dir_name = menu_options[option]
    selected_path = os.path.join(idepath, selected_dir_name)
    options_path = os.path.join(selected_path, 'options')

    files_in_folder = os.listdir(options_path)
    print('Deleting files:')

    filename_to_remove = [os.path.join(options_path, filename) for filename in files_in_folder if filename.lower().startswith('digma')]
    for file_path in filename_to_remove:
        os.remove(file_path)
        print(file_path)
    if not filename_to_remove:
        print('No files to remove found2')
    print('')
    print('Modifying other.xml file:')
    lines_to_remove = delete_lines_containing(os.path.join(options_path, 'other.xml'), 'RunOnceActivity.org.digma')
    if lines_to_remove:
        for ln in lines_to_remove:
            print(ln)
    else:
        print('No lines to remove found')
    print('')

    print(f'All data has been reset, Please restart your Idea - {selected_dir_name}')


if __name__ == '__main__':
    run()
