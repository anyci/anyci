# AnyCI
AnyCI - Run pipelines anywhere.

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
    * `bin/ci debug`, `bin/ci check`, `bin/ci build`, `bin/ci test`, `bin/ci publish`

## why

AnyCI enables portable pipelines. Its patterns allow you to _reliably_ run pipelines _anywhere_; e.g. from Jenkins, GitLab CI, Travis, or from codebase checkouts in **local development environments**.

Once in AnyCI you can try different CIs with very little effort. And your developers will love you. And so will your opsy teams for taking care of dependencies.

### Tenets

* *accessible*: let developers run _exactly_ what the CI platform runs without having to check-in code. aka avoiding "commit hell".
* *portable*: execute CI steps reliably inside containers. aka getting out of the dependency managment business.
* *maintainable*: keep things [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) in your centralized `anyci` repository. aka less reviews, more inheritance and and reuse.
* *flexible*: allow customizations per codebase repository through simple overrides. aka getting out of the way.

> :thought_balloon: these tenets seems a universal tooling standard. lets call it **PFAM**

## environment variables

AnyCI is driven entirely by environment variables. There are no configuration files to provide in your codebase repositories. In theory, assuming your CI projects share common pipeline definitions (such as [Jenkins Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/) or [GitLab CI Includes](https://docs.gitlab.com/ee/ci/yaml/includes.html)), this cuts down on maintenance commits. For instance, if you decide to change the name of an ANYCI_FAMILY, you can do so in one place instad of _n*repositories_ referencing the old name.

TODO: figure our a way of locally hinting the family, gitenv autoload? <remote-host>/<repo-name>.env ?

name | default | description
--- | --- | ---
ANYCI_ROOT | ~auto | Path of the anyci workspace. Created by [anyci-bootstrap](https://github.com/briceburg/anyci-bootstrap). This is an "always-updated" checkout of your anyci repo.
ANYCI_FAMILY | ~empty | Optional. If set, anyci will attempt to use resources such as Dockerfiles and Step Scripts from the family directory. Lookups take priorty over `ANYCI_GROUP`.
ANYCI_GROUP | default | The anyci group. Useful for providing conventions and defaults. Acts as a fallback to lookups.
ANYCI_IMAGE | ~empty | Optional. If set, the docker image to use. Equivalent of setting `EXEC_IMAGE`. See [the docker bits](#the-docker-bits).
PROJECT_ROOT | ~auto | Path of project calling `bin/ci`. AKA The codebase CI is running against. Lookups take priority over `ANYCI_FAMILY`.

## the docker bits

AnyCI executes CI steps inside a container providing dependencies necessary to do the work.

For instance the container can provide [shellcheck](https://github.com/koalaman/shellcheck) and [hadolint](https://github.com/hadolint/hadolint) to the linting stage of the `check` step -- and these tools don't need to be available on the system running CI.

The source of the container is provided as the `docker/Dockefile` [lookup](#lookups), for instance under `$PROJECT_ROOT/ci/docker/Dockerfile` or `$ANYCI_ROOT/family/$ANYCI_FAMILY/docker/Dockerfile`.

Alternatively, you can provide the image to use as an environmental variable. This will take precedence over any Dockerfiles. e.g.

```
EXEC_IMAGE=gradle:6.8 bin/ci build
```

### debugging

Underneath AnyCI uses the [bin/exec](bin/exec) tool to wrap steps in containers.

Use the `exec` command to run arbitrary commands inside the CI container. For instance,

```
# drop into the CI container's bash shell (use 'sh' or 'ash' on alpine)
bin/ci exec bash

# check the installed version of gradle, npm, &c....
bin/ci exec gradle --version
```

The [default](group/default) group  also provides a `debug` step to print the container's environment.

```
bin/ci debug
# (exec)     [debug] executing inside ci-image ...
# (debug)    [INFO] debug step called. dumping the environment!
...
```

## the diagram

:construction:

README.jpg|svg
