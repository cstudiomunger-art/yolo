# 音频未正确匹配 / 缺失 — 按主景点汇总

生成时间：2026-07-09T11:13:55.685Z

包含三类问题：
1. **缺音频** — DB 子景点 `audio_url` 为空
2. **未匹配** — Benedict 源音频未能绑定到子景点
3. **歧义** — 有多个候选子景点，未自动写入

共 **17** 个主景点存在问题。

## 主景点一览

| # | 城市 | 主景点 | 缺音频 | 未匹配音频 | 歧义音频 | DB与脚本不一致 |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Beijing | 恭王府 | 0 | 0 | 0 | 4 |
| 2 | Beijing | 故宫 | 0 | 0 | 0 | 3 |
| 3 | Beijing | 国博 | 0 | 0 | 0 | 3 |
| 4 | Chengdu | 大熊猫基地 | 1 | 0 | 0 | 0 |
| 5 | Chengdu | 四川博物院 | 0 | 3 | 0 | 0 |
| 6 | Chongqing | 磁器口古镇 | 0 | 1 | 0 | 0 |
| 7 | Chongqing | 大足石刻 | 0 | 19 | 29 | 0 |
| 8 | Chongqing | 金佛山 | 0 | 1 | 0 | 0 |
| 9 | Chongqing | 山城步道 | 0 | 1 | 0 | 0 |
| 10 | Hangzhou | 六和塔 | 10 | 0 | 0 | 0 |
| 11 | Hangzhou | 千岛湖景区 | 10 | 0 | 0 | 0 |
| 12 | Hangzhou | 西湖 | 12 | 0 | 0 | 0 |
| 13 | Hangzhou | 西湖文化广场 | 0 | 0 | 0 | 2 |
| 14 | Hangzhou | 浙江省博物馆 | 0 | 3 | 0 | 0 |
| 15 | Hangzhou | 中国丝绸博物馆 | 10 | 0 | 0 | 0 |
| 16 | Nanjing | 老门东历史文化街区 | 0 | 1 | 0 | 0 |
| 17 | Nanjing | 南京明城墙 | 0 | 1 | 0 | 0 |

## 详情

### Beijing / 恭王府

- attraction_id: `beijing_prince_gong_mansion`
- Benedict 目录: `北京/恭王府`
- 问题: 绑定不一致 4

**DB 与脚本绑定不一致的子景点：**

- 葆光室与锡晋斋：当前 `beijing_prince_gong_mansion_003.mp3`，脚本期望 `beijing_prince_gong_mansion_009.mp3`
- 蝠池与安善堂：当前 `beijing_prince_gong_mansion_003.mp3`，脚本期望 `beijing_prince_gong_mansion_006.mp3`
- 怡神所与蝠厅：当前 `beijing_prince_gong_mansion_006.mp3`，脚本期望 `beijing_prince_gong_mansion_008.mp3`
- 平步青云路、邀月台、滴翠岩与福字碑：当前 `beijing_prince_gong_mansion_009.mp3`，脚本期望 `beijing_prince_gong_mansion_003.mp3`

### Beijing / 故宫

- attraction_id: `beijing_forbidden_city`
- Benedict 目录: `北京/故宫`
- 问题: 绑定不一致 3

**DB 与脚本绑定不一致的子景点：**

- 太和门与外朝东西路：当前 `beijing_forbidden_city_004.mp3`，脚本期望 `beijing_forbidden_city_007.mp3`
- 后三宫·乾清宫、交泰殿与坤宁宫：当前 `beijing_forbidden_city_005.mp3`，脚本期望 `beijing_forbidden_city_004.mp3`
- 东西六宫：当前 `beijing_forbidden_city_007.mp3`，脚本期望 `beijing_forbidden_city_005.mp3`

### Beijing / 国博

- attraction_id: `beijing_national_museum`
- Benedict 目录: `北京/国博`
- 问题: 绑定不一致 3

**DB 与脚本绑定不一致的子景点：**

- 二层专题·科技的力量、风展红旗与德化白瓷：当前 `beijing_national_museum_003.mp3`，脚本期望 `beijing_national_museum_008.mp3`
- 古代钱币与铜镜：当前 `beijing_national_museum_008.mp3`，脚本期望 `beijing_national_museum_006.mp3`
- 古代服饰与饮食文化：当前 `beijing_national_museum_006.mp3`，脚本期望 `beijing_national_museum_003.mp3`

### Chengdu / 大熊猫基地

- attraction_id: `https_yoloadmin_vue_cstudiomunger_workers_dev`
- Benedict 目录: `成都/熊猫基地`
- 问题: 缺音频 1

**缺音频的子景点：**

- 小熊猫月亮产房

### Chengdu / 四川博物院

- attraction_id: `sichuan_museum`
- Benedict 目录: `成都/四川博物院`
- 问题: 未匹配 3

**未正确匹配的源音频：**

- `A_EN_Benedict_3.二楼·远古四川（史前时期）.mp3` — 二楼·远古四川（史前时期）
- `A_EN_Benedict_4.二楼·古代四川（先秦至秦汉三国）.mp3` — 二楼·古代四川（先秦至秦汉三国）
- `A_EN_Benedict_8.二楼·书画馆.mp3` — 二楼·书画馆

### Chongqing / 磁器口古镇

- attraction_id: `chongqing_ciqikou_old_town`
- Benedict 目录: `重庆/磁器口古镇`
- 问题: 未匹配 1

**未正确匹配的源音频：**

- `A_EN_Benedict_8.Yinglong Gate Dock.mp3` — Yinglong Gate Dock

### Chongqing / 大足石刻

- attraction_id: `chongqing_dazu_rock_carvings`
- Benedict 目录: `重庆/大足石刻`
- 问题: 未匹配 19，歧义 29

**未正确匹配的源音频：**

- `宝顶山/A_EN_Benedict_3.Museum.mp3` — Museum
- `宝顶山/A_EN_Benedict_4.Dafo Bay Entrance.mp3` — Dafo Bay Entrance
- `宝顶山/A_EN_Benedict_5.Acts of Liu Benzun.mp3` — Acts of Liu Benzun
- `宝顶山/A_EN_Benedict_6.Scenes of Hell.mp3` — Scenes of Hell
- `北山景区/A_EN_Benedict_2.Museum.mp3` — Museum
- `北山景区/A_EN_Benedict_3.Beishan Rock Carvings Entrance.mp3` — Beishan Rock Carvings Entrance
- `北山景区/A_EN_Benedict_5.Samantabhadra.mp3` — Samantabhadra
- `北山景区/A_EN_Benedict_6.Manjushri.mp3` — Manjushri
- `北山景区/A_EN_Benedict_7.Jade-Seal Guanyin.mp3` — Jade-Seal Guanyin
- `大足石刻博物馆/A_EN_Benedict_5.Conservation and Heritage of the Dazu Rock Carvings.mp3` — Conservation and Heritage of the Dazu Rock Carvings
- `大足石刻博物馆/A_EN_Benedict_7.Museum Exit.mp3` — Museum Exit
- `南山景区/A_EN_Benedict_2.Nanshan Rock Carvings Entrance.mp3` — Nanshan Rock Carvings Entrance
- `南山景区/A_EN_Benedict_6.Dragon Cave.mp3` — Dragon Cave
- `石门山景区/A_EN_Benedict_2.Shimenshan Rock Carvings Entrance.mp3` — Shimenshan Rock Carvings Entrance
- `石门山景区/A_EN_Benedict_4.Wutong Dadi.mp3` — Wutong Dadi
- `石篆山景区/A_EN_Benedict_2.Shizhuanshan Rock Carvings Entrance.mp3` — Shizhuanshan Rock Carvings Entrance
- `石篆山景区/A_EN_Benedict_4.Cave of Laojun.mp3` — Cave of Laojun
- `石篆山景区/A_EN_Benedict_5.Figure of Lu Ban.mp3` — Figure of Lu Ban
- `石篆山景区/A_EN_Benedict_6.Hariti.mp3` — Hariti

**歧义源音频（需人工选子景点）：**

- `宝顶山/A_EN_Benedict_2.Digital Cinema.mp3` — Digital Cinema
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `宝顶山/A_EN_Benedict_7.Scripture on Parental Kindness.mp3` — Scripture on Parental Kindness
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `宝顶山/A_EN_Benedict_8.Thousand-Hand Guanyin.mp3` — Thousand-Hand Guanyin
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `宝顶山/A_EN_Benedict_9.The Three Sages of Huayan.mp3` — The Three Sages of Huayan
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `宝顶山/A_EN_Benedict_10.Nine Dragons Bathing the Prince.mp3` — Nine Dragons Bathing the Prince
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `宝顶山/A_EN_Benedict_11.The Reclining Buddha.mp3` — The Reclining Buddha
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `宝顶山/A_EN_Benedict_12.Shengshuo Temple.mp3` — Shengshuo Temple
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `宝顶山/A_EN_Benedict_13.Boyong Fangong Exit.mp3` — Boyong Fangong Exit
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `宝顶山/A_EN_Benedict_14.Baoding Old Street.mp3` — Baoding Old Street
  - 候选: 北山景区 / 大足石刻博物馆 / 南山景区
- `宝顶山/A_EN_Benedict_15.Visitor Center Exit.mp3` — Visitor Center Exit
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `北山景区/A_EN_Benedict_1.Visitor Center.mp3` — Visitor Center
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `北山景区/A_EN_Benedict_4.Revolving Sutra Repository Cave.mp3` — Revolving Sutra Repository Cave
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `北山景区/A_EN_Benedict_8.Rosary Guanyin.mp3` — Rosary Guanyin
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `北山景区/A_EN_Benedict_9.Stele of He Guangzhen.mp3` — Stele of He Guangzhen
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `大足石刻博物馆/A_EN_Benedict_1.Visitor Center.mp3` — Visitor Center
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `大足石刻博物馆/A_EN_Benedict_2.Museum Entrance.mp3` — Museum Entrance
  - 候选: 北山景区 / 宝顶山 / 南山景区
- `大足石刻博物馆/A_EN_Benedict_3.World Cave Art Overview.mp3` — World Cave Art Overview
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `大足石刻博物馆/A_EN_Benedict_6.Digital Cinema.mp3` — Digital Cinema
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `南山景区/A_EN_Benedict_1.Visitor Center.mp3` — Visitor Center
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `南山景区/A_EN_Benedict_3.Cave of the Three Purities.mp3` — Cave of the Three Purities
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `南山景区/A_EN_Benedict_4.Shrine of Zhenwu.mp3` — Shrine of Zhenwu
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `南山景区/A_EN_Benedict_5.Shrine of Houtu the Sacred Mother.mp3` — Shrine of Houtu the Sacred Mother
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `南山景区/A_EN_Benedict_7.Stele Gallery.mp3` — Stele Gallery
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `石门山景区/A_EN_Benedict_1.Visitor Center.mp3` — Visitor Center
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `石门山景区/A_EN_Benedict_3.Shrine of the Jade Emperor.mp3` — Shrine of the Jade Emperor
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `石门山景区/A_EN_Benedict_5.Dongyue Dadi Precious Penitential Tableau.mp3` — Dongyue Dadi Precious Penitential Tableau
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `石门山景区/A_EN_Benedict_6.Western Trinity and Ten-Saint Guanyin Cave.mp3` — Western Trinity and Ten-Saint Guanyin Cave
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `石篆山景区/A_EN_Benedict_1.Visitor Center.mp3` — Visitor Center
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆
- `石篆山景区/A_EN_Benedict_3.Shrine of Confucius and the Ten Wise Disciples.mp3` — Shrine of Confucius and the Ten Wise Disciples
  - 候选: 北山景区 / 宝顶山 / 大足石刻博物馆

### Chongqing / 金佛山

- attraction_id: `chongqing_jinfo_mountain`
- Benedict 目录: `重庆/金佛山`
- 问题: 未匹配 1

**未正确匹配的源音频：**

- `A_EN_Benedict_10.Yaochi Ba.mp3` — Yaochi Ba

### Chongqing / 山城步道

- attraction_id: `chongqing_mountain_trails`
- Benedict 目录: `重庆/山城步道`
- 问题: 未匹配 1

**未正确匹配的源音频：**

- `A_EN_Benedict_2.Houlu.mp3` — Houlu

### Hangzhou / 六和塔

- attraction_id: `hangzhou_liuhe_pagoda`
- 问题: 缺音频 10

**缺音频的子景点：**

- 六和塔景区入口
- 六和塔
- 塔基与地宫
- 塔身一至七层
- 塔顶层观景台
- 六和塔文化陈列馆
- 中华古塔博览苑
- 钱塘江观景平台
- 六合钟声
- 碑亭

### Hangzhou / 千岛湖景区

- attraction_id: `hangzhou_qiandao_lake`
- 问题: 缺音频 10

**缺音频的子景点：**

- 千岛湖中心湖区旅游码头
- 梅峰岛
- 渔乐岛
- 龙山岛
- 海瑞祠
- 月光岛
- 锁岛
- 状元桥
- 温馨岛
- 东南湖区黄山尖

### Hangzhou / 西湖

- attraction_id: `hangzhou_west_lake`
- 问题: 缺音频 12

**缺音频的子景点：**

- 断桥残雪
- 白堤
- 平湖秋月
- 孤山与西泠印社
- 曲院风荷
- 苏堤春晓
- 花港观鱼
- 雷峰塔
- 南屏晚钟
- 柳浪闻莺
- 湖滨公园
- 三潭印月

### Hangzhou / 西湖文化广场

- attraction_id: `hangzhou_west_lake_cultural_plaza`
- Benedict 目录: `杭州/西湖文化广场`
- 问题: 绑定不一致 2

**DB 与脚本绑定不一致的子景点：**

- 西湖文化广场音乐喷泉：当前 `hangzhou_west_lake_cultural_plaza_005.mp3`，脚本期望 `hangzhou_west_lake_cultural_plaza_002.mp3`
- 运河魂雕塑与亲水平台：当前 `hangzhou_west_lake_cultural_plaza_006.mp3`，脚本期望 `hangzhou_west_lake_cultural_plaza_008.mp3`

### Hangzhou / 浙江省博物馆

- attraction_id: `hangzhou_zhejiang_museum`
- Benedict 目录: `杭州/浙江省博物馆（之江馆区）`
- 问题: 未匹配 3

**未正确匹配的源音频：**

- `A_EN_Benedict_2.浙江一万年·史前至隋唐.mp3` — 浙江一万年·史前至隋唐
- `A_EN_Benedict_3.江南秘色——浙江青瓷文化展.mp3` — 江南秘色——浙江青瓷文化展
- `A_EN_Benedict_4.向东是大海——浙江海洋文化陈列.mp3` — 向东是大海——浙江海洋文化陈列

### Hangzhou / 中国丝绸博物馆

- attraction_id: `hangzhou_silk_museum`
- 问题: 缺音频 10

**缺音频的子景点：**

- 中国丝绸博物馆入口
- 丝路馆：中国丝绸故事
- 蚕桑馆
- 织造馆
- 服饰馆：华美服饰
- 修复馆：纺织品文物修复
- 锦绣廊
- 时装馆
- 晓风书屋与文创空间
- 户外园林与茶园

### Nanjing / 老门东历史文化街区

- attraction_id: `nanjing_laomendong`
- Benedict 目录: `南京/南京老门东`
- 问题: 未匹配 1

**未正确匹配的源音频：**

- `A_EN_Benedict_2.Gutong Lane.mp3` — Gutong Lane

### Nanjing / 南京明城墙

- attraction_id: `nanjing_city_wall`
- Benedict 目录: `南京/明城墙`
- 问题: 未匹配 1

**未正确匹配的源音频：**

- `A_EN_Benedict_5.The Ramps.mp3` — The Ramps

