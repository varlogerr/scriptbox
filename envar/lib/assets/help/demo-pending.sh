# create environment with ./env1 env
# and non-existing ./env3 env
envar.source -n pending ./env1 ./env3
# validate env1 env is loaded
echo "${E11}"
# list loaded, requested and pending
# env paths
envar.ls
envar.req
envar.pending
# make some changes to the
# environment:
# * create missing ./env3 env
# * remove 1 file from loaded
#   env
# * change 1 file from loaded
#   env
mkdir ./env3 \
  && echo 'export E31=31' \
  > ./env3/env3-3.sh
rm ./env1/env1-2.sh
echo '' >> ./env1/env1-1.sh
# view environment status
envar.status
# apply changes. `envar.reload` is
# a shortcut for `envar.source -D`
envar.reload
# validate env3 env is loaded
echo "${E31}"
# exit environment
exit
