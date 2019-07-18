# Gitee Subscriber

This repository is subscribed [Gitee](https://gitee.com) webhook for generating merged pull request logs by [sinatra](http://sinatrarb.com/)

## Installation

Clone this repository:

```
$ git clone git@gitee.com:jimcheung/gitee-subscriber.git
$ cd gitee-subscriber
```

And then execute:

```
$ bundle install
```

Now create databate and migrate:

```
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

Start to run app:

```
$ puma
```

Visit `http://localhost:9292/logs?access_token=ll6_y0Xbj9cV_g`

And that's it, you're all set :)

## Usage

Visit your Gitee repository settings

And then add hook for subscribing pull request event

Note that the hook url is your app server, and password is the [access_token](config/config.yml.erb) of app config

[more information](https://gitee.com/help/articles/4184)