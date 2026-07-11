# 子景点批量上传规范

> 定稿时间：2026-07-11  
> 每个子景点入库仅需：**中文名、英文名、英文长文描述** + **1 张封面图**。  
> 主景点规范见 [`attraction-content-spec.md`](attraction-content-spec.md)。

---

## 0. 与城市目录的关系

```text
{城市名}/
  {主景点中文名}.md      ← 主景点规范
  {主景点中文名}.jpg
  {主景点中文名}/        ← 本规范（子景点）
    01.{子景点名}.md
    01.{子景点名}.jpg
```

## 1. 交付物清单

| 类型 | 必填 | 入库字段 |
|------|------|----------|
| 中文名 | 是 | `sub_areas.name_zh` |
| 英文名 | 是 | `sub_areas.name_en` |
| 长文描述（英文） | 是 | `sub_areas.body` |
| 封面图 `.jpg` | 是 | `sub_areas.cover_image_path` |

摘要、地址、门票、开放时间、交通等**不在本子景点规范内**。

---

## 2. 目录结构（唯一合法）

```text
{城市名}/
  {主景点中文名}.md
  {主景点中文名}.jpg
  {主景点中文名}/
    01.{子景点中文名}.md
    01.{子景点中文名}.jpg
    02.{子景点中文名}.md
    02.{子景点中文名}.jpg
```

- 城市 → 主景点 → 文件（**同目录**，不分 `info/` / `images/`）
- 主景点文件夹名与 DB `attractions.chinese_name` 一致
- 序号两位 `01`–`99`，决定 `sort_order`（`01` → 0，`02` → 1）

---

## 3. 文件命名（唯一合法）

```text
{NN}.{子景点中文名}.{ext}
```

| 合法 | 非法 |
|------|------|
| `01.断桥残雪.md` | `1.断桥残雪.md` |
| `01.断桥残雪.jpg` | `01_断桥残雪.jpg` |
| | `断桥残雪.md`（无序号） |
| | md 与 jpg stem 不一致 |

- 图片统一 `.jpg`，≤ 10MB，建议横图 16:9
- md 内 `中文：` 须与文件名中的中文名一致

---

## 4. Markdown 模板（唯一合法，仅 3 节）

```markdown
# {中文名} / {English Name}

## 名字

中文：{中文名}
English: {English Name}

## 长文描述

{仅英文；可多段，段间空一行}
```

**不要添加** `## 摘要`、`## 详细地址` 等其他章节。

### 填写规则

- **名字**：固定两行 `中文：` + `English:`
- **长文描述**：仅英文段落；禁止中英混排同一行；段落间空一行
- **入库 body**：仅 `## 长文描述` 下的**英文**段落，以 Markdown 存入（段间空一行）；自动剔除中文行及英文行内夹杂的汉字

---

## 5. 完整样例

**路径**

```text
杭州/西湖/01.断桥残雪.md
杭州/西湖/01.断桥残雪.jpg
```

**`01.断桥残雪.md`**

```markdown
# 断桥残雪 / Broken Bridge in Remnant Snow

## 名字

中文：断桥残雪
English: Broken Bridge in Remnant Snow

## 长文描述

The Broken Bridge is one of the Ten Scenes of West Lake. Despite its name, the bridge is never truly broken.

After snowfall, the sunny and shady sides create the illusion of a break, making this one of Hangzhou's most iconic views.
```

---

## 6. 入库映射

| 源 | DB / Storage |
|----|----------------|
| 序号 `01` | `sort_order = 0` |
| — | `sub_areas.id = {attraction_id}_sa_{NN}` |
| `01.xxx.jpg` | `cover-images/sub-areas/all/{id}.jpg` |
| 解说音频（另流程） | `audio-guides/sub-areas/{id}.mp3` |

---

## 7. 上传前检查清单

- [ ] 每子景点恰好 2 个文件：`.md` + `.jpg`，stem 相同
- [ ] 文件名 `NN.中文名.ext`，NN 为两位数字
- [ ] md 仅有 `#`、`## 名字`、`## 长文描述`
- [ ] `中文：` / `English:` 两行齐全
- [ ] 长文描述下仅英文
- [ ] 无单文件多子景点

---

## 8. 空模板（复制使用）

见 [`docs/templates/sub-area-template.md`](templates/sub-area-template.md)，或：

```markdown
# 中文名 / English Name

## 名字

中文：
English:

## 长文描述


```

---

## 9. 校验与导入

```bash
# 校验本地目录是否符合本规范
node scripts/validate-subarea-content-format.mjs /path/to/城市/主景点

# 生成不合规报告（全量扫描 Downloads/Desktop 等已知源根）
node scripts/validate-subarea-content-format.mjs --scan-known
```

校验通过后，使用现有导入流水线上传（Storage `sub-areas/all/` + SQL upsert）。
