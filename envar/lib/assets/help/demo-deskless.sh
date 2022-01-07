# load env in deskless mode.
# deskless mode loads environment
# to the current shell instead of
# opening it in a new one
envar.source -D ./env1
# validate env1 is loaded
echo "${E11}"
# issuing `exit` will exit the
# shell you were in before
# `envar.source -D` command
exit
