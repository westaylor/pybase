# Python Setup

This is an opinionated setup for using Python on MacOS, plus a python project base.

On a fresh Mac, the installed `Python` is 2.7. We'd like to:
- Install 3.9
- Allow for running multiple versions of python as needed by other projects
- Set up for easy creation of per-project Virtual Environments
- Add some amount of automation for setting up our environment, to smoothen onboarding

How I got here:

What I would do in the past is `brew install Python@3.9`, add an alias to my dotfile for Python and Python3, and then use that Python instance to install pyenv/virtualenvwrapper and related tools. There was still too big of an automagic disconnect for my liking, so next I switched to python's built in tool `python -m venv` to create in-directory virtual environments. Eventually I settled on a hybrid I liked, by using pyenv to manage my python versions, alongside direnv for auto assuming and creating in-directory virtual environments.

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

if `pyenv install X.X.X` fails,

```bash
# only needed if 'pyenv install' fails
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install

brew reinstall zlib bzip2
```

Add to .zshrc or .bash_profile:
```bash
# only needed if 'pyenv install' fails
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
You can enter any bash commands you'd like in your `.envrc`. I also include logic for assuming AWS roles.

Note: Any changes to the `.envrc` file requires rerunning `direnv allow`. You'll always get an active error reminding you.

To run `tox` on multiple versions of python, install other versions with `pyenv install x.x.x` then add all versions to the envrc spaced apart: `layout pyenv 3.9.0 3.8.6`



Recreating a virtualenv from scratch is as simple as:
```bash
rm -rf .direnv
cd ..
cd <YourFolderName>
```
-----------------


# Python Base

- Clone this repo
- Create a venv
- Run `make compile` followed by `make install`

## requirements.txt

To keep things as ordered and un-magicically as possible, deps are broken into 3 files in reqs/:
- requirements_dev.txt: the immediate packages needed to run `make` commands
- requirements_test.txt: packages needed to run `make test` and related commands
- requirements.txt: packages needed to run production code

all txt files are generated from running `pip-compile <file_name>`. `make compile` runs all files.

## Pre-commit Hooks

This repo uses a `.pre-commit-config.yaml` to run commands before code is commited. The hook is installed by `make setup`. This repo runs a combination of flake8 + black + isort + standard whitespace/json/yaml checking.

This can be run anytime with `make lint`

There are two parts to note that allows all these tools to work together with black. In the config yaml isort is set to take in a `--profile black` setting, and in `setup.cfg` there's flake8 overrides.
