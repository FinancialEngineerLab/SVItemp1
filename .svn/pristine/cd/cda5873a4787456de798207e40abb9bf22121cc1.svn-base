import os


def remove_incorrect_path_for_config_file(path):
    pathSet = os.path.split(path)
    while not pathSet[1] == 'Palaiseau':
        pathSet = pathSet[0]
        pathSet = os.path.split(pathSet)
    return pathSet

def get_config_file_path(fileName = 'proj_config.conf'):
     path = os.path.dirname(os.path.dirname(os.path.abspath("__file__")))
     path = remove_incorrect_path_for_config_file(path)
     path = path[0] + '\\' + path[1] + '\\'+ fileName
     return path

if __name__ == "__main__":
    print get_config_file_path()
