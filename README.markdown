# concourse-rss-resource

[![Build Status](https://app.travis-ci.com/suhlig/concourse-rss-resource.svg?branch=master)](https://app.travis-ci.com/suhlig/concourse-rss-resource)

[Concourse](https://concourse-ci.org/ "Concourse Homepage") [resource](https://concourse-ci.org/implementing-resources.html "Implementing a Resource") for RSS feeds. See the [example](example/README.markdown) folder for a pipeline that sends a Slack notification when a new Postgres release is available.

# Resource Type Configuration

```yaml
resource_types:
  - name: rss-resource
    type: registry-image
    source:
      repository: suhlig/concourse-rss-resource
      tag: latest
```

# Source Configuration

* `url`: *Required.* The URL of the feed. Anything that can be parsed by Ruby's [RSS](https://www.rubydoc.info/gems/rss) gem should be good.

# Behavior

## `check`: Extract items from the feed

The resource will fetch the feed specified in `url` and will version items by their `pubDate` attribute.

**Example**

As of writing this README, the [PostgreSQL versions feed](https://www.postgresql.org/versions.rss) has a number of items with a `pubDate` of "`Thu, 27 Oct 2016 00:00:00 +0000`" (`9.6.1`, `9.5.5`, `9.4.10`, `9.3.15`, `9.2.19`, `9.1.24`, and `9.0.23`), of which `9.6.1` is the first and is being returned from `check`.

## `in`: Fetch an item from the feed

The resource will select the first item of the feed that has the requested `pubDate`. For each attribute of the that item, it writes the attribute value to a file into the destination directory.

**Example**

Asked for the version with a `pubDate` of "`Thu, 27 Oct 2016 00:00:00 +0000`" on `in`, the resource will write the following files to the destination directory:

| File Name   | Content                                                       |
| ----------- | ------------------------------------------------------------- |
|`title`      | 9.6.1                                                         |
|`link`       | https://www.postgresql.org/docs/9.6/static/release-9-6-1.html |
|`description`| 9.6.1 is the latest release in the 9.6 series.                |
|`pubDate`    | Thu, 27 Oct 2016 00:00:00 +0000                               |
|`guid`       | https://www.postgresql.org/docs/9.6/static/release-9-6-1.html |

You can then read these files in a task and, for example, construct a [Slack notification](https://github.com/cloudfoundry-community/slack-notification-resource) saying which new PostgreSQL version is available.

## `out`: Not implemented

There is no output from this resource.

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
