---
layout: post
title: Setup jekyll docs
date: 2022-10-07 19:28 +0330
tags: [jekyll]
categories: []
---
## jekyll drafts
- create `_drafts` folder
- place your posts in there as usual
- if you run `jekyll serve --draft`, jekyll would also show drafts

## using chirpy
- https://github.com/cotes2020/jekyll-theme-chirpy
- docs from [https://chirpy.cotes.page](https://chirpy.cotes.page)
### Naming and Path
Create a new file named YYYY-MM-DD-TITLE.md and put it in the _posts of the root directory. You can also use jekyll [compose](https://github.com/jekyll/jekyll-compose) to create the post
```bash
# add compose to gemfile
gem 'jekyll-compose', group: [:jekyll_plugins]
# then execute
bundle
# from now on, you can use command below to create new post
jekyll compose "my first post"
```

### Front Matter
Basically, you need to fill the Front Matter as below at the top of the post:
```yaml
---
title: TITLE
date: YYYY-MM-DD HH:MM:SS +/-TTTT
categories: [TOP_CATEGORIE, SUB_CATEGORIE]
tags: [TAG]     # TAG names should always be lowercase
---
```
 The posts’ layout has been set to post by default, so there is no need to add the variable layout in the Front Matter block.

#### other options
 ```yaml
pin: true # pin posts
toc: false
math: true
mermaid: true
 ```

### Prompts
```md
> Example line for prompt.
{: .prompt-info }
```
> \{: .prompt-info\}
{: .prompt-info }
> \{: .prompt-tip\}
{: .prompt-tip }
> \{: .prompt-warning\}
{: .prompt-warning }
> \{: .prompt-danger\}
{: .prompt-danger }

### Filepath Hightlight
```md
`/path/to/a/file.extend`{: .filepath}
```
`/path/to/a/file.extend`{: .filepath}

```shell
# content
{: file="path/to/file" }
```
{: file="path/to/file" }

## select theme
- go to `https://rubygems.org` and search for `jekyll-theme`
- add theme name to `Gemfile`
- run `bundle install`
- go to `_config.yml` and update theme variable to your selected theme
- run `bundle exec jekyll serve` or `jekyll serve`

## non jekyll sites
react js docks are written using [gatsby](https://github.com/reactjs/reactjs.org)
probably using this https://www.gatsbyjs.com/plugins/gatsby-theme-document/
