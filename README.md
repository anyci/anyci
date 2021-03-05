# anyci
Any CI - Run you pipelines anywhere.

## quickstart

:construction:

> * setup your organization's anyci repo
  * you can use a fork of this one
> * configure codebases to use anyci
  * add `bin/ci` to repositories. see [anyci-bootstap](https://github.com/briceburg/anyci-bootstrap)
> * make customizations
    * setup family and groups
> * enable in your CI.
    * see example templates.

## why

Any CI enables portable pipelines. Its patterns allow you to reliably run pipelines _anywhere_; e.g. from Jenkins, GitLab CI, Travis, or from codebase checkouts in **local development environments**.

Once in AnyCI you can try different CIs with very little effort. And your developers will love you. And so will your opsy teams for taking care of dependencies.

### Tenets
* *accessible*: let developers run exactly what the CI platform runs without having to check-in code. aka avoiding "commit hell".
* *portable*: execute CI steps reliably inside containers. aka getting out of the dependency managment business and freeing yourself to try different CI platforms with _zero code changes_.
* *maintainable*: keep things [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) in your centralized `anyci` repository. aka encouraging inheritance and reuse.
* *flexible*: allow customizations per codebase repository through simple overrides. aka getting out of the way.
> :thought_balloon: these tenets it seems are a universal tooling standard. lets call it **PFAM**

## environment variables

name | default | description
--- | --- | ---
ANYCI_ROOT | ~auto | Path of the anyci workspace. Created by [anyci-bootstrap](https://github.com/briceburg/anyci-bootstrap). This is an "always-updated" checkout of your anyci repo.
ANYCI_FAMILY | ~empty | Optional. If set, anyci will attempt to use resources such as Dockerfiles and Step Scripts from the family directory. Lookups take priorty over `ANYCI_GROUP`.
ANYCI_GROUP | default | The anyci group. Useful for providing conventions and defaults. Acts as a fallback to lookups.
PROJECT_ROOT | ~auto | Path of project calling `bin/ci`. AKA The codebase CI is running against. Lookups take priority over `ANYCI_FAMILY`.
