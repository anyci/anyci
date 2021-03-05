# anyci
Any CI - Run you pipelines anywhere.

## intro

Any CI enables portable pipelines. Its patterns allow you to reliably run pipelines _anywhere_; e.g. from Jenkins, GitLab CI, Travis, or from codebase checkouts in **local development environments**.

### getting started

> :construction: working on documentation...

* setup a anyci repo :construction:
  * you can use a fork of this one

* setup codebases :construction:
  * add `bin/ci` to your repository
    * use the [project_skel/bin/ci](https://github.com/briceburg/anyci-bootstrap/blob/main/project-skel/bin/ci) from [anyci-bootstap](https://github.com/briceburg/anyci-bootstrap) to ensure anyci is always up-to-date in your projects
  * customizations in `ci/`    

### Tenets
* *accessible*: let developers run exactly what the CI platform runs without having to check-in code. aka avoiding "commit hell".
* *portable*: execute CI steps reliably inside containers. aka getting out of the dependency managment business and freeing yourself to try different CI platforms with _zero code changes_.
* *maintainable*: keep things [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) in your centralized `anyci` repository. aka encouraging inheritance and reuse.
* *flexible*: allow customizations per codebase repository through simple overrides. aka getting out of the way.
> :thought_balloon: these tenets it seems are a universal tooling standard. lets call it **PFAM**
