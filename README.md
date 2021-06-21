# Python Setup

This is an opinionated setup for using Python on MacOS.

On a fresh Mac, the installed `Python` is 2.7. We need to:
- Install 3.9
- Set up for easy creation of per-project Virtual Environments
- Allow for running multiple versions of Python if needed in the future

What I would do in the past is `brew install Python@3.9` then add an `alias` to my `.zshrc` for `Python` and Python3`

## New setup
What I'd recommend doing now is use `pyenv`+`direnv` to install and control all virtualenvs

```bash
brew install pyenv
brew install direnv
pyenv install 3.9.0
pyenv global 3.9.0
```
finally, add to .zshrc or .bash_profile:
```bash
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
eval "$(direnv hook zsh)" #or hook bash
```


### if `pyenv install` fails

```bash
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install

brew reinstall zlib bzip2
```
add to .zshrc or .bash_profile:
```bash
export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"
```

## Creating an ENV

Confirm activative version (both should print 3.9.0)
```bash
pyenv global
python3 --version
```

to create a new venv in your current directory and auto-assume it:
```bash
echo layout pyenv 3.9.0 > .envrc
direnv allow
```

any changes to the `.envrc` file require re-approving the file.

To run `tox` on multiple versions of python, install other versions with `pyenv install x.x.x` then add all versions to the envrc spaced apart: `layout pyenv 3.9.0 3.8.6`


# requirements.txt

To keep things as ordered and "un-magicically" as possible, deps are broken into 3 files in reqs/:
- requirements_dev.txt: the immediate packages needed to run `make` commands
- requirements_test.txt: packages needed to run `make test` and related commands
- requirements.txt: packages needed to run production code

all txt files are generated from running `pip-compile <file_name>`

