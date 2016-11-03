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

## Docker Image

After a `git push` to the master branch, if the build was successful, Travis [automatically pushes an updated docker image](https://docs.travis-ci.com/user/docker/#Pushing-a-Docker-Image-to-a-Registry).
