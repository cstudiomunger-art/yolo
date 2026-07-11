# 主景点批量上传规范

> 定稿时间：2026-07-11  
> 与子景点规范 [`sub-area-content-spec.md`](sub-area-content-spec.md) 配套使用。

---

## 1. 交付物清单

每个主景点需提交 **1 个 md + 1 张封面图**。

| 内容 | 必填 | 入库字段 | App 是否用到 |
|------|------|----------|--------------|
| 中文名 | 是 | `chinese_name` | ✅ 详情页标题、复制 |
| 英文名 | 是 | `name` | ✅ 列表/详情标题、搜索 |
| 一句话（英文） | 是 | `summary` | ✅ 景点列表卡片、行程摘要 |
| 长文介绍（英文） | 是 | `introduction` | ✅ 详情页 Introduction（无则回退一句话） |
| 详细地址（中/英） | 是 | `address_zh`, `address_en` | ✅ 详情页展示 + 复制/导航 |
| 开放时间（英文） | 是 | `opening_hours`, `closed_days`, `recommended_duration` | ⚠️ 见下表 |
| 门票（英文） | 建议 | `ticket_price` | ⚠️ 见下表 |
| 交通（英文） | 建议 | `metro_access` | ⚠️ 见下表 |
| 封面图 `.jpg` | 是 | `cover_image_path` | ✅ 列表/详情头图 |

`practical_info` 由导入脚本根据门票/开放时间/交通**自动生成短摘要**，无需手写。

### App 实际怎么用（对照代码核实）

| 源节 | 入库后 | 用户看到的 | 后台还用在哪里 |
|------|--------|------------|----------------|
| 一句话 | `summary` | 列表卡片、选景点、行程条目摘要 | — |
| 300字描述 | `introduction` | 详情页长文（可折叠） | — |
| 详细地址 | `address_zh` / `address_en` | 标题下英文地址；Practical Info 里中文地址可点复制 | 地图导航 |
| 门票 | `ticket_price` + `practical_info.Ticket` | **短摘要**（如 `Free`、`40 RMB`），不是整段门票文案 | 检测 `requires_advance_booking` |
| 开放时间 | `opening_hours` + `closed_days` + `recommended_duration` + 对应 `practical_info` 行 | **短摘要**（开放时段、闭馆日、建议时长各一行） | **行程规划**：`recommended_duration` 算游玩 slot；`closed_days` → `closed_weekdays` 避闭馆日 |
| 交通 | `metro_access` + `practical_info.Metro` | **一行地铁摘要**（如 `Metro Line 1, Longxiangqiao`），不是整段交通说明 | — |

**结论**

- 与子景点对齐的「叙事核心」：`名字` + `一句话` + `300字描述` + 封面 —— **全部直接展示**。
- `详细地址` 也在详情页直接展示，建议保留必填。
- `门票` / `交通`：整段英文会入库，但 App **只展示脚本抽出的短摘要**；缺了详情页 Practical Info 会缺行，但不影响列表/长文。
- `开放时间`：详情页同样只展示摘要，但 **`recommended_duration` / `closed_days` 被行程规划大量使用** —— 比门票/交通更应视为必填。
- 规范里的 7 节 = **现有导入脚本** `gen-city-attractions-sql.py` 能识别的全部节；不是 7 段都原样出现在 UI 里。

---

## 2. 目录结构（唯一合法）

```text
{城市名}/
  {主景点中文名}.md
  {主景点中文名}.jpg
  {主景点中文名}/          ← 子景点文件夹，见子景点规范
    01.{子景点名}.md
    01.{子景点名}.jpg
```

**示例**

```text
杭州/
  西湖.md
  西湖.jpg
  西湖/
    01.断桥残雪.md
    01.断桥残雪.jpg
    02.白堤.md
    02.白堤.jpg
```

| 规则 | 说明 |
|------|------|
| 主景点文件 | 与城市文件夹**同级平铺**，无序号前缀 |
| md 与 jpg | stem 完全相同（`西湖.md` + `西湖.jpg`） |
| 子景点 | 放在同名子文件夹 `{主景点中文名}/` 内 |
| 图片 | `.jpg`，≤ 10MB，建议横图 16:9 |

---

## 3. 文件命名（唯一合法）

```text
{主景点中文名}.md
{主景点中文名}.jpg
```

| 合法 | 非法 |
|------|------|
| `西湖.md` + `西湖.jpg` | `1.西湖.md` |
| `故宫.md` + `故宫.jpg` | `西湖.png`（须 jpg） |
| | md 与 jpg 名不一致 |
| | `info/西湖.md`（不分子目录） |

---

## 4. Markdown 模板（导入脚本识别的 7 节）

节标题、顺序固定，**不要增删改**（与 `SECTION_PATTERNS` 一致）：

```markdown
# {中文名} / {English Name}

## 名字

中文：{中文名}
English: {English Name}

## 一句话

{仅英文，1–3 句，列表卡片摘要}

## 300字描述

{仅英文，详情页长文；可多段，段间空一行}

## 详细地址

中文：{中文地址}
English: {English address}

## 门票

{仅英文；可多行、可用列表}

## 开放时间

{仅英文；含开放时段、闭馆日、建议游览时长}

## 交通

{仅英文；地铁/公交/打车等}
```

### 填写规则

| 节 | 规则 |
|----|------|
| **名字** | 固定 `中文：` + `English:` 两行 |
| **一句话** | 仅英文，写入 `summary` |
| **300字描述** | 仅英文，写入 `introduction`（节名含 `300` 供导入脚本识别） |
| **详细地址** | 中英各一行 |
| **门票 / 开放时间 / 交通** | 仅英文段落；可多行、可用 `-` 列表；入库后 App 显示短摘要，开放时间另供行程规划 |
| 全局 | 禁止中英混排在同一行 |

---

## 5. 完整样例

**`杭州/西湖.md`**

```markdown
# 西湖 / West Lake

## 名字

中文：西湖
English: West Lake

## 一句话

West Lake is Hangzhou's iconic freshwater lake and UNESCO World Heritage Site, famous for its ten classic scenes and lakeside temples.

## 300字描述

West Lake has inspired Chinese poetry and painting for over a thousand years. The lake and its surrounding hills form a landscape of causeways, islands, pagodas, and gardens.

Visitors typically explore the area on foot or by boat, linking famous spots such as Broken Bridge, Su Causeway, and Leifeng Pagoda in a full-day or multi-day itinerary.

## 详细地址

中文：浙江省杭州市西湖区龙井路1号
English: No. 1 Longjing Road, Xihu District, Hangzhou, Zhejiang

## 门票

- Most lakeside parks and causeways: Free
- Leifeng Pagoda: 40 RMB
- Boat tours: Varies by route (typically 55–150 RMB)

## 开放时间

- Lakeside areas: Open 24 hours
- Leifeng Pagoda: 08:00–17:30 (last entry 17:00)
- Closed: N/A for outdoor areas
- Note: Allow at least half a day; a full day is recommended for major spots

## 交通

- Metro Line 1: Longxiangqiao Station, walk 5 minutes to lakeside
- Metro Line 2: Fengqi Road Station, walk 10 minutes
- Bus: Multiple routes to Broken Bridge, Hubin, and other gates
```

**配对封面**：`杭州/西湖.jpg`

---

## 6. 入库映射

| 源 | DB / Storage |
|----|----------------|
| `西湖.md` 名字 | `chinese_name`, `name` |
| `## 一句话` | `summary` |
| `## 300字描述` | `introduction` |
| `## 详细地址` | `address_zh`, `address_en` |
| `## 门票` | `ticket_price` |
| `## 开放时间` | `opening_hours`, `closed_days`, `recommended_duration` |
| `## 交通` | `metro_access` |
| — | `practical_info`（脚本自动摘要） |
| `西湖.jpg` | `cover-images/attractions/{attraction_id}.jpg` |
| — | DB 存 `attractions/{attraction_id}.jpg` |

`attraction_id` 由城市配置表维护（如 `hangzhou_west_lake`），不在 md 内填写。

---

## 7. 与子景点规范的关系

```text
杭州/                    ← 城市
  西湖.md                ← 本规范（主景点）
  西湖.jpg
  西湖/                  ← 子景点规范
    01.断桥残雪.md
    01.断桥残雪.jpg
```

- 主景点文件夹名 = 子景点父文件夹名 = `chinese_name`
- 主景点只管景点级文案与封面；子景点只管解说与分点封面

---

## 8. 上传前检查清单

- [ ] 城市目录下每个主景点有 `.md` + `.jpg`，stem 相同
- [ ] 文件名无序号前缀、无子目录
- [ ] md 含固定 7 个 `##` 节，顺序正确
- [ ] `## 名字` 含 `中文：` / `English:`
- [ ] 一句话、300字描述、门票、开放时间、交通为纯英文
- [ ] 详细地址含中英两行
- [ ] 同名子文件夹内子景点符合子景点规范

---

## 9. 空模板

见 [`docs/templates/attraction-template.md`](templates/attraction-template.md)。

---

## 10. 校验与导入

```bash
# 校验城市目录下主景点 md/jpg
node scripts/validate-attraction-content-format.mjs 杭州

# 扫描 Desktop 已知城市文件夹
node scripts/validate-attraction-content-format.mjs --scan-known

# 生成 SQL（已有流水线）
python3 scripts/gen-city-attractions-sql.py
node scripts/upload-attraction-covers.mjs
```
