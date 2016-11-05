# Examples

In order to play with the resource, you can produce a feed with an arbitrary version with this command:

```bash
erb versions=0 example.rss.erb > example.rss
```

Put the result where Concourse can reach it via HTTP.

Repeat with `versions=1` etc. whenever you want Concourse to see an updated feed. Be careful with larger numbers; the template will create an item for each integer between 1 and `versions` (i.e. this feed is not paged).

For the Slack notification to work, you will need to set a `SLACK_WEBHOOK` environment variable as configured in  Slack's [webhooks](https://my.slack.com/services/new/incoming-webhook/).
