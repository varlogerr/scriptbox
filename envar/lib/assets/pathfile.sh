# absolute paths are resolved normally
/path/to/env-path
# prefixed with ':' resolved to pathfile
# directory. The following will be resolved
# to \$(dirname \$(realpath </path/to/pathfile>)
:relative/path/to/env-path
# relative paths are resolved to \$PWD
relative/path/to/env-path
