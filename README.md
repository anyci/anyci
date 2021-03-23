# AnyCI

AnyCI enables portable pipelines. Its patterns allow you to _reliably_ run pipelines _anywhere_; e.g. from Jenkins, GitLab CI, Travis, or from codebase checkouts in **local development environments**.

Q: What is not fun?

A: Reverse engineering foreign DSLs to try to reproduce what is happening in CI.

Once in AnyCI you can try different CIs with very little effort. And your developers will love you. And so will your opsy teams for taking care of dependencies.

## Overview

### CI Steps

AnyCI is about executing CI steps inside a [step container](#the-docker-bits). Steps can be named anything and are provided by including an eponymous **executable file** in your codebases under a particular path. A [lookup](#lookups) is performed to find the step file.

> :thought_balloon: Use AnyCI steps for _core_ pipeline behavior -- such as testing and building artifacts. This ensures the functionality is accessible and able to run locally (even if CI is down!). Leave the _glue_ to the pipeline DSL -- such as sending slack notifications, triggering downstream pipelines, and seeding the environment with secrets. See [TBD CI platform examples](#ci-examples) for inspiration.

Steps are executed via `bin/ci`. Add `bin/ci` to your projects via the [anyci-bootstrap](https://github.com/briceburg/anyci-bootstrap).

```
# execute the 'foo' step
bin/ci foo

# execute the 'larry', 'curly', and 'moe' steps
bin/ci larry curly moe
```

`bin/ci` also supports -h|--help|help, -v|--version|version, and the `exec` command for running arbitrary commands in the step container (see [debugging](#debugging)).

#### default steps

If no step is provideANYCI_LOOKUP_PATHSd, the default steps of `check`, `build`, and `test` will be run in that order.

```
bin/ci
# ^^^ is the equivalent of ->
bin/ci check build test
```

... and is **very useful to developers**. Simply run `bin/ci` from your AnyCI enabled project and it will run the same things the CI system does without having to check in any code.

#### requirements

To run `bin/ci` the host or "agent" environment must have;
* the [docker](https://www.docker.com/) cli command
* [git](https://github.com/git/git) - the stupid content tracker
* the ability to clone [anyci-bootstrap](https://github.com/briceburg/anyci-bootstrap) (ANYCI_BOOTSTRAP_URL)

### CI Examples

Below some examples of AnyCI enabled projects under different CI platforms.

:construction:
* GitHub Actions
* GitLab CI
* Jenkinsfile


### environment variables

AnyCI is driven entirely by environment variables. In theory, assuming your CI projects share common pipeline definitions (such as [Jenkins Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/) or [GitLab CI Includes](https://docs.gitlab.com/ee/ci/yaml/includes.html)), this will cut down on maintenance commits.

name | default | description
--- | --- | ---
ANYCI_ROOT | ~auto | Path of the AnyCI workspace. Created by [anyci-bootstrap](https://github.com/briceburg/anyci-bootstrap). This is an "always-updated" checkout of your shared anyci repo.
ANYCI_IMAGE | ~empty | Optional. If set, the docker image to use. Equivalent of setting `EXEC_IMAGE`. See [the docker bits](#the-docker-bits).
ANYCI_PATHS | ci:^default | Colon seperated list of [lookup](#lookups) paths in order of priority. Relative paths are relative to PROJECT_ROOT. `^` is replaced with $ANYCI_ROOT/. Customize this to suit your inheritance model, e.g. `ci:^acme-gradle:^default`
PROJECT_ROOT | ~auto | Path of project calling `bin/ci`. AKA The codebase CI is running against.

### the docker bits

AnyCI executes CI steps inside a container providing dependencies necessary to do the work. This container is known as the 'step container'.

As an example, the step container can provide [shellcheck](https://github.com/koalaman/shellcheck) and [hadolint](https://github.com/hadolint/hadolint) to the linting stage of the `check` step -- and **these tools don't need to be available on the system running CI**. Only docker is required.

The step container image can be provided as a Dockerfile via a [lookup](#lookups). The lookup is `docker/Dockefile` -- and by default first searches under the project running `bin/ci`, and then under the shared anyci repo.

_Alternatively_, you can provide the image to use as an environmental variable. This will take precedence over any Dockerfiles. e.g.

```
ANYCI_IMAGE=gradle:6.8 bin/ci build
```

### lookups

Lookups are a key pattern of AnyCI -- providing the flexibility and maintainabily [Tenents](#tenets). AnyCI uses lookups to locate step implementations and Dockerfiles.

By default, lookups prioritize files in the PROJECT_ROOT (the codebase repository running bin/ci) before searching in your shared anyci repo.

For example, the `docker/Dockerfile` lookup is used to find the step container source. This lookup will first search under `$PROJECT_ROOT/ci/docker/Dockerfile`, and if no file is found it will then try the shared anyci repo `$ANYCI_ROOT/default/docker/Dockerfile` before failing†.

CI steps are provided in the same way. For instance, `bin/ci foo` will execute the first 'foo' step found in this order;

* `$PROJECT_ROOT/ci/steps/foo`†
* `$ANYCI_ROOT/default/steps/afoo`†

† as configured by the `ANYCI_PATHS` [environmet variable](#environment-variables).

#### debugging

Underneath AnyCI uses the [bin/exec](bin/exec) tool to wrap steps in containers.

Use the `exec` command to run arbitrary commands inside the CI container. For instance,

```
# drop into the CI container's bash shell (use 'sh' or 'ash' on alpine)
bin/ci exec bash

# check the installed version of gradle, npm, &c....
bin/ci exec gradle --version
```

The [default](default) path also provides a `debug` step to print the container's environment.

```
bin/ci debug
# (exec)     [debug] executing inside ci-image ...
# (debug)    [INFO] debug step called. dumping the environment!
...
```


## Tenets

* *accessible*: let developers run _exactly_ what the CI platform runs without having to check-in code. aka avoiding "commit hell" and enabling continuous operation.
* *portable*: execute CI steps reliably inside containers. aka getting out of the dependency managment business.
* *maintainable*: keep things [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) in your centralized `anyci` repository. aka less reviews, more inheritance and and reuse.
* *flexible*: allow customizations per codebase repository through simple overrides. aka getting out of the way.


## the diagram

:construction:

README.jpg|svg
