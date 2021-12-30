# Docker image puller

Pull latest or all (currently hardcoded to 40 latest) images of a docker repository. For example `dim.pull.sh ubuntu` to download latest `ubuntu` image.

## Usage

```bash
# explore the script
dim.pull.sh -h
# set crontab to "pull-remove" 5 latest ubuntu
# images each monday at 4 AM
crontab - <<< \
  "0 4 * * 1 dim.pull.sh -l 5 -r ubuntu"   
```
