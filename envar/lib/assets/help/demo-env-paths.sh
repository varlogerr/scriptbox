# create 'myenv1' environment
# (appends 'myenv1' to the prompt)
# with ./env1 env
envar.source -n myenv1 ./env1
# validate env1 is loaded
echo "${E11}"
# exit environment.
exit
