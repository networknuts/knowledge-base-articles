"""Observe Linux creation permissions in a disposable directory."""
import os
from pathlib import Path
import stat
import subprocess

rows=[]
for mask in [0o022, 0o027, 0o077]:
    previous=os.umask(mask)
    try:
        path=Path(f'mask-{mask:03o}');path.mkdir()
        file=path/'sample.txt'
        with file.open('w') as stream:stream.write('permission example\n')
        file_mode=stat.S_IMODE(file.stat().st_mode);dir_mode=stat.S_IMODE(path.stat().st_mode)
        assert file_mode == (0o666 & ~mask)
        assert dir_mode == (0o777 & ~mask)
        rows.append(f'umask {mask:03o}: new file {file_mode:03o}; new directory {dir_mode:03o}')
    finally:os.umask(previous)
file=Path('mask-077/sample.txt');file.chmod(0o644)
assert stat.S_IMODE(file.stat().st_mode)==0o644
print('\n'.join(rows))
print('Explicit chmod 644 changed the existing 600 file to 644.')
listing=subprocess.run(['find','mask-022','mask-027','mask-077','-printf','%m %p\n'],text=True,capture_output=True,check=True).stdout
Path('details.txt').write_text('$ find mask-022 mask-027 mask-077 -printf "%m %p\\n"\n'+listing)
print('PASS: umask removed permission bits at creation; explicit chmod changed an existing file.')
