"""Run in a fresh disposable directory alongside playbook.yml and app.conf.j2."""
from pathlib import Path
import re
import stat
import subprocess

command = ['ansible-playbook', '-i', 'localhost,', 'playbook.yml']
outputs = []
for label, extra in [('First apply', []), ('Second identical apply', []),
                     ('Preview a changed variable', ['--check', '--diff', '-e', 'app_port=9090'])]:
    result = subprocess.run(command + extra, text=True, capture_output=True, check=True)
    output = result.stdout
    outputs.append(label + '\n$ ' + ' '.join(command + extra) + '\n' + output)
    recap = re.search(r'localhost\s+:\s+ok=\d+\s+changed=(\d+).*failed=(\d+)', output)
    assert recap and recap.group(2) == '0', output
    changed = int(recap.group(1))
    assert changed == (0 if label == 'Second identical apply' else 1), output
    handler_ran = 'RUNNING HANDLER' in output
    assert handler_ran == (label != 'Second identical apply'), output
    print(f'{label}: changed={changed}; handler ran={handler_ran}')
config = Path('app.conf')
assert config.read_text() == 'port=8080\nworkers=2\n'
assert stat.S_IMODE(config.stat().st_mode) == 0o640
print('After check mode, app.conf is unchanged:')
print(config.read_text(), end='')
print('File mode:', oct(stat.S_IMODE(config.stat().st_mode)))
Path('details.txt').write_text('\n\n'.join(outputs))
print('PASS: second apply made no change; check mode predicted a change without writing it.')
