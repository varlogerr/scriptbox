# read env paths from a file
envar.source -n pathfiled -f ./pathfile.env
# validate envs are loaded
echo "${E11}"
# exit environment
exit
