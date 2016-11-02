# Concourse RSS Resource

## Test

Run unit tests locally:

```bash
bundle exec rake
```

Build and run in a container:

```bash
```

## Debugging

```bash
$ docker run --rm --interactive --tty suhlig/rss-resource irb
```

## Example Concourse Pipeline

```yaml
resource_types:
- name: rss-resource
  type: docker-image
  source:
    repository: suhlig/rss-resource

resources:
- name: postgres-release-versions
  type: rss-resource
  source:
    url: https://www.postgresql.org/versions.rss

jobs:
- name: monitor-postgres-releases
  plan:
  - get: postgres-release-versions
    trigger: true

  - task: alert
    config:
      platform: linux
      image_resource:
        type: docker-image
        source: {repository: ubuntu}
      run:
        path: echo
        args: ["There is a new Postgres release"]
```

## References

The following resources were consulted while developing this resource:

* http://concourse.ci/implementing-resources.html
* https://github.com/opencontrol/nvd-cve-resource
* https://github.com/jdub/debian-sources-resource
* https://github.com/iron-io/dockers/tree/master/ruby
