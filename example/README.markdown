# Examples

## Postgres Release Monitor

Check out `postgres-release-monitor.yml` for a pipeline that prints any new Postgres release.

Set the pipeline with:

```command
fly \
  set-pipeline \
  --target my-concourse \
  --pipeline postgres-release-monitor \
  --config postgres-release-monitor.yml
```

## Mock Feed

In order to play with the resource, you can produce a feed with a fake release feed using this command:

```command
erb -T '-' latest=1 example/feed.rss.erb > example.rss
```

Put the result where Concourse can reach it via HTTP, and configure the `source['url']` parameter in the pipeline to point to it:

```yaml
resources:
  - name: mock-feed
    type: rss-resource
    source:
      url: http://your-server.example.com/example.rss
```

Concourse will pick it up after a few seconds and will show the new version of the resource. Whenever you want Concourse to see an updated feed, repeat the command above; passing a higher number (e.g. `latest=133`). The template will create a (fake) release for each day backwards from `latest`, but no more than 50 days back (to prevent the feed from getting too large). Remember to put the updated file on the web server again.
