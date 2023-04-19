## SOME GIT UTILS

```bash
$ ./save_repos_info.sh [-h] FILENAME [-d DIRECTORY]

Save a yaml file to FILENAME with a summary of all git repositories in DIRECTORY (default current directory):
    -h  show this help text
    -d  repositories basedir (can be repeated for multiple directories)
        default is current directory
```

example:
```yaml
repos:
  - root: /home/tree
    name: fake_repo
    branch: (HEAD detached at v0.5)
    commit: 7df3f22
    origin: git@github.com:user/fake_repo.git
    modified_or_untracked: 0

  - root: /home/tree
    name: test_repo
    branch: master
    commit: d9768ee
    origin: git@github.com:user/test_repo.git
    modified_or_untracked: 3
```
