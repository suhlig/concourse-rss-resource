# concourse-rss-resource

[Concourse](https://concourse.ci/ "Concourse Homepage") [resource](https://concourse.ci/implementing-resources.html "Implementing a Resource") for RSS feeds.

Example: [`example/pipeline.yml`](example/pipeline.yml)

# Development

## One-time Setup

```bash
bundle install
```

## Running the Tests

Tests assume you have a running docker daemon:

```bash
bundle exec rake
```

## Publishing an updated docker image

```bash
docker login
rake docker:push
```

# References

The following resources were helpful while developing this resource:

* http://concourse.ci/implementing-resources.html
* https://github.com/opencontrol/nvd-cve-resource
* https://github.com/jdub/debian-sources-resource
* https://github.com/iron-io/dockers/tree/master/ruby
