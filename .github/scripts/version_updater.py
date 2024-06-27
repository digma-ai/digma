from typing import List

from ruamel.yaml import YAML
import sys


def update_version(version, file_path):
    yml = YAML()
    with open(file_path, 'r') as file:
        compose = yml.load(file)
    image: str = compose['services']['digma-compound']['image']
    image_name = image.split(':')[0]
    compose['services']['digma-compound']['image'] = f'{image_name}:{version}'

    environments: List[str] = compose['services']['digma-compound']['environment']

    app_version_env: str = next(e for e in environments if e.startswith('ApplicationVersion'))
    environments.remove(app_version_env)

    environments.append(f'ApplicationVersion={version}')
    with open(file_path, 'w') as file:
        yml.dump(compose, file)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: update_chart_version.py <new-version> <docker-compose-path>")
        sys.exit(1)

    new_version = sys.argv[1]  # '1.1.1'
    file_path = sys.argv[2]  # 'docker-compose.yaml'  # Adjust this path if needed

    update_version(new_version, file_path)
