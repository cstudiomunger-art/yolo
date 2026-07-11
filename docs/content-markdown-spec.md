# CMS 内容 Markdown 格式规范

三端（admin-vue / iOS App / site 官网）统一契约。DB 列只存 **纯 Markdown**，不存 HTML。

## 支持语法

| 语法 | 写法 | 三端 |
|------|------|------|
| 二级标题 | `## ` | ✅ |
| 三级标题 | `### ` | ✅ |
| 加粗 | `**text**` | ✅ |
| 斜体 | `*text*` | ✅ |
| 删除线 | `~~text~~` | ✅ |
| 行内代码 | `` `code` `` | ✅（支付/法律文档可用） |
| 代码块 | ` ``` ` 围栏 | ✅（支付/法律文档可用） |
| 无序列表 | `- ` | ✅ |
| 有序列表 | `1. ` | ✅ |
| 引用 | `> ` | ✅ |
| 链接 | `[label](url)` | ✅ App 可点击；site `rel=noopener` |
| 图片 | `![](url)` | ✅ 相对路径三端改写 |
| GFM 表格 | `\| col \|` | ✅ |
| 分隔线 | `---` | ✅ |
| 段落 | 空行分隔 | ✅ 纯 `\n` 文本也兼容 |

**不要用一级标题 `#`**（与支付模块、现有样式一致，用 `##` 起）。若误用 `#`，三端会自动按 `##` 渲染。

## 不支持

- `<u>` 下划线
- 任意 HTML 标签（`<p>`、`<h2>`、`<img` 等）— admin 保存时会拦截
- Quill 特有 class/style
- GFM 任务列表 `- [ ]`（请勿依赖，三端不保证一致）

## 三端渲染栈

| 端 | 库 | 样式来源 |
|----|-----|----------|
| admin-vue 预览 | `marked`（`gfm: true`） | `scripts/lib/markdown-prose.css` |
| iOS App | `MarkdownUI` 2.x + 自定义 Theme | `MarkdownContentView.swift` |
| site 官网 | `marked` → `sanitize-html` | `markdown-prose.css` + `global.css` |

共享配置：`scripts/lib/marked-config.mjs`、`scripts/lib/markdown-sanitize.mjs`

验证：`node scripts/verify-markdown-gfm.mjs`（覆盖标题/列表/引用/链接/表格/图片/代码/删除线/分隔线）

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
