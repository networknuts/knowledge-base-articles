"""Small JSON configuration validator with meaningful command-line exit status."""
import json
from pathlib import Path
import sys

def load_config(path):
    value=json.loads(Path(path).read_text())
    if not isinstance(value,dict):raise ValueError('Configuration must be an object')
    port=value.get('port')
    if type(port) is not int or not 1 <= port <= 65535:
        raise ValueError('port must be an integer from 1 to 65535')
    return value

if __name__=='__main__':
    if len(sys.argv)!=2:
        print('Usage: python3 validate_config.py FILE',file=sys.stderr);sys.exit(2)
    try:
        config=load_config(sys.argv[1])
    except (OSError,ValueError) as error:
        print(f'Invalid configuration: {error}',file=sys.stderr);sys.exit(1)
    print(f'Configuration accepted: port={config["port"]}')
