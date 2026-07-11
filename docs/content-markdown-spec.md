# CMS 内容 Markdown 格式规范

三端（admin-vue / iOS App / site 官网）统一契约。DB 列只存 **纯 Markdown**，不存 HTML。

## 支持语法

| 语法 | 写法 | 示例 |
|------|------|------|
| 二级标题 | `## ` | `## Introduction` |
| 三级标题 | `### ` | `### Ticket tips` |
| 加粗 | `**text**` | `**Important**` |
| 斜体 | `*text*` | `*optional*` |
| 无序列表 | `- ` | `- Item one` |
| 有序列表 | `1. ` | `1. First step` |
| 引用 | `> ` | `> Note for visitors` |
| 链接 | `[label](url)` | `[Booking](https://example.com)` |
| 图片 | `![](url)` | `![](sub-areas/foo.jpg)` |
| GFM 表格 | `\| col \|` | 紧急指南、法律文档 |
| 段落 | 空行分隔 | 纯 `\n` 文本也兼容 |

**不要用一级标题 `#`**（与支付模块、现有样式一致，用 `##` 起）。

## 不支持

- `<u>` 下划线
- 任意 HTML 标签（`<p>`、`<h2>`、`<img` 等）— admin 保存时会拦截
- Quill 特有 class/style

## 三端渲染库（表格 + 图片）

| 端 | 库 | 表格 | 图片 |
|----|-----|------|------|
| admin-vue 预览 | `marked`（`gfm: true`） | GFM `\| col \|` 语法 | `![](url)`，相对路径预览前改写 |
| iOS App | `MarkdownUI` 2.x（GFM / cmark-gfm） | `.table` / `.tableCell` 主题 | `AsyncImage` + 相对路径改写 |
| site 官网 | `marked` → `sanitize-html` | 白名单保留 `table/th/td` | 白名单保留 `img[src]` |

验证脚本：`node scripts/verify-markdown-gfm.mjs`

## 图片路径

上传后写入 Storage，正文插入：

```markdown
![](https://…supabase.co/storage/v1/object/public/cover-images/{folder}/{id}-{ts}.jpg)
```

相对路径（如 `sub-areas/area-foo.jpg`）三端渲染前会改写为完整 HTTPS URL。

各字段 `uploadFolder` 见 `admin-vue/src/schema/tables.js`（如 `cities`、`sub-areas`、`culture-tips`）。

## 运营提示（可写入字段 hint）

```
支持 ## 标题、**加粗**、- 列表、> 引用、[链接](url)、![](图片URL)。勿粘贴 Word/HTML。
```

## 示例模板（景点 introduction）

```markdown
## Overview

Two short paragraphs about the site.

## What to see

- Hall one
- Hall two

![](https://…/cover-images/sub-areas/my-area-1.jpg)

## Practical tips

> Arrive before 9 AM to avoid crowds.
```
