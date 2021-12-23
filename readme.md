# Scriptbox

A set of useful scripts. Available tools:

* [ddns-updater](ddns-updater/readme.md)
* [dim-puller](dim-puller/readme.md)
* pingo
* [ssl-gen](ssl-gen/readme.md)

## Installation

```bash
# clone the repository
sudo git clone https://github.com/varlogerr/scriptbox.git /opt/varlog/scriptbox
# add main or individual `hook.bash` to your
# `.bashrc file`. the hook adds `bin` directory
# to your PATH.
# For main (to source all available tools):
#   echo ". '/opt/varlog/scriptbox/hook.bash'" >> ~/.bashrc
# For a specific tool (for example pingo):
#   echo ". '/opt/varlog/scriptbox/pingo/hook.bash'" >> ~/.bashrc
echo ". '/opt/varlog/scriptbox/hook.bash'" >> ~/.bashrc
# load `.bashrc` to the current session
# (next time you login to bash the hook will be
# loaded automatically from `.bashrc` file)
. ~/.bashrc
```

## Usage

```bash
# if main hook is sourced, you can use `scriptbox-help.sh`
# to get familiar with the contents
scriptbox-help.sh
# use scripts `--help` flag to see the tools help. Example for `pingo.sh`:
pingo.sh --help
```
