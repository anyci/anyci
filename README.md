# AnyCI

AnyCI enables portable pipelines. Its patterns allow you to _reliably_ run pipelines _anywhere_; e.g. from Jenkins, GitLab CI, Travis, or from codebase checkouts in **local development environments**.

Once in AnyCI you can try different CIs with very little effort. And your developers will love you. And so will your opsy teams for taking care of dependencies.

### Tenets

* *accessible*: let developers run _exactly_ what the CI platform runs without having to check-in code. aka avoiding "commit hell".
* *portable*: execute CI steps reliably inside containers. aka getting out of the dependency managment business.
* *maintainable*: keep things [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) in your centralized `anyci` repository. aka less reviews, more inheritance and and reuse.
* *flexible*: allow customizations per codebase repository through simple overrides. aka getting out of the way.

> :thought_balloon: these tenets seem a universal tooling calling. lets call it **PFAM**

## Overview

### CI Steps

AnyCI is about executing CI steps inside a [step container](#the-docker-bits). Steps can be named anything and are provided by including an eponymous **executable file** in your codebases under a particular path. A [lookup](#lookups) is performed to find the step file.

Steps are executed via `bin/ci`. Add `bin/ci` to your projects via the [anyci-bootstrap](https://github.com/briceburg/anyci-bootstrap).

```
# execute the 'foo' step
bin/ci foo

# execute the 'larry', 'curly', and 'moe' steps
bin/ci larry curly moe
```

`bin/ci` also supports -h|--help|help, -v|--version|version, and the `exec` command for running arbitrary commands in the step container (see [debugging](#debugging)).

### default steps

If no step is provided, the default steps of `check`, `build`, and `test` will be run in that order. This is the equivalent of;

```
bin/ci check build test
```

... and is **very useful to developers**. Simply run `bin/ci` from your anyci enabled project and it will run the same things the CI system does without having to check in any code.

### CI Examples
:construction:
* GitLab
* Travis
* Jenkinsfile


### environment variables

AnyCI is driven entirely by environment variables. There are no configuration files to provide in your codebase repositories. In theory, assuming your CI projects share common pipeline definitions (such as [Jenkins Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/) or [GitLab CI Includes](https://docs.gitlab.com/ee/ci/yaml/includes.html)), this cuts down on maintenance commits. For instance, if you decide to change the name of an ANYCI_FAMILY, you can do so in one place instad of _n*repositories_ referencing the old name.

TODO: figure our a way of locally hinting the family, gitenv autoload? <remote-host>/<repo-name>.env ?

name | default | description
--- | --- | ---
ANYCI_ROOT | ~auto | Path of the AnyCI workspace. Created by [anyci-bootstrap](https://github.com/briceburg/anyci-bootstrap). This is an "always-updated" checkout of your shared anyci repo.
ANYCI_FAMILY | ~empty | Optional. If set, anyci will attempt to use resources such as Dockerfiles and Step Scripts from the family directory. Lookups take priorty over `ANYCI_GROUP`.
ANYCI_GROUP | default | The anyci group. Useful for providing conventions and defaults. Acts as a fallback to lookups.
ANYCI_IMAGE | ~empty | Optional. If set, the docker image to use. Equivalent of setting `EXEC_IMAGE`. See [the docker bits](#the-docker-bits).
ANYCI_PROJECT_PATHS | ci:pipeline | Colon seperated list of paths in the PROJECT_ROOT containing CI steps and Dockerfile sources.
PROJECT_ROOT | ~auto | Path of project calling `bin/ci`. AKA The codebase CI is running against. Lookups take priority over `ANYCI_FAMILY`.

### the docker bits

AnyCI executes CI steps inside a container providing dependencies necessary to do the work. This container is known as the 'step container'.

As an example, the step container can provide [shellcheck](https://github.com/koalaman/shellcheck) and [hadolint](https://github.com/hadolint/hadolint) to the linting stage of the `check` step -- and **these tools don't need to be available on the system running CI**. Only docker is required.

The step container image can be provided as a Dockerfile via a [lookup](#lookups). The lookup is `docker/Dockefile` -- which will search first in the project running `bin/ci`, and then under the shared anyci repo.

Alternatively, you can provide the image to use as an environmental variable. This will take precedence over any Dockerfiles. e.g.

```
ANYCI_IMAGE=gradle:6.8 bin/ci build
```

### lookups

Lookups are a key pattern of AnyCI -- providing the flexibility and maintainabily [Tenents](#tenets). AnyCI uses lookups to locate step implementations and Dockerfiles.

Lookups prioritize files in the PROJECT_ROOT (the codebase repository running bin/ci) before searching in your shared anyci repo.

For example, the `docker/Dockerfile` lookup is used to find the step container source. This lookup will first search under;
* `$PROJECT_ROOT/ci/docker/Dockerfile`† and
* `$PROJECT_ROOT/pipeline/docker/Dockerfile`†

If no files have been found it will then try the shared anyci repo;
*  `$ANYCI_ROOT/family/$ANYCI_FAMILY/docker/Dockerfile` (if ANYCI_FAMILY is configured)
* `$ANYCI_ROOT/group/$ANYCI_GROUP/docker/Dockerfile` (the final lookup before failing)

CI steps are provided in the same way. For instance, `bin/ci foo` will execute the first 'foo' step found in this order;

* `$PROJECT_ROOT/ci/foo`†
* `$PROJECT_ROOT/pipeline/foo`†
* `$ANYCI_ROOT/family/$ANYCI_FAMILY/foo` (if ANYCI_FAMILY is configured)
* `$ANYCI_ROOT/group/$ANYCI_GROUP/foo`

† (as configured by the `ANYCI_PROJECT_PATHS` [environmet variable](#environment-variables) )

#### debugging

Underneath AnyCI uses the [bin/exec](bin/exec) tool to wrap steps in containers.

Use the `exec` command to run arbitrary commands inside the CI container. For instance,

```
# drop into the CI container's bash shell (use 'sh' or 'ash' on alpine)
bin/ci exec bash

# check the installed version of gradle, npm, &c....
bin/ci exec gradle --version
```

The [default](group/default) group also provides a `debug` CI step to print the container's environment.

```
bin/ci debug
# (exec)     [debug] executing inside ci-image ...
# (debug)    [INFO] debug step called. dumping the environment!
...
```

## the diagram

:construction:

README.jpg|svg
