# Mipha

[![Build Status](https://travis-ci.org/zven21/mipha.svg?branch=master)](https://travis-ci.org/zven21/mipha)

[English](./README.en.md) | 简体中文

## 目录

* [简介](#简介)
* [启动程序](#启动程序)
* [数据库表关系](#数据库表关系)
* [项目结构](#项目结构)
* [进度与计划](#进度与计划)
* [其他](#其他)

## 简介

Mipha 是一个用 Elixir 模(chao)仿(xi) [RubyChina](https://ruby-china.org/) 的开源论坛。
有兴趣参与开发的童鞋，可以加入 [Slack channel](https://elixir-mipha.slack.com/)

## 启动程序

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

如果要使用上传图片、发送邮件或第三方 Github 登录功能，需要配置环境变量配置在  `~/.profile` 或 `~/.zshrc` 中

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

## 数据库表关系

![ ](https://l.ruby-china.com/photo/2018/b96739ac-94d4-433e-9693-de528466c6d3.jpeg!large)

## 项目结构

目前的项目结构设计很直接，不属于 web 部分的功能，都放到了 lib/mipha 内，后续会根据业务需求调整。

```bash
.
├── assets                     # JS CSS 与静态资源
├── lib                        # 项目 elixir 代码
│   ├── mipha                  # 目前的逻辑是非 Web 部分的代码放到这里。
│   │   ├── accounts           # 社区用户、团队、公司、地址
│   │   ├── collections        # 收藏
│   │   ├── follows            # 关注
│   │   ├── markdown           # markdown 文本解析相关策略
│   │   ├── notifications      # 站内信（通知）
│   │   ├── replies            # 帖子评论
│   │   ├── stars              # 点赞，目前支持点赞帖子与评论
│   │   ├── topics             # 帖子与帖子的分类（节点)
│   │   ├── utils              # 工具库
│   │   ├── mailer.ex          # 发送邮件
│   │   ├── markdown.ex        # markdown 文本解析
│   │   ├── qiniu.ex           # 七牛上传图片
│   │   ├── regexp.ex          # 正则表达式
│   │   ├── token.ex           # token 验证
│   ├── mipha_web
│   │   ├── channels           # socket WS 协议相关代码
│   │   ├── controllers        # Controllers
│   │   │   ├── admin          # admin 管理台
│   │   ├── plugs              # Plugs
│   │   ├── templates          # Templates
│   │   ├── views              # Views
│   │   ├── email.ex           # 发送邮件方法及调用邮件模板
│   │   ├── session.ex         # 用户登录相关的 session 处理
│   ├── mipha.ex
│   ├── mipha_web.ex
└── test                       # 测试

```

## 进度与计划

目前在[第一迭代](https://github.com/zven21/mipha/milestone/1)，按照 RubyChina 的功能实现。欢迎提 Issue 或 PR。

## 其他

* [[开源项目] 用 Elixir 撸了一个 RubyChina](https://ruby-china.org/topics/37158)
