# Examples

In order to play with the resource, you can produce a feed with an arbitrary version with this command:

   erb versions=0 example.rss.erb > example.rss

Put the result where Concourse can reach it. Repeat with versions=1 etc. whenever you want Concourse to see an updated feed.

For the Slack notification to work, you will need to set a `SLACK_WEBHOOK` environment variable as configured in  Slack's [webhooks](https://my.slack.com/services/new/incoming-webhook/).
