# Mipha

[![Build Status](https://travis-ci.org/zven21/mipha.svg?branch=master)](https://travis-ci.org/zven21/mipha)

[English](./README.md) | 简体中文)

## 目录

* [简介](#简介)
* [启动项目](#启动项目)
* [进度与计划](#进度与计划)

## 简介

Mipha 是一个用 Elixir 模(chao)仿(xi) [RubyChina](https://ruby-china.org/) 的开源论坛。

## 启动

```bash
# clone 项目
git clone git@github.com:zven21/mipha.git
# 初始化，如果是 Mac 电脑，可以执行 ./script/setup，
cd mipha && ./script/setup
# 数据库初始化，在 config/dev.exs 内配置开发环境的 postgres 账号和密码
mix ecto.reset
# 启动项目 :-)
mix phx.serve
```

如果要使用「上传图片」「发送邮件」或「第三方 Github 登录功能」需要将环境变量配置在  `~/.profile` 或 `~/.zshrc` 中

```bash
# 七牛图片服务器的账号和密码
export QINIU_ACCESS_KEY
export QINIU_SECRET_KEY
# 发送邮件服务器的账号和密码
export GMAIL_USERNAME
export GMAIL_PASSWORD
# Github 第三方认证登录的 Key 与 Secret
export GITHUB_CLIENT_ID
export GITHUB_CLIENT_SECRET
```

## 进度与计划

目前在[第一迭代](https://github.com/zven21/mipha/milestone/1)，按照 RubyChina 的功能实现，第二迭代等第一迭代完成在说。
欢迎提 Issue 或 PR。在 RubyChina 上写了一个简短分享的帖子

- [[开源项目] 用 Elixir 撸了一个 RubyChina](https://ruby-china.org/topics/37158)
