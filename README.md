# Python Setup

This is an opinionated setup for using Python on MacOS, plus a python project base.

On a fresh Mac, the installed `Python` is 2.7. We need to:
- Install 3.9
- Set up for easy creation of per-project Virtual Environments
- Allow for running multiple versions of Python if needed in the future

How I got here: 

What I would do in the past is `brew install Python@3.9`, add an alias to my `.zshrc` for Python and Python3, and then go the pyenv/virtualenvwrapper route. But this was too automagic for me and all virtualenvs are stored in an outer directory. Next I switched to python's newer built in tool `python -m venv` to create in-directory virtual environments, but I ended up swinging to far back in the other direction and this workflow added more manual steps I'd need to script. 

Eventually I settled on using pyenv to manage my python versions, alongside direnv for directory-level auto control.

## New setup

```bash
brew install pyenv
brew install direnv
pyenv install 3.9.0
pyenv global 3.9.0
```
Add to .zshrc or .bash_profile:
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
Add to .zshrc or .bash_profile:
```bash
export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"
```

## Creating an ENV

Confirm active version (both should print 3.9.0)
```bash
pyenv global
python3 --version
```

To create a new venv in your current directory and auto-assume it whenever you enter the directory:
```bash
echo layout pyenv 3.9.0 > .envrc
direnv allow
```
You can enter any bash commands you'd like in your `.envrc`. I also include logic to log into AWS.

Any changes to the `.envrc` file requires rerunning `direnv allow`

To run `tox` on multiple versions of python, install other versions with `pyenv install x.x.x` then add all versions to the envrc spaced apart: `layout pyenv 3.9.0 3.8.6`


-----------------


# Python Base

- Clone this repo
- Create a venv
- Run `make setup`

## requirements.txt

To keep things as ordered and un-magicically as possible, deps are broken into 3 files in reqs/:
- requirements_dev.txt: the immediate packages needed to run `make` commands
- requirements_test.txt: packages needed to run `make test` and related commands
- requirements.txt: packages needed to run production code

all txt files are generated from running `pip-compile <file_name>`

## Pre-commit Hooks

This repo uses a `.pre-commit-config.yaml` to run commands before code is commited. The hook is installed by `make setup`. This repo runs a combination of flake8 + black + isort + standard whitespace/json/yaml checking. 

This can be run anytime with `make lint` 

There are two parts to note that allows all these tools to work together with black. In the config yaml isort is set to take in a `--profile black` setting, and in `setup.cfg` there's flake8 overrides. 
