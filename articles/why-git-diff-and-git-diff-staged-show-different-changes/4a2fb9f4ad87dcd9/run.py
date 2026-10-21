"""Compare HEAD, index and worktree in a new disposable local repository."""
from pathlib import Path
import subprocess

def git(*args):
    return subprocess.run(['git',*args],capture_output=True,text=True,check=True).stdout

git('init','-q');git('config','user.name','Network Nuts lab');git('config','user.email','lab@example.invalid')
Path('settings.txt').write_text('workers=1\n');git('add','settings.txt');git('commit','-qm','Baseline')
Path('settings.txt').write_text('workers=2\n');git('add','settings.txt')
Path('settings.txt').write_text('workers=3\n')
status=git('status','--short');assert status.startswith('MM settings.txt')
unstaged=git('diff','--','settings.txt');staged=git('diff','--cached','--','settings.txt')
assert '-workers=2' in unstaged and '+workers=3' in unstaged
assert '-workers=1' in staged and '+workers=2' in staged
assert git('show','HEAD:settings.txt')=='workers=1\n'
assert git('show',':settings.txt')=='workers=2\n'
print('HEAD: workers=1\nIndex: workers=2\nWorking tree: workers=3')
print('$ git status --short\n'+status,end='')
Path('details.txt').write_text('$ git diff --cached -- settings.txt\n'+staged+'\n$ git diff -- settings.txt\n'+unstaged)
print('PASS: the staged and unstaged diffs compare different snapshots.')
