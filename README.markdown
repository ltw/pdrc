# pdrc

pdrc is an API wrapper for Pagerduty's [REST API v2](https://v2.developer.pagerduty.com/docs/rest-api), based off amro's great MailChimp client [Gibbon](https://github.com/amro/gibbon).

[![Build Status](https://secure.travis-ci.org/ltw/pdrc.svg)](http://travis-ci.org/ltw/pdrc)
[![Dependency Status](https://gemnasium.com/ltw/pdrc.svg)](https://gemnasium.com/ltw/pdrc)

## Important Notes

Please read Pagerduty's [Overview documentation](https://v2.developer.pagerduty.com/docs/rest-api).

pdrc returns a `PDRC::Response` instead of the response body directly. `PDRC::Response` exposes the parsed response `body` and `headers`.

## Installation

    $ gem install pdrc

## Requirements

A Pagerduty account and a v2 API key. Only administrators can generate API keys.

## Usage

First, create a *one-time use instance* of `PDRC::Request`:

```ruby
pdrc = PDRC::Request.new(api_key: "your_api_key")
```

***Note*** Only reuse instances of pdrc after terminating a call with a verb, which makes a request. Requests are light weight objects that update an internal path based on your call chain. When you terminate a call chain with a verb, a request instance makes a request and resets the path.

You can set an individual request's `timeout` and `open_timeout` like this:

```ruby
pdrc.timeout = 30
pdrc.open_timeout = 30
```

You can read about `timeout` and `open_timeout` in the [Net::HTTP](https://ruby-doc.org/stdlib-2.3.3/libdoc/net/http/rdoc/Net/HTTP.html) doc.

Now you can make requests using the resources defined in [Pagerduty's docs](https://v2.developer.pagerduty.com/v2/page/api-reference). Resource IDs are specified inline and a `CRUD` (`create`, `retrieve`, `update`, or `delete`) verb initiates the request.

You can specify `headers`, `params`, and `body` when calling a `CRUD` method. For example:

```ruby
pdrc.teams.retrieve(headers: {"SomeHeader": "SomeHeaderValue"}, params: {"query_param": "query_param_value"})
```

Of course, `body` is only supported on `create` and `update` calls. Those map to HTTP `POST`, `PATCH`, and `PUT` verbs respectively.

You can set `api_key`, `timeout`, `open_timeout`, `faraday_adapter`, `proxy`, `symbolize_keys`, `logger`, and `debug` globally:

```ruby
PDRC::Request.api_key = "your_api_key"
PDRC::Request.timeout = 15
PDRC::Request.open_timeout = 15
PDRC::Request.symbolize_keys = true
PDRC::Request.debug = false
```

For example, you could set the values above in an `initializer` file in your `Rails` app (e.g. your\_app/config/initializers/pdrc.rb).

Assuming you've set an `api_key` on PDRC, you can conveniently make API calls on the class itself:

```ruby
PDRC::Request.teams.retrieve
```

You can also set the environment variable `PAGERDUTY_API_KEY` and PDRC will use it when you create an instance:

```ruby
pdrc = PDRC::Request.new
```

***Note*** Substitute an underscore if a resource name contains a hyphen.

Pass `symbolize_keys: true` to use symbols (instead of strings) as hash keys in API responses.

```ruby
pdrc = PDRC::Request.new(api_key: "your_api_key", symbolize_keys: true)
```

Pagerduty's [REST API documentation](https://v2.developer.pagerduty.com/v2/page/api-reference) is a list of available resources.

## Debug Logging

Pass `debug: true` to enable debug logging to STDOUT.

```ruby
pdrc = PDRC::Request.new(api_key: "your_api_key", debug: true)
```

### Custom logger

Ruby `Logger.new` is used by default, but it can be overrided using:

```ruby
pdrc = PDRC::Request.new(api_key: "your_api_key", debug: true, logger: MyLogger.new)
```

Logger can be also set by globally:

```ruby
PDRC::Request.logger = MyLogger.new
```

## Examples

### Teams

Fetch all teams:

```ruby
pdrc.teams.retrieve
```

Retrieving a specific team looks like:

```ruby
pdrc.teams(team_id).retrieve
```

Create a team:

```ruby
pdrc.teams.create(body: {team: { type: "team", name: "Engineering", description: "The engineering team"}})
```

You can also delete a team:

```ruby
pdrc.teams(team_id).delete
```

### Schedules

Get all schedules:

```ruby
pdrc.schedules.retrieve(params: {"query": "Primary"})
```

By default the Pagerduty API returns 25 results. To set the count to 50 (Note: it cannot exceed 100):

```ruby
pdrc.schedules.retrieve(params: {"limit": "50"})
```

And to retrieve the next 50 schedules:

```ruby
pdrc.schedules.retrieve(params: {"limit": "50", "offset": "50"})
```

And to retrieve only the schedules with the title containing "Primary":

```ruby
pdrc.schedules.retrieve(params: {"limit": "50", "offset": "50", "query": "Primary"})
```

Get a list of overrides for a schedule:

```ruby
pdrc.schedules(schedule_id).overrides.retrieve
```

Or to list users on-call for a schedule:

```ruby
pdrc.schedules(schedule_id).users.retrieve
```

To narrow the range of on-call users down to a specific date range:

```ruby
pdrc.schedules(schedule_id).users.retrieve(params: {"since": "2018-06-01T00:00:00Z", "until": "2018-09-01T00:00:00Z"})
```

### Error handling

PDRC raises an error when the API returns an error.

`PDRC::PagerdutyError` has the following attributes: `title`, `detail`, `body`, `raw_body`, `status_code`. Some or all of these may not be
available depending on the nature of the error. For example:

```ruby
begin
  pdrc.teams(team_id).create(body: body)
rescue PDRC::PagerdutyError => e
  puts "Houston, we have a problem: #{e.message} - #{e.raw_body}"
end
```

### Other

You can set an optional proxy url like this (or with an environment variable MAILCHIMP_PROXY):

```ruby
pdrc.proxy = 'http://your_proxy.com:80'
```

You can set a different [Faraday adapter](https://github.com/lostisland/faraday) during initialization:

```ruby
pdrc = PDRC::Request.new(api_key: "your_api_key", faraday_adapter: :net_http)
```

## Thanks

Thanks to everyone who has [contributed](https://github.com/amro/gibbon/contributors) to Gibbon's development which has been so integral to PDRC's development.

## Copyright

* Copyright (c) 2010-2018 Amro Mousa & Lucas Willett. See LICENSE.txt for details.
