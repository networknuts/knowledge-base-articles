from pathlib import Path
import subprocess
import sys

cases=[('valid.json','{"port":8080}',0),('malformed.json','{"port":}',1),
       ('string-port.json','{"port":"8080"}',1),('boolean-port.json','{"port":true}',1),
       ('large-port.json','{"port":70000}',1)]
records=[]
for name,body,expected in cases:
    Path(name).write_text(body+'\n')
    result=subprocess.run([sys.executable,'validate_config.py',name],capture_output=True,text=True)
    assert result.returncode==expected
    print(f'{name}: exit={result.returncode} (expected {expected})')
    records.append('$ python3 validate_config.py '+name+'\n'+result.stdout+result.stderr+f'exit={result.returncode}\n')
Path('details.txt').write_text('\n'.join(records))
print('PASS: syntax validity and application-level validation are separate checks.')
