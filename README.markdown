# concourse-rss-resource

[![Build Status](https://travis-ci.org/suhlig/concourse-rss-resource.svg?branch=master)](https://travis-ci.org/suhlig/concourse-rss-resource)

[Concourse](https://concourse.ci/ "Concourse Homepage") [resource](https://concourse.ci/implementing-resources.html "Implementing a Resource") for RSS feeds.

Example usage: [`example/pipeline.yml`](example/pipeline.yml)

# Behavior

On `check`, this resource will fetch the feed (specified in `source['url']`) and version it by the channel's `lastBuildDate` attribute. Upon `in`, it will also fetch the feed and then select the first item of the feed that has the same `pubDate` as the feed's `lastBuildDate`. For each attribute of the that item, it writes the attribute value to a file into the destination directory.

**Example**: As of writing this README, the [PostgreSQL versions feed](https://www.postgresql.org/versions.rss) has a `lastBuildDate` of "Thu, 27 Oct 2016 00:00:00 +0000". The feed items `9.6.1`, `9.5.5`, `9.4.10`, `9.3.15`, `9.2.19`, `9.1.24`, and `9.0.23` all have that `pubDate`, of which `9.6.1` is the first. The resource will now write the following files to the destination directory:

| File Name   | Content                                                       |
| ----------- | ------------------------------------------------------------- |
|`title`      | 9.6.1                                                         |
|`link`       | https://www.postgresql.org/docs/9.6/static/release-9-6-1.html |
|`description`| 9.6.1 is the latest release in the 9.6 series.                |
|`pubDate`    | Thu, 27 Oct 2016 00:00:00 +0000                               |
|`guid`       | https://www.postgresql.org/docs/9.6/static/release-9-6-1.html |

You can then read these files in a task and, for example, construct a [Slack notification](https://github.com/cloudfoundry-community/slack-notification-resource) saying which new PostgreSQL version is available.

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
