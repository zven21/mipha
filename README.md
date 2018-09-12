# Mipha

[![Build Status](https://travis-ci.org/zven21/mipha.svg?branch=master)](https://travis-ci.org/zven21/mipha)
[![Coverage Status](https://coveralls.io/repos/github/zven21/mipha/badge.svg?branch=excoveralls)](https://coveralls.io/github/zven21/mipha?branch=excoveralls)


English | [简体中文](./README.ZH.md)

## Table of contents

* [Introduction](#introduction)
* [Getting started](#getting-started)
* [Database relationship](#database-relationship)
* [Project structure](#project-structure)
* [Features](#features)

## Introduction

Mipha is an open-source elixir forum (inspire by [homeland](https://ruby-china.org)).

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

## Features

[Milestone 1](https://github.com/zven21/mipha/milestone/1)
