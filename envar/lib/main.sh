__iife_envar() {
  local projdir="$(dirname "$(realpath "${1}")")"
  . "${projdir}/func/envar.sh"
  . "${projdir}/func/help.sh"
} && __iife_envar "${BASH_SOURCE[0]}" && unset __iife_envar

# Print help
#
# Available options:
#   --desk      Print desk usage
#   --deskless  Print deskless usage
export -f envar.help
# List existing loaded files
export -f envar.files
# List currently loaded paths
export -f envar.path
# Prune pending paths
export -f envar.prune
# List pending paths
export -f envar.pending
# Reload environment. This will
# reload sourced paths and pending
# ones if they got created
export -f envar.reload
# List all paths required by user
export -f envar.req
# Source paths
#
# Available options:
#   -D, --deskless (flag)
#     Run in deskless mode, i.e new bash process
#     won't be created
#   -f, --pathfile (multiple)
#     Read paths list from a file. Empty lines and
#     lines starting with '#' are ignored.
#     Non-absolut paths are resolved relatively to
#     $PWD. Paths prefixed with ':' are resolved
#     relatively to pathfile file directory.
#     Example:
#       # resolves to $PWD
#       ./envdir/envfile.sh
#       # resolves to pathfile
#       # directory
#       :/envdir/envfile.sh
#   --gen-pathfile (flag)
#     Generate pathfile dummy to stdout
#   -n, --name
#     Name for the environment
#   --
#     End of options
export -f envar.source
# Print desks stack
#
# Available options:
#   -c, --count
#       Entries count
#   -v, --verbose (flag)
#       Print with sourced files.
#       Will show all files, that
#       has been sourced during
#       the session (including
#       removed ones)
export -f envar.stack
# Print current environment files
# status
#
# Statuses:
#   * - changed file
#   - - removed file
#   + - addeds file
export -f envar.status

export -f __envar.bootstrap
export -f __envar.checksum_files
export -f __envar.func_help
export -f __envar.gen_pathfile
export -f __envar.help_desk
export -f __envar.help_deskless
export -f __envar.help_main
export -f __envar.path_files
export -f __envar.real
export -f __envar.uniq
export -f __envar.validate_options
