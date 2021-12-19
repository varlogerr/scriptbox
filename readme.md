# Scriptbox

A set of useful scripts. Available tools:

* [ddns-updater](ddns-updater/readme.md)
* pingo

## Installation

```bash
# clone the repository
sudo git clone https://github.com/varlogerr/scriptbox.git /opt/varlog/scriptbox
# add main or individual `hook.bash` to your
# `.bashrc file`. the hook adds `bin` directory
# to your PATH.
# `echo ". '/opt/varlog/scriptbox/hook.bash'" >> ~/.bashrc` # main
# `echo ". '/opt/varlog/scriptbox/{tool}/hook.bash'" >> ~/.bashrc` # specific
echo ". '/opt/varlog/scriptbox/hook.bash'" >> ~/.bashrc
# load `.bashrc` to the current session
# (next time you login to bash the hook will be
# loaded automatically from `.bashrc` file)
. ~/.bashrc
# use scripts `--help` flag to see the tools help
```
