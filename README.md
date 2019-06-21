# Mipha

[![Build Status](https://travis-ci.org/zven21/mipha.svg?branch=master)](https://travis-ci.org/zven21/mipha)
[![Coverage Status](https://coveralls.io/repos/github/zven21/mipha/badge.svg?branch=excoveralls)](https://coveralls.io/github/zven21/mipha?branch=excoveralls)


English | [简体中文](./README.ZH.md)

## Table of contents

* [Introduction](#introduction)
* [Getting started](#getting-started)
* [Database relationship](#database-relationship)
* [Project structure](#project-structure)
* [Make a pull request](#make-a-pull-request)
* [License](#license)

## Introduction

Mipha is an open-source elixir forum build with phoenix 1.4 (inspire by [homeland](https://ruby-china.org)).

## Getting started

```bash
# clone
git clone git@github.com:zven21/mipha.git
# init setup
cd mipha && ./script/setup
# db create && db migrate db seeds
mix ecto.reset
# run
mix phx.serve
```

## Database relationship

![ ](https://l.ruby-china.com/photo/2018/b96739ac-94d4-433e-9693-de528466c6d3.jpeg!large)

## Project structure

```bash
.
├── assets                     # JS CSS and static file.
├── lib                        #
│   ├── mipha                  #
│   │   ├── accounts           # user team company location model.
│   │   ├── collections        # user collection.
│   │   ├── follows            # follows
│   │   ├── markdown           # markdown
│   │   ├── notifications      # notification
│   │   ├── replies            # the reply of topic.
│   │   ├── stars              # like topic or reply
│   │   ├── topics             # topic and node.
│   │   ├── utils              #
│   │   ├── mailer.ex          # send email.
│   │   ├── markdown.ex        #
│   │   ├── qiniu.ex           # image upload
│   │   ├── regexp.ex          # regex
│   │   ├── token.ex           # token verification, reset password etc.
│   ├── mipha_web
│   │   ├── channels           # socket
│   │   ├── controllers        # Controllers
│   │   │   ├── admin          # admin dashboard
│   │   ├── plugs              # Plugs
│   │   ├── templates          # Templates
│   │   ├── views              # Views
│   │   ├── email.ex           #
│   │   ├── session.ex         #
│   ├── mipha.ex
│   ├── mipha_web.ex
└── test                       # test
```

## Contributing

Bug report or pull request are welcome.

## Make a pull request

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please write unit test with your code if necessary.

## License

The proj is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).