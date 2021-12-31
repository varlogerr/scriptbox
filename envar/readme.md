# bashrc.d sourcer

Source all `*.sh` files from directories.

## Available functions:
* `envrc.files`  
  List sourced files
* `envrc.help`  
  Print this help
* `envrc.ls`  
  List sourced directories
* `envrc.pending`  
  List pending directories
* `envrc.reload`  
  Reload environment. This will re-source already sourced directories and source pending ones if they got created
* `envrc.req`
  List all requested directories
* `envrc.source`  
  Source directories. Existing ones will be sourced, while non-existing will go to the pending state.  
  Available options:
  * `-d, --desk`  
    Open in a new shell
  * `-n, --name`  
    Name a desk

## Usage (considering directory list):
  ```sh
  ├── test1
  │   ├── test1-1.sh
  │   └── test1-2.sh
  └── test2
      └── test1-2.sh
  ```
  ```sh
  # source exising directories and add
  # non-existing ones to to pending
  envrc.source ./test1 ./test2 ./test3
  # list sourced directories
  envrc.ls
  # list sourced files
  envrc.files
  # list all directories requested to be sourced
  # (sourced and pending)
  envrc.req
  # list all pending directories
  envrc.pending
  # create a new environment in a sourced
  # directory
  touch test2/test2-2.sh
  # 'test2' directory is already cached,
  # so sourcing it again won't do any change
  envrc.source ./test2
  # instead reload environment to pick
  # up the changes
  envrc.reload
  # create a directory from pending list
  # and create some files to source
  mkdir -p test3; touch test3/test3-{1,2}.sh
  # reload environment
  envrc.reload
  # alternatively to sourcing you can
  # reload environment, it will pick up the
  # pending 'test3' directory as well
  envrc.reload
  ```
