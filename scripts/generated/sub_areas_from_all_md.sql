-- Generated from all markdown files under backend source
INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_01', 'chengdu_museum', 'chengdu museum sub area 01', '中国历代书法馆', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_02', 'chengdu_museum', 'chengdu museum sub area 02', '中国历代玺印馆', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_03', 'chengdu_museum', 'chengdu museum sub area 03', '中国历代绘画馆', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_04', 'chengdu_museum', 'chengdu museum sub area 04', '中国历代钱币馆', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_05', 'chengdu_museum', 'chengdu museum sub area 05', '中国古代玉器馆', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_06', 'chengdu_museum', 'chengdu museum sub area 06', '中国古代陶瓷馆', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_07', 'chengdu_museum', 'chengdu museum sub area 07', '中国古代雕塑馆', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_08', 'chengdu_museum', 'chengdu museum sub area 08', '中国古代青铜馆', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_09', 'chengdu_museum', 'chengdu museum sub area 09', '中国明清家具馆', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_10', 'chengdu_museum', 'chengdu museum sub area 10', '解说词-中国少数民族工艺馆', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_11', 'chengdu_museum', 'chengdu museum sub area 11', '三楼·丹楼生晚辉——明清时期的成都', '<p>"Red towers glow in the evening" is taken from the poem of Yang Shen, a Ming Dynasty scholar from Sichuan. The gallery is located on the 3rd floor of Chengdu Museum.</p>', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_12', 'chengdu_museum', 'chengdu museum sub area 12', '三楼·喧然名都会——隋唐五代宋元时期的成都', '<p>"A bustling famous metropolis" is taken from the Tang Dynasty poet Du Fu''s poem "Chengdu Fu," with the line "A bustling famous metropolis, with flutes and sheng pipes alternating."</p>', 11, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_13', 'chengdu_museum', 'chengdu museum sub area 13', '二楼·九天开出一成都——先秦时期的成都', '<p>"From nine heavens emerged a Chengdu" is taken from the Tang Dynasty poet Li Bai''s poem "Song of the Emperor''s Western Journey to the Southern Capital," with the full line reading "From nine heavens emerged a Chengdu, with ten thousand households and a thousand gates forming a picture scroll."</p>', 12, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_14', 'chengdu_museum', 'chengdu museum sub area 14', '二楼·西蜀称天府——两汉魏晋南北朝时期的成都', '<p>The "Western Shu Known as Land of Abundance" gallery is located on the 2nd floor of Chengdu Museum, as the second part of the "Flowers Weigh Down Brocade City — Chengdu Historical and Cultural Exhibition (Ancient Period)."</p>', 13, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_15', 'chengdu_museum', 'chengdu museum sub area 15', '五楼·偶戏大千——中国木偶展', '<p>"Puppet Theater of the Great Thousand — Chinese Puppet Exhibition" is located on the 5th floor of Chengdu Museum, adjacent to the "Shadow Dance of All Phenomena — Chinese Shadow Puppetry Exhibition."</p>', 14, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_16', 'chengdu_museum', 'chengdu museum sub area 16', '五楼·影舞万象——中国皮影展', '<p>"Shadow Dance of All Phenomena — Chinese Shadow Puppetry Exhibition" is located on the 5th floor of Chengdu Museum. It is one of the museum''s most distinctive permanent exhibitions and the largest and finest shadow puppetry thematic exhibition in China.</p>', 15, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_17', 'chengdu_museum', 'chengdu museum sub area 17', '四楼·花重锦官城——成都历史文化陈列（民俗篇）', '<p>"Flowers Weigh Down Brocade City — Chengdu Historical and Cultural Exhibition (Folk Customs Section)" is located on the 4th floor of Chengdu Museum.</p>', 16, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_18', 'chengdu_museum', 'chengdu museum sub area 18', '四楼·花重锦官城——成都历史文化陈列（近世篇）', '<p>"Flowers Weigh Down Brocade City — Chengdu Historical and Cultural Exhibition (Modern Period)" is located on the 4th floor of Chengdu Museum, focusing on Chengdu''s modern history from the mid-19th century to the mid-20th century.</p>', 17, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_19', 'chengdu_museum', 'chengdu museum sub area 19', '正门大厅', '<p>The Main Entrance Hall is the entrance space and core atrium of the new Chengdu Museum building, with a soaring ceiling of tens of meters, creating a magnificent and imposing atmosphere. The hall''s design integrates modern architectural language with ancient Shu cultural elements.</p>', 18, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_museum_sa_20', 'chengdu_museum', 'chengdu museum sub area 20', '负一楼·人与自然——贝林捐赠展', '<p>"Man and Nature — Behring Donation Exhibition" is located on the basement level 1 of Chengdu Museum, and is the first nature-themed exhibition since the museum''s establishment.</p>', 19, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_01', 'the_bund_shanghai', '上海市人民英雄纪念塔 / Shanghai People''s Heroes Memorial Tower', '上海市人民英雄纪念塔', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_02', 'the_bund_shanghai', '上海总会（华尔道夫酒店） / Shanghai Club (Waldorf Astoria Shanghai on the Bund)', '上海总会（华尔道夫酒店）', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_03', 'the_bund_shanghai', 'the bund shanghai sub area 03', '亚细亚大楼（外滩一号）', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_04', 'the_bund_shanghai', 'the bund shanghai sub area 04', '十六铺码头', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_05', 'the_bund_shanghai', 'the bund shanghai sub area 05', '原汇丰银行大楼', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_06', 'the_bund_shanghai', '和平饭店 / Peace Hotel (Fairmont Peace Hotel)', '和平饭店', '<p>Sir Victor Sassoon）投资，公和洋行设计，建成于1929年，原名沙逊大厦，曾为"远东第一高楼"。建筑为装饰艺术风格，高十层，外立面以花岗岩贴面，顶部冠以标志性的绿色铜金字塔尖顶，在阳光下格外醒目。大楼内设华懋饭店（Cathay Hotel），曾是20世纪上半叶远东最顶级的酒店，卓别林、萧伯纳等名流曾下榻于此。1952年更名为和平饭店，2007年至2010年完成大规模修缮，现由费尔蒙酒店集团管理运营，拥有标志性的茉莉酒廊与九国特色套房。</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_07', 'the_bund_shanghai', 'the bund shanghai sub area 07', '外滩十八号', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_08', 'the_bund_shanghai', '外滩源 / The Origin of the Bund (Waitanyuan)', '外滩源', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_09', 'the_bund_shanghai', '外滩牛 / Bund Bull (Shanghai Financial Bull)', '外滩牛', '<p>Arturo Di Modica）创作，于2010年上海世博会期间正式揭幕。迪莫迪卡正是纽约华尔街铜牛的原作者，因此外滩牛与华尔街铜牛为"姊妹之作"。铜像采用铸铜工艺，通体呈暗红色，重约2.5吨，体量略大于华尔街铜牛。公牛呈低头蓄力、昂首挺角之姿，肌肉线条饱满，充满向前冲击的力量感，寓意"牛市"繁荣与上海金融市场的稳健发展。雕塑落成后迅速成为外滩热门打卡地标，游客常以触摸牛角祈求财运。</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_10', 'the_bund_shanghai', '外白渡桥 / Waibaidu Bridge (Garden Bridge of Shanghai)', '外白渡桥', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_11', 'the_bund_shanghai', '海关大楼 / Customs House (Shanghai)', '海关大楼', '<p>Joyce &amp; Co.钟厂铸造，每十五分钟报时一次，浑厚的钟声曾响彻黄浦江两岸，被称为"亚洲第一钟"。大楼至今仍为上海海关办公使用，是外滩"万国建筑博览会"的灵魂坐标。</p>', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'the_bund_shanghai_sa_12', 'the_bund_shanghai', '陈毅广场与陈毅铜像 / Chen Yi Square and Bronze Statue of Chen Yi', '陈毅广场与陈毅铜像', '', 11, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'shanghai_disney_resort_sa_01', 'shanghai_disney_resort', 'shanghai disney resort sub area 01', '奇想花园', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'shanghai_disney_resort_sa_02', 'shanghai_disney_resort', 'shanghai disney resort sub area 02', '宝藏湾', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'shanghai_disney_resort_sa_03', 'shanghai_disney_resort', 'shanghai disney resort sub area 03', '探险岛', '<p>cm）。另有"雷鸣山漂流"（室外激流漂流，身高≥107cm）、"古迹探寻营"（绳索挑战道等户外探索路线）等冒险项目。园区设计灵感来自太平洋岛屿与南美丛林的混合文明，弥漫着烟雾与水雾效果，是乐园最具沉浸感的主题区之一。</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'shanghai_disney_resort_sa_04', 'shanghai_disney_resort', 'shanghai disney resort sub area 04', '明日世界', '<p>cm），游客跨骑发光摩托车在光影隧道中疾驰，是全球迪士尼乐园中最刺激的过山车之一。其他项目包括"巴斯光年星际营救"（室内互动射击）、"喷气背包飞行器"（室外旋转飞行，身高≥122cm）、"创界：雪佛兰数字挑战"（互动体验未来驾驶）等。园区还定期举办"复仇者联盟培训行动"演出与"E 空间聚乐部"电子音乐派对。</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'shanghai_disney_resort_sa_05', 'shanghai_disney_resort', 'shanghai disney resort sub area 05', '星愿公园', '<p>When You Wish Upon a Star）为命名灵感，湖心有一座名为"星愿"的巨型灯光装置，夜晚点亮后倒映湖面，是度假区标志性夜景之一。公园还设有自行车租赁点（双人/四人自行车）、皮划艇体验区与季节性花展，是亲子家庭与跑步爱好者在乐园外消磨时光的理想选择。</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'shanghai_disney_resort_sa_06', 'shanghai_disney_resort', 'shanghai disney resort sub area 06', '梦幻世界', '<p>cm）、"小飞侠天空奇遇"（室内悬挂飞行）、"小熊维尼历险记"（室内乘船）、"晶彩奇航"（室外水上项目）、"爱丽丝梦游仙境迷宫"（室外互动迷宫）等。城堡内还设有"漫游童话时光"白雪公主互动体验与"冰雪奇缘：欢唱盛会"演出（约 20 分钟）。</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'shanghai_disney_resort_sa_07', 'shanghai_disney_resort', 'shanghai disney resort sub area 07', '玩具总动员乐园', '<p>U 型轨道赛车，身高≥120cm）、"弹簧狗团团转"（室外旋转追逐）、"胡迪牛仔嘉年华"（西部马车 ride，身高≥81cm）。园区整体色彩鲜艳、节奏轻松，是亲子家庭与低龄儿童最友好的主题区。</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'shanghai_disney_resort_sa_08', 'shanghai_disney_resort', 'shanghai disney resort sub area 08', '疯狂动物城', '<p>Zootopia）的城市场景——不同体型的动物区域、列车系统、霓虹招牌、市政厅。标志性游乐项目"疯狂动物城：热力追踪"是全园最新的高科技沉浸式乘骑体验。园区内随处可见尼克、朱迪、闪电等电影角色的互动装置与拍照点。2023 年 3 月 10 日，小熊猫"美美"在此全球首发亮相。2024 年 11 月，该园区荣获全球主题娱乐协会（TEA）2025 年度"主题乐园园区杰出成就奖"。</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'shanghai_disney_resort_sa_09', 'shanghai_disney_resort', 'shanghai disney resort sub area 09', '米奇大街', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'shanghai_disney_resort_sa_10', 'shanghai_disney_resort', 'shanghai disney resort sub area 10', '迪士尼小镇', '<p>The BOATHOUSE、元素 Table）、迪士尼官方商店（世界最大迪士尼旗舰店之一）、大隐书局、乐高品牌旗舰店等零售店铺。小镇内的"华特迪士尼大剧院"上演百老汇音乐剧《狮子王》中文版（需单独购票）。小镇还定期举办季节性集市、户外演出与灯光装置展，是游客在乐园外消磨半天的热门去处。</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'oriental_pearl_radio_television_tower_sa_01', 'oriental_pearl_radio_television_tower', 'Shanghai History Development Exhibition Hall', '上海城市历史发展陈列馆', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'oriental_pearl_radio_television_tower_sa_02', 'oriental_pearl_radio_television_tower', 'Main Observation Deck', '主观光层', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'oriental_pearl_radio_television_tower_sa_03', 'oriental_pearl_radio_television_tower', 'Transparent Glass Skywalk', '全透明悬空观光廊', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'oriental_pearl_radio_television_tower_sa_04', 'oriental_pearl_radio_television_tower', 'Space Capsule (351m)', '太空舱（351 米）', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'oriental_pearl_radio_television_tower_sa_05', 'oriental_pearl_radio_television_tower', 'Outdoor Observation Terrace', '户外观光层', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'oriental_pearl_radio_television_tower_sa_06', 'oriental_pearl_radio_television_tower', '"More Shanghai" Multimedia Show', '更上海环动多媒体秀', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'oriental_pearl_radio_television_tower_sa_07', 'oriental_pearl_radio_television_tower', 'Ticket Gate', '检票口', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_01', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', 'Kate&Kevin定制工坊', '一楼-Kate&Kevin定制工坊', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_02', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', 'south bund fabric market commonly known as dongjiadu fabric market sub area 02', '一楼-成衣与皮具区', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_03', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', 'south bund fabric market commonly known as dongjiadu fabric market sub area 03', '三楼-传统面料零售区', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_04', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', 'south bund fabric market commonly known as dongjiadu fabric market sub area 04', '三楼-旗袍与中式服装区', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_05', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', 'south bund fabric market commonly known as dongjiadu fabric market sub area 05', '二楼-西装定制核心区', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_06', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', 'south bund fabric market commonly known as dongjiadu fabric market sub area 06', '二楼-进口面料坊', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_07', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', 'south bund fabric market commonly known as dongjiadu fabric market sub area 07', '四楼-羊绒与杂项区', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_08', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', 'south bund fabric market commonly known as dongjiadu fabric market sub area 08', '市场入口大厅', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_09', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', 'south bund fabric market commonly known as dongjiadu fabric market sub area 09', '黄浦邮政国际寄送服务台', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'xujiahui_source_scenic_area_sa_01', 'xujiahui_source_scenic_area', 'xujiahui source scenic area sub area 01', '上海气象博物馆（徐家汇观象台旧址）', '<p>Detailed Description: The Xujiahui Observatory that houses the Shanghai Meteorological Museum was founded in 1872 by French Jesuits. In 1879 it issued China''s first typhoon warning, making it the country''s earliest typhoon-warning agency and one of Asia''s first meteorological observatories. The three-story brick-and-timber building, expanded in 1900, combines gray brick walls with a traditional Chinese xieshan roof and Western-style dormer windows—a fine example of early Sino-Western hybrid architecture. Its collection of 1,229 instruments and documents, including continuous weather records since 1872, is often called "the living archive of modern Chinese meteorology." It was listed as a Major National Historical Site in 2014.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'xujiahui_source_scenic_area_sa_02', 'xujiahui_source_scenic_area', 'xujiahui source scenic area sub area 02', '上海电影博物馆', '<p>Detailed Description: Located at No. 595 Caoxi North Road on the original site of Shanghai Film Studio, the Shanghai Film Museum opened on June 16, 2013, the opening day of the Shanghai International Film Festival. It is one of the largest film-themed museums in China. The museum is divided into four themed halls: "Memory of Light and Shadow" traces Shanghai''s 100-year cinema history since the late 19th century; "Film Factory" reveals the production process; "River of Light" walks visitors through milestones of Chinese cinema; "Centennial Brilliance" pays tribute to Shanghai filmmakers. Special exhibitions on the first floor feature international masters. The collection includes more than 15,000 film artifacts and documents, including original posters and props from classics like "Song of the Fishermen" and "Children of Troubled Times."</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'xujiahui_source_scenic_area_sa_03', 'xujiahui_source_scenic_area', 'xujiahui source scenic area sub area 03', '光启公园与徐光启纪念馆', '<p>Detailed Description: Located at No. 17 Nandan East Road, Xuhui District, Guangqi Park was originally Nandan Park and was renamed in 1983 to mark the 350th anniversary of Xu Guangqi''s death. It is the only city park in central Shanghai named after an ancient scientist. The park contains the tombs of Xu Guangqi and his wife in a Ming-dynasty layout. The Xu Guangqi Memorial Hall, originally built in 1957, was closed in 2014 for a major renovation and reopened on January 8, 2016 (the 454th anniversary of Xu''s birth), with a second upgrade completed in 2021. It comprehensively showcases Xu''s Sino-Western synthesis in agronomy, astronomy, mathematics, and military science. The park itself is free and serves as the "literary landscape" segment of Xujiahui Yuan.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'xujiahui_source_scenic_area_sa_04', 'xujiahui_source_scenic_area', 'xujiahui source scenic area sub area 04', '土山湾博物馆', '<p>Detailed Description: Located at No. 55 Puhuitang Road, the museum occupies the site of the Tushanwan Jesuit Orphanage. Founded in 1864 by French Jesuits, the orphanage became the earliest institution in China to systematically teach Western art and crafts, winning gold medals at the 1900 Paris, 1904 St. Louis, and 1915 Panama-Pacific international expositions—earning it the title "Cradle of Chinese Western Painting." The museum''s treasure is the 5.2-meter-tall three-tiered "Chinese Paifang" (memorial archway) carved in 1933 by orphanage woodworkers. The museum officially opened during the 2010 Shanghai World Expo, comprehensively showcasing Sino-Western artistic exchange from 1864 to 1960.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'xujiahui_source_scenic_area_sa_05', 'xujiahui_source_scenic_area', 'xujiahui source scenic area sub area 05', '圣母院旧址（上海老站）', '<p>Detailed Description: The site faces Xujiahui Catholic Church in the heart of the Xujiahui Yuan scenic area. Built in 1929 with funds raised by the French Sisters of Our Lady of the Rescue and Presentation, it served as a convent dormitory and girls'' orphanage, and is part of the Xujiahui Catholic historical architecture complex. The five-story white French-style reinforced concrete building is elegantly understated. In 2001, the Benbang (local Shanghai) restaurant "Shanghai Old Station" took over the space, taking its name from the nearby original Shanghai North Railway Station (the starting point of the Shanghai–Nanjing Railway). The lawn once displayed Empress Dowager Cixi''s private train car and Soong Ching-ling''s official car (both moved out around 2023). Today it functions as a cultural dining space—the only "living building" in the scenic area that combines heritage protection with commercial use.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'xujiahui_source_scenic_area_sa_06', 'xujiahui_source_scenic_area', 'xujiahui source scenic area sub area 06', '徐家汇书院', '<p>Detailed Description: Xujiahui Academy, which officially opened on New Year''s Day 2023, serves as the new Xuhui District Library and a core cultural landmark of the Xujiahui Yuan scenic area. Its facade was designed by Pritzker Prize laureate Sir David Chipperfield. The 18,650-square-meter building spans two basement levels and three above-ground floors. The signature space is a 14-meter-high atrium centered on a 20-meter-tall "YUE" book wall that cascades from the third floor to the first, with more than 800 reading seats scattered throughout. Located just one block from Xujiahui Catholic Church, its floor-to-ceiling windows frame the century-old Gothic Revival facade, creating a uniquely Shanghainese "read with a cathedral view" aesthetic.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'xujiahui_source_scenic_area_sa_07', 'xujiahui_source_scenic_area', 'xujiahui source scenic area sub area 07', '徐家汇天主堂', '<p>Detailed Description: Officially named "St. Ignatius Cathedral," its construction was initiated by French Jesuits from 1851, with the current building designed by British architect W. M. Dowdall and completed in 1910. Built in red brick, the Latin-cross plan measures 79 meters long by 28 meters wide and once accommodated 2,500 worshippers, earning it the "L''Osservatore Romano" praise as the "First Cathedral of the Far East." The twin bell towers rise 60 meters, making it the largest and best-preserved Gothic Revival Catholic church in Shanghai. It was designated a Shanghai Municipal Cultural Relic in 1989 and a Major National Historical Site in 2013.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'xujiahui_source_scenic_area_sa_08', 'xujiahui_source_scenic_area', 'xujiahui source scenic area sub area 08', '徐汇公学旧址（崇思楼）', '<p>Detailed Description: Founded in 1850 by French missionary Claude Gotteland and named after St. Ignatius of Loyola, Xuhui Public School (now Shanghai Xuhui High School) was one of the earliest Western-style schools in Shanghai. The current Chongsi Building was designed in 1915 by Belgian priest-architect Désiré and completed in 1918. The three-story French Renaissance brick-and-timber structure stands in red brick with exquisite carved details, directly across from Grand Gateway 66. In 2014, it was incorporated into the Xujiahui Catholic Historical Architecture Complex and listed as a Major National Historical Site.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'xujiahui_source_scenic_area_sa_09', 'xujiahui_source_scenic_area', 'xujiahui source scenic area sub area 09', '百代小楼（《义勇军进行曲》灌制地纪念馆）', '<p>Detailed Description: Located in Xujiahui Park, Baidai Villa was built in 1921 as the recording studio of Pathé-Orient (百代) Records. On May 3, 1935, the "March of the Volunteers" from the film "Children of Troubled Times" was recorded here and pressed for nationwide release, with music by Nie Er and lyrics by Tian Han, later becoming the national anthem of the People''s Republic of China. The two-story red-tile brick-and-timber building with a pebbledash exterior is the only surviving site in Shanghai where the national anthem was recorded. It opened to the public on May 1, 2021 as the "March of the Volunteers Recording Site Memorial," and its first-floor exhibition areas were opened in full after a 2024–2025 renovation.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'zhujiajiao_ancient_town_sa_01', 'zhujiajiao_ancient_town', 'zhujiajiao ancient town sub area 01', '放生桥', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'zhujiajiao_ancient_town_sa_02', 'zhujiajiao_ancient_town', 'zhujiajiao ancient town sub area 02', '北大街', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'zhujiajiao_ancient_town_sa_03', 'zhujiajiao_ancient_town', 'zhujiajiao ancient town sub area 03', '涵大隆酱园', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'zhujiajiao_ancient_town_sa_04', 'zhujiajiao_ancient_town', 'zhujiajiao ancient town sub area 04', '泰安桥', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'zhujiajiao_ancient_town_sa_05', 'zhujiajiao_ancient_town', 'zhujiajiao ancient town sub area 05', '圆津禅院', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'zhujiajiao_ancient_town_sa_06', 'zhujiajiao_ancient_town', 'zhujiajiao ancient town sub area 06', '廊桥', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'zhujiajiao_ancient_town_sa_07', 'zhujiajiao_ancient_town', 'zhujiajiao ancient town sub area 07', '城隍庙', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'zhujiajiao_ancient_town_sa_08', 'zhujiajiao_ancient_town', 'zhujiajiao ancient town sub area 08', '课植园', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'zhujiajiao_ancient_town_sa_09', 'zhujiajiao_ancient_town', 'zhujiajiao ancient town sub area 09', '大清邮局', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wukang_road_sa_01', 'wukang_road', 'wukang road sub area 01', '武康路 · 周璇旧居', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wukang_road_sa_02', 'wukang_road', 'wukang road sub area 02', '武康路 · 宋庆龄故居', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wukang_road_sa_03', 'wukang_road', 'wukang road sub area 03', '武康路 · 密丹公寓', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wukang_road_sa_04', 'wukang_road', 'wukang road sub area 04', '武康路 · 巴金故居', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wukang_road_sa_05', 'wukang_road', 'wukang road sub area 05', '武康路 · 意大利总领事馆旧址', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wukang_road_sa_06', 'wukang_road', 'wukang road sub area 06', '武康路 · 武康大楼（诺曼底公寓）', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wukang_road_sa_07', 'wukang_road', 'wukang road sub area 07', '武康路 · 武康庭', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wukang_road_sa_08', 'wukang_road', 'wukang road sub area 08', '武康路 · 罗密欧阳台（德利那齐宅）', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wukang_road_sa_09', 'wukang_road', 'wukang road sub area 09', '武康路 · 黄兴故居老房子艺术中心', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'tianzifang_sa_01', 'tianzifang', 'tianzifang sub area 01', '田子坊 · 248 弄弄堂', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'tianzifang_sa_02', 'tianzifang', 'tianzifang sub area 02', '田子坊 · 274 弄艺术长廊', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'tianzifang_sa_03', 'tianzifang', 'tianzifang sub area 03', '田子坊 · 守白艺术中心', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'tianzifang_sa_04', 'tianzifang', 'tianzifang sub area 04', '田子坊 · 气味图书馆', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'tianzifang_sa_05', 'tianzifang', 'tianzifang sub area 05', '田子坊 · 泰康路主入口', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'tianzifang_sa_06', 'tianzifang', 'tianzifang sub area 06', '田子坊 · 画家楼天台', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'tianzifang_sa_07', 'tianzifang', 'tianzifang sub area 07', '田子坊 · 石库门里弄建筑群', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'tianzifang_sa_08', 'tianzifang', 'tianzifang sub area 08', '田子坊 · 金粉世家', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'tianzifang_sa_09', 'tianzifang', 'tianzifang sub area 09', '田子坊 · 陈逸飞工作室旧址', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_01', 'suzhou_creek_twelve_nations_colors', 'M50创意园（翠绿色） / M50 Creative Park (Emerald-green)', 'M50创意园（翠绿色）', '<p>M50创意园位于上海市普陀区莫干山路50号，是上海最早的创意产业集聚区之一，也是世界十大艺术区之一、苏州河畔保留最完整的民族工业建筑群。其前身为上海春明粗纺厂等纺织厂房，2004年9月被上海市文化工作会议规划为"莫干山路视觉艺术特色街区"。园内沿街涂鸦密布，云集上百家画廊、艺术工作室、设计公司与创意店铺，被《TIME》杂志亚洲版列为推荐前往的上海文化地标。翠绿色对应其常春藤与新生的工业文艺气质，是"苏州河十二国色"12种国色的第4种。</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_02', 'suzhou_creek_twelve_nations_colors', '创享塔（木槿色） / The X Tower Chuangxiangta (Hibiscus)', '创享塔（木槿色）', '<p>THE X TOWER）位于上海市普陀区叶家宅路100号，地处长寿路商圈，紧邻苏州河畔。前身为1938年由德国人设计建造的宝成纱厂，曾作为日本人在华东最重要的军服缝制基地，留有标志性的瞭望塔。2018年改造升级为以"共享、开放"为理念的创意园区，总建筑面积约29000平方米，集创意工作站、联合办公、餐饮休闲、网红市集与生活体验于一体。木槿色对应其粉紫渐变、温柔且富生命力的春日气息，是"苏州河十二国色"12种国色的第5种。</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_03', 'suzhou_creek_twelve_nations_colors', 'suzhou creek twelve nations colors sub area 03', '半马苏河公园（钴蓝色）', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_04', 'suzhou_creek_twelve_nations_colors', '曹杨新村（月白色） / Caoyang New Village (Moon-white)', '曹杨新村（月白色）', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_05', 'suzhou_creek_twelve_nations_colors', '玉佛寺（朱红色） / Jade Buddha Temple (Vermilion)', '玉佛寺（朱红色）', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_06', 'suzhou_creek_twelve_nations_colors', '百禧公园（紫棠色） / Baixi Park (Purple-tang)', '百禧公园（紫棠色）', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_07', 'suzhou_creek_twelve_nations_colors', '竹丝编非遗体验馆（竹青色） / Bamboo Silk Weaving Intangible Heritage Hall (Bamboo-green)', '竹丝编非遗体验馆（竹青色）', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_08', 'suzhou_creek_twelve_nations_colors', '苏州河工业文明展示馆（丁香色） / Suzhou Creek Industrial Civilization Exhibition Hall (Lilac)', '苏州河工业文明展示馆（丁香色）', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_09', 'suzhou_creek_twelve_nations_colors', '雾苑堂茶室（天青色） / Wuyuantang Tea House (Sky-blue-grey)', '雾苑堂茶室（天青色）', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_10', 'suzhou_creek_twelve_nations_colors', '顾正红纪念馆（玄采色） / Gu Zhenghong Memorial Hall (Mystic-black)', '顾正红纪念馆（玄采色）', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_11', 'suzhou_creek_twelve_nations_colors', '高陵集市（鹅黄色） / Gaoling Market (Goose-yellow)', '高陵集市（鹅黄色）', '', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_creek_twelve_nations_colors_sa_12', 'suzhou_creek_twelve_nations_colors', '鸿寿坊（琥珀色） / Hongshoufang (Amber)', '鸿寿坊（琥珀色）', '', 11, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_01', 'yu_garden', 'yu garden sub area 01', '三穗堂', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_02', 'yu_garden', 'yu garden sub area 02', '得月楼', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_03', 'yu_garden', 'yu garden sub area 03', '内园', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_04', 'yu_garden', 'yu garden sub area 04', '仰山堂卷雨楼', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_05', 'yu_garden', 'yu garden sub area 05', '大假山', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_06', 'yu_garden', 'yu garden sub area 06', '萃秀堂', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_07', 'yu_garden', 'yu garden sub area 07', '万花楼', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_08', 'yu_garden', 'yu garden sub area 08', '点春堂', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_09', 'yu_garden', 'yu garden sub area 09', '玉玲珑', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_10', 'yu_garden', 'yu garden sub area 10', '玉华堂', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'yu_garden_sa_11', 'yu_garden', 'yu garden sub area 11', '会景楼', '', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'lujiazui_financial_district_sa_01', 'lujiazui_financial_district', 'lujiazui financial district sub area 01', '上海中心大厦（上海之巅）', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'lujiazui_financial_district_sa_02', 'lujiazui_financial_district', 'lujiazui financial district sub area 02', '上海海洋水族馆', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'lujiazui_financial_district_sa_03', 'lujiazui_financial_district', 'lujiazui financial district sub area 03', '上海环球金融中心', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'lujiazui_financial_district_sa_04', 'lujiazui_financial_district', 'lujiazui financial district sub area 04', '世纪大道', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'lujiazui_financial_district_sa_05', 'lujiazui_financial_district', 'lujiazui financial district sub area 05', '东方明珠广播电视塔', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'lujiazui_financial_district_sa_06', 'lujiazui_financial_district', 'lujiazui financial district sub area 06', '吴昌硕纪念馆', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'lujiazui_financial_district_sa_07', 'lujiazui_financial_district', 'lujiazui financial district sub area 07', '浦东滨江大道', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'lujiazui_financial_district_sa_08', 'lujiazui_financial_district', 'lujiazui financial district sub area 08', '金茂大厦', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'lujiazui_financial_district_sa_09', 'lujiazui_financial_district', 'lujiazui financial district sub area 09', '陆家嘴中心绿地', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_sun_yat_sen_mausoleum_sa_01', 'nanjing_sun_yat_sen_mausoleum', 'Nanjing Sun Yat-sen Mausoleum', '南京·中山陵', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_museum_sa_01', 'nanjing_museum', 'Nanjing Museum', '南京·南京博物院', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_massacre_memorial_sa_01', 'nanjing_massacre_memorial', 'The Memorial Hall of the Victims in Nanjing Massacre by Japanese Invaders', '南京·侵华日军南京大屠杀遇难同胞纪念馆', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_confucius_temple_qinhuai_sa_01', 'nanjing_confucius_temple_qinhuai', 'Nanjing Confucius Temple (Fuzimiao)', '南京·夫子庙', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_presidential_palace_sa_01', 'nanjing_presidential_palace', 'Nanjing Presidential Palace', '南京·总统府', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_city_wall_sa_01', 'nanjing_city_wall', 'Nanjing Ming Dynasty City Wall (Zhonghua Gate Section)', '南京·明城墙（中华门段）', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_ming_xiaoling_sa_01', 'nanjing_ming_xiaoling', 'Nanjing Ming Xiaoling Mausoleum', '南京·明孝陵', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_1865_creative_park_sa_01', 'nanjing_1865_creative_park', 'Nanjing Chengguang 1865 Sci-Tech Creative Industrial Park', '南京·晨光1865科技创意产业园', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_niushoushan_sa_01', 'nanjing_niushoushan', 'Nanjing Niushou Mountain Cultural Tourism Park', '南京·牛首山文化旅游区', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_ganxi_mansion_sa_01', 'nanjing_ganxi_mansion', 'Nanjing Ganxi Former Residence', '南京·甘熙宅第', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_shijiu_lake_sa_01', 'nanjing_shijiu_lake', 'Nanjing Shijiu Lake', '南京·石臼湖', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'nanjing_laomendong_sa_01', 'nanjing_laomendong', 'Nanjing Lao Men Dong Historical and Cultural Block', '南京·老门东历史文化街区', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_01', 'sichuan_museum', 'F · Sichuan Han Dynasty Ceramic & Stone Art Gallery', '一楼·四川汉代陶石艺术馆', '<p>Located on the museum''s 1F core, this is China''s only gallery dedicated to Sichuan Han-dynasty pictorial bricks and carved stones. Hundreds of masterpieces from Pengshan, Xinjin, Pixian, and Xindu are organized into four zones: manor-farming and archery-harvest, markets and salt-wells, mythic auspiciousness, and chariots-banquets. The iconic "Archery and Harvest" brick captures a hunter, startled wild geese, and rippling rice fields; the "Salt Well" brick documents the deep-well brine extraction at Linqiong (home of Zhuo Wenjun), the world''s earliest visual record of salt production. Smiling storytellers, drummers, and qin-players in the pottery zone are evidence of Han-era Sichuan''s cheerful, secular folk spirit. Multimedia stations let visitors zoom into brick details and hear expert commentary.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_02', 'sichuan_museum', 'F · Wanfo Temple Stone Sculpture Gallery', '三楼·万佛寺石刻馆', '<p>Wanfo Temple, near Tongjin Bridge outside Chengdu''s west gate, was one of the city''s most important official temples from the Southern Dynasties through the Tang. Excavated in four campaigns between 1882 and 1953, the site yielded hundreds of sculpture fragments—the most important Southern Dynasties Buddhist stone-carving discovery in southern China after Yungang and Longmen. The gallery is organized into five periods: Liang, Northern Zhou, Sui, Early Tang, and High Tang. Highlights include a 523 CE Liang Pingtong-4 statue, Ashoka-style pagodas, a Sui Daye Amitabha, an Early Tang yab-yum Buddha, and a High Tang guardian figure. Wanfo carvings uniquely merge the "Cao Yi Chu Shui" (Cao-style flowing-drapery) and "Wu Dai Dang Feng" (Wu-style fluttering-ribbon) styles—key evidence for the "Southern Dynasties sinicization" of Chinese Buddhist sculpture.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_03', 'sichuan_museum', 'F · Sichuan Ethnic Cultural Relics Gallery', '三楼·四川民族文物馆', '<p>This gallery is the museum''s premier window into the "diverse yet unified" Chinese nation on Sichuan soil. Sections cover Tibetan (Jiarong, Amdo, Khampa), Qiang, Yi (Liangshan), Miao, Tujia, Naxi, Lisu, Mongol, Hui, and Manchu groups. Costumes are the highlights: Jiarong Tibetan women''s colorful robes with turquoise-coral-amber headdresses, Liangshan Yi men''s "chaerwa" woolen cloaks and "tianbaba" hero-knot, Qiang cross-stitch embroidery and silver plaques, Miao pleated skirts and batik, and Tujia "Xilankapu" brocade. The gallery also displays ethnic musical instruments (Qiang flute, mouth harp, long-necked qin, mabu), ritual objects (Bon-buddhist butter flowers, Bimo divining cylinders, Dongba scriptures), tools, and wedding items. The closing "ethnic unity" relief wall embodies the vision of a Chinese national community.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_04', 'sichuan_museum', 'F · Arts & Crafts Gallery', '三楼·工艺美术馆', '<p>Located at the end of 3F East Wing, the gallery brings together over ten Ba-Shu craft genres: Shu brocade, Shu embroidery, Chengdu lacquerware, silver filigree, bamboo weaving, porcelain-bamboo composite, ivory and jade carving, gold-silver inlay, paper-cut, shadow puppetry, and masks. The center stage replicates a late-Qing Shu-brocade "great-flower-loom" wooden machine—heritage inheritors demonstrate "picking-and-tying pattern cards" at scheduled times, letting visitors watch "wanzi" and "bing-mei" patterns take form. The double-sided Shu-embroidered panda won the Hundred Flowers Gold Award; the silver-filigree showcase displays "flat-fill" filigree of intricate complexity; the porcelain-bamboo pieces wrap hairlike bamboo strips around thin porcelain. The closing "Intangible Heritage Experience Zone" offers Shu-embroidered fans, silver filigree, and paper-cut classes—reserve at the service desk.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_05', 'sichuan_museum', 'F · Tibetan Buddhist Artifacts Gallery', '三楼·藏传佛教文物馆', '<p>Located on 3F West Wing, this hall reflects Sichuan''s role as a Sino-Tibetan cultural hub. The collection centers on Ming-Qing gilt-bronze statues, thangkas, mandalas, ritual implements, dharma bells, gyaling horns, and Tibetan sutra woodblocks, organized by five major schools: Tsongkhapa lineage, Gelug, Nyingma, Sakya, and Kagyu. The highlight is an ~80 cm Yongle-era (Ming) imperial gilt-bronze Buddha of extraordinary craftsmanship; alongside a set of 13 ~1.5m × 1m thangkas depicting the Life of Shakyamuni, still vibrant after five centuries. An interactive "mani wheel" wall lets visitors spin carved wooden prayer wheels and experience daily Tibetan Buddhist practice. The hall is the best window into western Sichuan Tibetan-region culture and history.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_06', 'sichuan_museum', 'F · Painting & Calligraphy Gallery', '二楼·书画馆', '<p>Echoing the Zhang Daqian hall, this gallery is organized into four themes: Song academic style, Yuan literati, Ming-Qing Ba-Shu masters, and modern Shu-connected artists. Highlights include rubbing-and-original editions of Su Shi''s "Gongfu Tie," Wen Tong''s "Huzhou Bamboo School" ink-bamboos, Yang Shen''s running-script, works by Tang Yin, Wen Zhengming, Dong Qichang, plus modern masters with Shu ties—Kang Youwei, Liang Qichao, Yu You-ren, Guo Moruo, Xu Beihong, Qi Baishi, and Huang Binhong. Museum-grade temperature-controlled vitrines rotate exhibits seasonally: Spring Festival couplets, Duanwu fan paintings, and an autumn Ba-Shu master show. Digital kiosks allow searching the museum''s full calligraphy and painting archive by dynasty, author, or theme.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_07', 'sichuan_museum', 'F · Ancient Sichuan (Pre-Qin to Qin-Han-Three Kingdoms)', '二楼·古代四川（先秦至秦汉三国）', '<p>This hall is Chapter 2 of the "Hua Chong Jin Guan Cheng" chronological exhibition. The narrative moves from the legendary Twelve Shu Kings (Cancong, Du Yu, Kaiming) to the Qin conquest of Ba and Shu (316 BCE), the "colonization of Shu" policies, Li Bing''s construction of Dujiangyan (256 BCE), Wen Weng''s schools, and Han-era artifacts—the Li Bing stone statue, storyteller figurines, and cliff-tomb models. A Dujiangyan sand-table with dynamic water projection reveals the engineering genius of Yuzui, Feishayan, and Baopingkou. The finale explores Three Kingdoms Shu—Shu brocade, Zhuge crossbow, and the zhi-bai coin—showing how the "Land of Abundance" moved from periphery to center stage in the Han–Three Kingdoms era. Allow at least 40 minutes for the dense exhibits.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_08', 'sichuan_museum', 'F · Ba-Shu Bronze Ware Gallery', '二楼·巴蜀青铜器馆', '<p>D铜壶模型、放大纹饰、对比三星堆青铜面具的造型差异，看懂巴蜀青铜与中原青铜"同源异流"的关系。 This is one of the most academically rich galleries in the museum. The collection focuses on late Warring States to early Western Han Ba-Shu bronzes, organized into ritual, weapon, musical, daily-use, and coin categories. The headline piece—the "Inlaid Bronze Pot with Banquet, Music, Water and Land Battle Scenes"—stands ~40 cm tall and uses metal inlay to depict five scenes (mulberry-picking, archery, feasting, water battle, land battle) with nearly 200 miniature figures, hailed as "the earliest bronze War and Peace." Tiger-pattern ge-daggers, willow-leaf swords, and boat-coffin bronze plaques reflect Ba-Shu''s tiger worship and fishing-hunting culture. Multimedia stations let visitors rotate 3D models, zoom inlay details, and compare the lineage differences between Ba-Shu and Central Plains bronzes.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_09', 'sichuan_museum', 'F · Zhang Daqian Painting & Calligraphy Gallery (Dafengtang)', '二楼·张大千书画馆（大风堂）', '<p>Zhang Daqian (1899–1983) is one of the 20th century''s most internationally influential Chinese painters. The museum—located in his long-time creative base of Chengdu—hosts the Dafengtang memorial hall, displaying his artistic evolution in three phases. Early works like "Lotus" and "Imitation of Shitao Landscape" reveal literati elegance; the mid-period features 1:1 copies of Dunhuang Mogao frescoes and previously unpublished sketch drafts from his 1941–43 pilgrimage; the late-period showcases splash-ink and splash-color masterpieces such as "Ten-Thousand Li of the Yangtze," "Peach Blossom Spring," and "Love-Traces Lake." The gallery''s vitrine also displays Daqian''s personal brushes, seals, palette, and Panama hat—primary sources for biographical research.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_10', 'sichuan_museum', 'F · Ancient Sichuan (Prehistoric Era)', '二楼·远古四川（史前时期）', '<p>This hall is the prologue of the "Hua Chong Jin Guan Cheng" chronological exhibition. The trail begins with the 2.04-million-year-old Wushan Man tooth fossil, moves through Ziyang Man (Palaeolithic), Gaoshan Ancient City, the Baodun culture, and culminates in the Sanxingdui–Jinsha sites—revealing how the Chengdu Plain nurtured China''s earliest, largest, and most imaginative ancient Shu civilization. Highlights include a section model of Baodun''s city wall (~2700 BCE), 4,500-year-old paddy-field remains, and replicas of face-painted pottery pots, bird-head ladle handles, and jade yazhang ritual blades. Immersive projections let visitors "enter" ancient Shu sacrificial grounds, understanding Sanxingdui–Jinsha not as alien imports but as the indigenous pinnacle of Sichuan''s own civilizational arc.</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_11', 'sichuan_museum', 'F · Ceramics Gallery', '二楼·陶瓷馆', '<p>Located on 2F East Wing, the gallery chronologically presents ~400 representative pieces: Han green-glazed pottery, Tang Qingyao tri-colors, Song-Yuan Jingdezhen bluish-white porcelain, Ming-Qing blue-and-white and wucai, and late-Qing/Republic qianjiang enamels. The Qionglai (Qingyao) kiln takes center stage—China''s largest southwestern folk kiln system, whose oil-saving lamps, stamped stem-cups, and flambé-glaze bowls were praised by Lu You''s "Laoxue''an Notes." A multimedia reconstruction of the Shifangtang kiln site lets visitors follow clay-purifying, throwing, glazing, firing, and unloading steps. The finale showcases "export porcelain" from Chengdu customs and the Ya''an Tea-Horse Road, revealing Chengdu''s role as a tea-horse corridor and Southern Silk Road hub in East-West ceramic trade.</p>', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_12', 'sichuan_museum', 'Exit & Surroundings', '出口与周边', '<p>A级景区）；出口对面即是浣花溪公园与"诗歌大道"石刻长廊；东侧步行1.5公里可达四川大学华西校区（钟楼、懋德堂、老图书馆等近代建筑群）；再往东2公里即抵四川省图书馆、四川科技馆与天府广场——成都老城文化地标密集区。出口广场设有文创商店与"成都礼物"伴手礼店，集中销售馆藏文物复仿品、蜀锦领带、熊猫公仔、川剧变脸玩偶等。出口旁亦有星巴克、%Arabica、面包新语等餐饮配套。傍晚时分可在青华路银杏大道拍摄秋冬金叶，氛围与馆内庄重形成强烈对比，是离开前最佳的"成都式"告别。 The museum''s exit integrates with the "Qinghua Road Museum Cluster" master plan. From the south gate, walking ~800m south leads to Dufu Thatched Cottage (5A scenic area); the opposite side of the road opens onto Huanhuaxi Park and the "Poetry Avenue" stone corridor; 1.5 km east reaches Sichuan University''s West China campus (bell tower, Maode Hall, old library); another 2 km east brings you to Sichuan Provincial Library, Sichuan Science &amp; Technology Museum, and Tianfu Square—Chengdu''s dense cultural core. The exit plaza hosts a cultural-creative shop and "Chengdu Gifts" souvenir store, with replica artifacts, Shu-brocade ties, panda plush, and Sichuan-opera mask toys. Adjacent F&amp;B includes Starbucks, %Arabica, and Bread Talk. In late autumn, photograph the golden ginkgo leaves along Qinghua Road—a perfect Chengdu-style farewell contrasting the museum''s solemnity.</p>', 11, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'sichuan_museum_sa_13', 'sichuan_museum', 'Main Entrance & Lobby', '正门与大厅', '<p>The main entrance and lobby deliver the Chengdu Museum''s first impression. Designed by master architect Xu Shanggui under the "gold-inlaid-jade" concept, the facade merges Han-dynasty pictorial-brick motifs with a modern glass curtain wall. Two Han-style stone beasts (Shiyi &amp; Bixie) flank the entry. The atrium''s central relief, "Hua Chong Jin Guan Cheng – A Historical Journey through Chengdu," unfolds Chengdu''s urban evolution from Sanxingdui–Jinsha through Qin-Han, Tang-Song, and Ming-Qing. Dougong brackets, caisson ceilings, and Shu-brocade patterns abstract the western-Sichuan sloped roofline—turning the architecture itself into the museum''s first exhibit. Here visitors collect audio guides, store luggage, and scan in to begin their tour.</p>', 12, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_01', 'du_fu_thatched_cottage', '千诗碑廊 / Thousand Poetry Stele Corridor', '千诗碑廊', '<p>The Thousand Poetry Stele Corridor is located on the east side of the central axis of Du Fu Thatched Cottage, close to the south side of the Hall of Great Elegance, and is a corridor-style building about 100 meters long. The stele corridor is composed of green bricks, green tiles and carved wooden windows, and on both sides of the corridor are inlaid with bluestone steles, on which more than 1,450 of Du Fu''s surviving poems are engraved in the form of calligraphy, which is a cultural landmark of the perfect combination of Chinese classical literature and calligraphy art. The stele calligraphy collects calligraphy works of Du Fu''s poems by calligraphy masters of all dynasties such as Su Shi, Huang Tingjian and Mi Fu of the Song Dynasty, Zhao Mengfu of the Yuan Dynasty, Dong Qichang and Wen Zhengming of the Ming Dynasty, He Shaoji and Zhao Zhiqian of the Qing Dynasty, and Yu Youren, Guo Moruo, Qi Gong, Sha Menghai of modern times, with all five scripts of seal, clerical, regular, running and cursive, making it a "small museum of Chinese calligraphy art". Walking slowly along the corridor, visitors feel as if they are strolling in the long river of history: on the left are the immortal poems of the poet saint, on the right are the brush and ink style of calligraphers, and in the middle is the sculpture group of poets in the Hall of Great Elegance. Visitors are advised to stop and appreciate in the stele corridor, each stele is a piece of history, and each calligraphy work is a kind of style.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_02', 'du_fu_thatched_cottage', '南门 / South Gate', '南门', '<p>The South Gate is located on the south side of the Chengdu Du Fu Thatched Cottage Museum and is one of the secondary entrances of the cottage, mainly serving visitors entering the park from the direction of Huanhua Stream Park. The South Gate tower is in an antique architectural style, with green bricks, gray tiles and upturned eaves, echoing the main gate but more elegant and restrained. In front of the gate is close to the Huanhua Stream, with the stream water gurgling; inside the gate, bamboo shadows are dancing and the green is lush. Entering through the South Gate, visitors can directly reach the garden landscape belt connecting the south area of the cottage with Huanhua Stream Park. Compared with the main gate, the South Gate has fewer visitors and a quieter environment, making it the best entrance for visitors who want to avoid the crowds and deeply experience the quiet beauty of the cottage. Entering the park from the South Gate in the morning or evening, visitors can listen to the sound of the Huanhua Stream, watch the green bamboos swaying, and feel the poetic imagery of "The water of Huanhua Stream is at the west end, the host divined that the forest pond is quiet" (Du Fu''s "Divining Residence"). After entering from the South Gate, visitors can follow the signs northward to visit the Thatched Cottage Former Residence, Shaoling Thatched Cottage Stele Pavilion, Firewood Gate, Hall of Poetic History, and finally reach Da Xie and the main gate, taking about 2 hours in total.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_03', 'du_fu_thatched_cottage', '唐代遗址 / Tang Dynasty Site', '唐代遗址', '<p>The Tang Dynasty Site is located at the westernmost end of the central axis of Du Fu Thatched Cottage, a Tang dynasty living site area excavated archaeologically and protected in situ. Since the 1980s, archaeologists have conducted multiple excavations within the cottage area, successively unearthing Tang dynasty house foundations, wells, porcelain, bronze ware, pottery and a large number of daily necessities, among which the location of some Tang dynasty house sites is highly consistent with the location of Du Fu''s former residence recorded in literature, providing indisputable physical evidence for the "Thatched Cottage". The site area adopts a protective display method: Tang dynasty stratigraphic sections are completely preserved and protected with glass covers, so that visitors can clearly see the original appearance of Tang dynasty architectural foundations, drainage ditches, stoves, wells and other relics. Next to the site is a small exhibition hall, which systematically displays the real life scene of Du Fu in the Chengdu Thatched Cottage through excavated artifacts, archaeological photos and literature. Here, visitors can touch the historical pulse of 1,200 years ago, making it an important place for parent-child study and in-depth understanding of Tang dynasty culture.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_04', 'du_fu_thatched_cottage', '大廨 / Hall of Great Affairs (Da Xie)', '大廨', '<p>Da Xie is located behind the Main Gate and in front of the Hall of Poetic History, serving as the first main hall on the central axis. "Xie" refers to an official residence. Du Fu once served as Left Reminder and Vice Minister of Works, hence the name "Da Xie" to highlight his official status. Da Xie was originally the Mahavira Hall of Caotang Temple and was rebuilt as a reception hall and Du Fu life exhibition hall after 1949. In the center of the hall stands a standing bronze statue of Du Fu, depicted in official robes with profound gaze; the side walls display biographical panels of Du Fu, detailing his life from "Study and Travel" to "Struggles in Chang''an" and finally to "Wandering in Southwest China". The door pillars of Da Xie feature a couplet written by Qing dynasty scholar Wanyan Chongshi: "Jin River Spring Wind you claim, Thatched Cottage Renri I return", cleverly incorporating the Chengdu custom of "Visiting Thatched Cottage on Renri" (the seventh day of the first lunar month).</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_05', 'du_fu_thatched_cottage', '大雅堂 / Hall of Great Elegance (Da Ya Tang)', '大雅堂', '<p>The Hall of Great Elegance is located on the east side of the central axis of Du Fu Thatched Cottage, the largest and most artistically valuable exhibition hall in the cottage. The word "Da Ya" comes from "Da Ya" of the "Book of Songs", representing the "righteous and elegant music" of the Western Zhou royal domain, symbolizing the orthodox poetics and cultural peak. The plaque "Da Ya Tang" in front of the hall is composed of characters from the famous Tang dynasty calligrapher Yan Zhenqing, full of momentum. The Hall of Great Elegance was originally the Mahavira Hall of Caotang Temple, and was officially converted into an art exhibition hall and opened to the public in 2002. The most famous art treasure in the hall is the large-scale colored glaze inlaid lacquer mural "Poets Walking and Chanting", the largest of its kind in China to date, with Du Fu''s life journey as the clue, bringing Li Bai, Wang Wei, Meng Haoran, Gao Shi, Cen Shen and other Tang dynasty poets together in one painting, with a grand picture and brilliant colors. The hall also displays 12 sculptures of famous poets of all dynasties, including Qu Yuan, Tao Yuanming, Xie Lingyun, Li Bai, Du Fu, Bai Juyi, Su Shi, Lu You, Li Qingzhao, Xin Qiji and other peak poets in the history of Chinese literature, allowing visitors to feel the long history of Chinese poetics in every step.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_06', 'du_fu_thatched_cottage', '少陵草堂碑亭 / Shaoling Thatched Cottage Stele Pavilion', '少陵草堂碑亭', '<p>The Shaoling Thatched Cottage Stele Pavilion is located east of the Gongbu Shrine and serves as the core landmark of the Du Fu Thatched Cottage park. "Shaoling" is the abbreviation of Du Fu''s self-styled name "Shaoling Yelao" (Old Man of Shaoling). There was a Shaoling Plateau in Chang''an in the Han Dynasty, and Du Fu''s ancestor Du Yu of the Xiangyang Du family was a Jinzhao Du, so he called himself "Old Man of Shaoling". The stele pavilion is a wooden hexagonal pavilion with a thatched roof, supported by 6 wooden pillars, with a gourd-shaped finial, surrounded by beauty-rest chairs, and the base is built of bluestone in a hexagonal shape. In the center of the pavilion stands a huge stone tablet, on which are engraved the four majestic characters "Shaoling Cao Tang", signed by Qing Yongzheng Emperor''s brother Prince Guo Aisin Gioro Yunli. According to legend, Yunli passed through Chengdu on his way to Tibet on imperial order, made a special pilgrimage to the cottage and wrote the inscription. The inscription is in regular script with strict structure and strong bones, making it a masterpiece among inscriptions of all dynasties. Surrounded by towering ancient trees and verdant bamboo, the pavilion is the core landscape that visitors must take photos with.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_07', 'du_fu_thatched_cottage', '工部祠 / Gongbu Shrine (Ministry of Works Shrine)', '工部祠', '<p>The Gongbu Shrine is located behind the Firewood Gate and east of the Shaoling Thatched Cottage Stele Pavilion, the most solemn sacrificial building at the deepest part of the central axis. Du Fu once served as Vice Minister of Works (Jianxiao Gongbu Yuanwailang), commonly known as "Du Gongbu", hence the name "Gongbu Shrine". The shrine is a traditional ceremonial hall with green tiles and white walls, housing statues of Du Fu, Huang Tingjian and Lu You, commonly known as the "Hall of Three Sages". Huang Tingjian was the founder of the "Jiangxi Poetry School" of the Northern Song Dynasty, and Lu You was a patriotic poet of the Southern Song Dynasty, both of whom admired Du Fu''s poetic art. The Gongbu Shrine enshrines them on both sides of Du Fu, showing the poetic lineage of the three. The shrine is full of plaques and couplets, among which the couplet by Qing dynasty scholar Qian Baotang "Building a hut by the desolate river, you live forever; Different eras ascending the hall, these two sages" is a famous masterpiece. In front of the shrine there are incense burners and incense tables, with constant incense throughout the year, making it the core place for visitors to mourn the poet saint and express their respect.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_08', 'du_fu_thatched_cottage', '柴门 / Firewood Gate', '柴门', '<p>The Firewood Gate is located on the central axis after the Hall of Poetic History and before the Gongbu Shrine, serving as a landmark landscape. In ancient times, "Chai Men" referred to a simple door made of branches and thorns, often used to describe the residence of hermits or impoverished families. Du Fu wrote in his poem "Thatched Cottage" that "The four pines stand at the gate, ten thousand bamboos sparse by the steps", and in "Field House" he also wrote "The firewood gate opens toward the river unevenly", making the Firewood Gate a true reflection of the poet''s former residence. The current Firewood Gate is a low wooden gate rebuilt according to Du Fu''s poetic imagery and the style of western Sichuan folk houses, with bamboo fences and thatched cottages on both sides, and a plaque with the characters "Chai Men" on the lintel. The "low" design of the gate is intentional — visitors must lower their heads and bend over to enter, symbolizing the poet''s noble character of not pursuing power or wealth and maintaining humility. Inside the gate, bamboo shadows dance and pines and cypresses are verdant, creating a reclusive atmosphere of "building a hut in the human world without the noise of carriages and horses".</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_09', 'du_fu_thatched_cottage', '正门 / Main Gate', '正门', '<p>The Main Gate is the main entrance of the Chengdu Du Fu Thatched Cottage Museum, located at the southern end of Qinghua Road and serves as the first stop for visitors. The gate tower is built in a five-pillar, three-bay Tang-style architecture with upturned eaves and grand momentum. The four golden characters "Du Fu Cao Tang" inscribed on the lintel were written by the famous writer and poet Guo Moruo in 1958, with powerful and vigorous brushstrokes, making it the most recognizable landmark of the cottage. A couplet on both sides reads: "Wanli Bridge West Residence, Baihua Pool North Villa", indicating the geographical location of the cottage. Entering the main gate, visitors can tour the Hall of Great Affairs, Hall of Poetic History, Firewood Gate, Gongbu Shrine, Shaoling Thatched Cottage Stele Pavilion, Thatched Cottage Former Residence and other attractions in turn.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_10', 'du_fu_thatched_cottage', '花径 / Flower Path', '花径', '<p>The Flower Path is located on the east side of the central axis of Du Fu Thatched Cottage, a small red wall path connecting the Hall of Poetic History and the Firewood Gate. The name "Flower Path" comes from Du Fu''s poem "The flower path has never been swept for guests, the pine door is now opened for you" ("Guest Arrival"), originally referring to the small path in front of Du Fu''s residence leading to the Firewood Gate. The current Flower Path has been renovated many times and has become the most popular internet-famous check-in point in the cottage: red walls lining the path, green bamboos shading, cherry blossoms and crabapples blooming alternately in four seasons; at the end, a screen wall is inlaid with the two characters "Cao Tang" with Qing dynasty blue and white porcelain fragments, with exquisite craftsmanship and strong classical charm. Walking slowly along the Flower Path, visitors can feel the poetic imagery of "The flower path has never been swept for guests" — from Tang to Qing, this small path has welcomed countless literati and dignitaries. In spring and summer, cherry blossoms are like snow and crabapples are like rosy clouds, making it one of the most popular Chinese-style photo spots in Chengdu; in autumn and winter, red leaves dot and wintersweet is fragrant, showing another kind of quiet beauty. It is recommended to visit in the morning or evening when the light is soft, to take the most artistic red wall flower shadow photos.</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_11', 'du_fu_thatched_cottage', '茅屋故居 / Thatched Cottage Former Residence', '茅屋故居', '<p>The Thatched Cottage Former Residence is located west of the Shaoling Thatched Cottage Stele Pavilion, a landmark attraction rebuilt in 1997 based on Du Fu''s poetic imagery and the style of western Sichuan folk houses, covering an area of about 5 mu. The overall building uses traditional western Sichuan farmhouse craftsmanship of bamboo-woven mud walls and wooden windows with paper seams, the roof is covered with thatch, and the front of the door has vegetable fields enclosed by fences, connected to a pond and Huanhua Stream. The interior of the cottage is simply furnished: a thatched bed, a writing desk, brushes and inkstones, poetry manuscripts, and medicine jars are restored according to Tang dynasty life style, recreating Du Fu''s impoverished life of "No dry place at the head of the bed or under the eaves, the rain drops like hemp without ceasing". A stone statue of Du Fu stands in front of the cottage, leaning on a staff with a solemn expression, as if still worrying about the country and the people here. The cottage is surrounded by green bamboos, plum trees and peach trees, with different scenery in four seasons — peach blossoms in spring, green shade in summer, yellow chrysanthemums in autumn, plum blossoms in snow in winter. Visitors can feel the great mind of "How can I get a vast mansion of a million rooms to shelter all the poor scholars of the world with joy" here, which is the core place to experience the life scene of the poet saint.</p>', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_12', 'du_fu_thatched_cottage', '草堂影壁 / Cao Tang Screen Wall (Thatched Cottage Screen Wall)', '草堂影壁', '<p>The Cao Tang Screen Wall is located at the end of the Flower Path and is one of the most popular iconic landscapes in Du Fu Thatched Cottage. The screen wall, also called the Zhaobi, is an independent wall used to block sight and decorate the facade in traditional Chinese architecture. This screen wall is built of green bricks, with the two characters "Cao Tang" inlaid in the center, each character about 1.5 meters square. The most unique feature is that the two characters "Cao Tang" use the late Qing dynasty blue and white porcelain fragment inlay technique — craftsmen carefully cut and polished hundreds of late Qing dynasty blue and white porcelain fragments, then inlaid them according to the shape of calligraphy strokes, the blue and white porcelain fragments shine in the sun, which is both simple and elegant, and is an outstanding representative of late Qing folk craft. The screen wall has a red wall behind it, facing the Flower Path in front, with green bamboos and cherry blossoms in the background, forming the most poetic picture of the cottage. Every day, a large number of visitors queue up to take photos here, capturing the Chinese-style moment when the four elements of "red wall, green tiles, porcelain shadow and flower path" are integrated, which has become one of the most representative internet-famous check-in landmarks in Chengdu.</p>', 11, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'du_fu_thatched_cottage_sa_13', 'du_fu_thatched_cottage', '诗史堂 / Hall of Poetic History', '诗史堂', '<p>The Hall of Poetic History is located behind Da Xie and serves as the core main hall on the central axis. Du Fu''s poems truly record the historical transformation of the Tang Dynasty from prosperity to decline around the An Lushan Rebellion, and are honored as "Poetic History" by later generations, hence the name "Hall of Poetic History". The plaque "Shi Shi Tang" in front of the hall was inscribed by the famous philosopher and former Peking University President Feng Youlan in 1980. In the center of the hall is a bronze bust of Du Fu created by the famous sculptor Liu Kaiqu, with a lean face and solemn expression, embodying the spirit of caring for the country and the people. The walls on both sides of the hall are inlaid with calligraphy works of Du Fu''s representative works such as "Five Hundred Words on the Way from Chang''an to Fengxian County", "The Thatched Cottage Broken by Autumn Wind", "Climbing High", "Spring View", "Three Officials" and "Three Farewells", which is a must-see for visitors to understand the essence of Du Fu''s poetry. At the back wall of the hall is a 1:1 scale restoration of a Tang dynasty poet Du Fu walking and chanting statue.</p>', 12, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_wuhou_shrine_sa_01', 'chengdu_wuhou_shrine', 'Sanyi Temple', '三义庙', '<p>Sanyi Temple, originally built in 1672 and relocated in 1998, now forms an independent courtyard at the southern end of the heritage zone. It enshrines the three sworn brothers: Liu Bei in the center, Guan Yu left, Zhang Fei right. The east/west wings display woodblock prints of Romance of the Three Kingdoms, replica weapons, and Guan Yu cultural exhibits. The temple complements the central axis''s "sovereign-minister" theme with a "brotherly loyalty" focus. Guan Yu''s birthday (24th day of 6th lunar month) features ceremonies and Sichuan-opera performances.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_wuhou_shrine_sa_02', 'chengdu_wuhou_shrine', 'Second Gate & Tang Stele (Three Absolutes Stele)', '二门与唐碑（三绝碑）', '<p>Crossing the main gate, the second gate bears Guo Moruo''s 1944 "Wuhou Shrine" plaque, echoing the main gate''s "Han Zhao Lie Miao" in the unique sovereign-minister protocol. Inside stands the "Three Absolutes Stele"—3.4m tall, 1.3m wide—composed by Prime Minister Pei Du, calligraphed by Liu Gongchuo, and carved by Lu Jian, 809 AD. The pavilion houses 20+ steles from Han to Qing dynasties, making it a one-stop showcase of 1,200 years of stone inscription. Visitors gain the key view of the central axis: Liu Bei''s hall in front, Zhuge''s hall behind.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_wuhou_shrine_sa_03', 'chengdu_wuhou_shrine', 'Liu Bei''s Hall (Han Zhao Lie Miao Main Hall)', '刘备殿（汉昭烈庙正殿）', '<p>Liu Bei''s Hall is the 3rd bay of the central axis, ~12m high, hung with the plaque "Ye Shao Gao Guang." Centered is the gilded seated statue of Emperor Zhaolie Liu Bei—robed, holding the jade tablet, dignified—the shrine''s principal deity. Flanking the emperor are Guan Yu''s three generations (Guan Ping, Guan Xing, Zhang Zun) and Zhang Fei''s three generations (Zhang Bao, Zhang Zun); the side walls display 14 Shu Han elite statues (Zhuge Liang, Pang Tong, Zhao Yun, Ma Chao, Huang Zhong). The stone balustrade is finely carved, and the hall houses historic plaques including Zhuge Liang''s "Collection" plaque and Lu You''s poetry stele. Liu Bei''s birthday celebration is held on the 26th day of the 6th lunar month.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_wuhou_shrine_sa_04', 'chengdu_wuhou_shrine', 'South Gate & Screen Wall', '南门与照壁', '<p>The vermilion screen wall outside the south gate bears the black-and-gold "Han Zhao Lie Miao" plaque—signaling that this is no ordinary Zhuge shrine, but a nationally unique co-enshrinement of sovereign and minister. The wall is ~18m long and ~6m tall, built of grey brick. The south plaza, shaded by green trees, often features Sichuan-opera face-changing performers and bronze statues. The "red wall with bamboo shadow" is one of Chengdu''s most photogenic classical backdrops. During Spring Festival, the plaza hosts lantern shows and intangible-heritage markets.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_wuhou_shrine_sa_05', 'chengdu_wuhou_shrine', 'Main Gate (Han Zhao Lie Miao)', '大门（汉昭烈庙）', '<p>The main gate bears the gold character "Han Zhao Lie Miao," calligraphied by Guo Moruo in 1955. The gate is a single-eave overhanging-gable building, vermilion doors with bronze beast-head knockers, flanked by two stone lions carved in the Kangxi era. The plaque is the key to understanding the shrine''s unique layout: as minister, Zhuge Liang''s shrine should be in front, but during the early Ming the order was reversed—Emperor Liu Bei''s "Han Zhao Lie Miao" stands ahead, Zhuge''s behind. The tour officially begins here.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_wuhou_shrine_sa_06', 'chengdu_wuhou_shrine', 'Hui Ling (Tomb of Liu Bei)', '惠陵（刘备墓）', '<p>Hui Ling is located at the northwest of the heritage zone, distributed in a "reverse pinwheel" layout with Han Zhao Lie Miao and Wuhou Shrine. The burial mound is ~12m high, 180m in circumference, ~3,000 sqm. Liu Bei was entombed here after his death at Baidi City in 223 AD—the tomb has never been looted in 1,780 years, protected by both the people''s loyalty and the Ming-Qing tomb guardians. The 1953 excavation of the tomb passage revealed gold, jade, swords, and horse-and-chariot artifacts. The mound, tomb passage, que-fang, and corner towers form a complete imperial-tomb architectural group.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_wuhou_shrine_sa_07', 'chengdu_wuhou_shrine', 'Guihe Tower, Qin Pavilion & Garden Area', '桂荷楼、琴亭与园林区', '<p>The garden area west of the main axis centers on the Guihe Pond, with the Qing-era civilian-style Guihe Tower, the hexagonal Qin Pavilion (named for Zhuge Liang''s "Empty City Strategy"), and several smaller structures—Tingli Pavilion, Bicao Xuan, a boat pavilion, and a bonsai garden. The garden employs the "borrowed scenery" technique, pulling distant views of Zhuge Liang''s Hall, Hui Ling Tomb, and the city wall into the pond''s reflections. Autumn brings osmanthus and lotus together, while winter features red plum blossoms and stone lanterns. The garden is also home to calligraphy steles of "Chu Shi Biao" and "Jie Zi Shu."</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_wuhou_shrine_sa_08', 'chengdu_wuhou_shrine', 'Zhuge Liang''s Hall (Jingyuan Tang)', '诸葛亮殿（静远堂）', '<p>Zhuge Liang''s Hall, the 13m-high endpoint of the central axis, bears the Qing prince''s "Eternal Fame" plaque. Inside, three generations of the Zhuge family are enshrined as gilded statues. Above Zhuge Liang''s image is the "Yi-Zhou Sage" plaque—equating him to the legendary minister Yi Yin. The veranda displays the famous "Gongxin Couplet" by Zhao Fan (late Qing), essential for understanding Sichuan governance philosophy. The hall also houses the "Three Absolutes" original text, a Ming bronze drum, and Qing-era epigraphy exhibits.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_wuhou_shrine_sa_09', 'chengdu_wuhou_shrine', 'Connecting Hall (Chu Shi Biao Stone Carving)', '过厅（出师表石刻）', '<p>The connecting hall is the 4th bay on the central axis, functioning as a transition between Liu Bei''s and Zhuge Liang''s halls. Its south and north walls bear the "Chu Shi Biao" carvings—Yue Fei''s calligraphy of the "Former" and "Latter Memorials." Yue Fei''s running script is vigorous and powerful, bridging the two loyal figures 700 years apart. The carved plaques were re-engraved in the Guangxu era. The hall bears the "Jingyuan Tang" (Tranquility Hall) plaque, quoting Zhuge Liang''s famous injunction: "Without tranquility, one cannot achieve far-reaching goals."</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chengdu_wuhou_shrine_sa_10', 'chengdu_wuhou_shrine', 'Jinli Folk Street & Waterside Pavilion', '锦里与水榭', '<p>Jinli Folk Area, opened in 2004, is Chengdu''s first "Three Kingdoms + western Sichuan folk" themed block, ~550m long, in western Sichuan folk-house style: grey-tile white-wall houses, bluestone paths, wooden archways, and overhanging eaves along the Jinli watercourse. Three highlights: ①Snacks—over 100 Sichuan-style eateries (San Da Pao, Bo Bo Ji, etc.); ②Intangible heritage—12 western Sichuan crafts (Shu embroidery, lacquerware, silver filigree, etc.); ③Performances—three daily Sichuan-opera shows. The waterside pavilion, a riverside teahouse, offers a perfect view of Jinli and the shrine''s red wall at night. Year-round red lanterns and Three Kingdoms flags decorate the street, with over 100,000 daily visitors during Spring Festival.</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_01', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 01', '南大门', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_02', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 02', '大熊猫博物馆', '<p>D 影院（循环播放《熊猫总动员》，单场约 15 分钟），是亲子家庭与科普团队最常停留的展馆。</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_03', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 03', '大熊猫太阳产房', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_04', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 04', '大熊猫星星产房', '<p>LED 星空顶），内部按星座分区：北斗七星区、白羊座区、天蝎座区等，每区对应一组育幼间 + 配套观测窗。产房采用全封闭恒温恒湿系统 + 24 小时 AI 行为监测 + 实时直播（部分时段在基地官方公众号可观看新生熊猫成长画面）。该产房主要承担基地"高端育幼示范"与"科研繁育"双重任务，注意：因育幼工作需要，部分时段可能不向公众开放，以现场公告为准。</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_05', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 05', '大熊猫月亮产房', '<p>D 影院或主题临展区。</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_06', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 06', '小熊猫1号2号活动场', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_07', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 07', '小熊猫月亮产房', '<p>Ailurus fulgens，俗称"九节狼"或"红熊猫"）繁育设计。所谓"月亮产房"取自其与月亮产房区域相邻、共享仿月相造型的外观，并非饲养幼年大熊猫。区域按月相分为多个半野生活动区，每区模拟小熊猫原生的高山森林环境，配有栖架、枯木、流水与小木屋。透过玻璃幕墙与木栅栏可观察小熊猫上树、跳跃、卷尾、进食等行为。该区是亲子家庭最喜爱的"萌系打卡点"之一。</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_08', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 08', '成年亚成年幼年大熊猫别墅', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_09', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 09', '新区展馆', '<p>VR 沉浸体验馆"+"熊猫主题邮局"+"熊猫文创零售"。展馆出口直通熊猫塔与新区观景平台。展馆外是新区中央广场，常年举办大熊猫主题快闪与季节性科普活动，是基地"科普 + 文创 + 体验"的复合节点。</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_10', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 10', '熊猫塔', '<p>LED 灯光秀（19:00-21:00）。注意：资料中关于熊猫塔的实际高度有 30 米与 50 米两种说法，建议以现场铭牌为准。</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_11', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 11', '熊猫美术馆', '<p>T 恤等）。</p>', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_12', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 12', '熊猫邮局', '', 11, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_13', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 13', '西区"月"字展馆群', '', 12, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_14', 'https_yoloadmin_vue_cstudiomunger_workers_dev', 'https yoloadmin vue cstudiomunger workers dev sub area 14', '西门', '', 13, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_01', 'qingyangg', '三清殿 / Sanqing Hall (Three Pure Ones Hall)', '三清殿', '<p>The Sanqing Hall is located after the Bagua Pavilion and before the Doumu Hall, and is the largest and most prestigious hall in Qingyang Palace, as well as the core main hall of the entire Qingyang Palace building complex. The Sanqing Hall is a large double-eave Xieshan-style brick and wood structure, with gray tiles, red walls, carved beams and painted rafters, magnificent and solemn. The main deities in the hall are the highest Taoist gods "Sanqing": Yuqing Yuanshi Tianzun (Heavenly Worthy of the Primordial Beginning), Shangqing Lingbao Tianzun (Heavenly Worthy of Spiritual Treasure), and Taiqing Dao De Tianzun (Heavenly Worthy of the Way and its Virtue, i.e. Laozi). The three pure ones sit side by side on a lotus platform, each Tianzun statue is several meters tall, with a peaceful expression and deep eyes. The plaque "Sanqing Hall" in the hall is written by a famous calligrapher in the Qing Dynasty, vigorous and powerful. The stone steps, moon platforms and railings in front of the Sanqing Hall are all carved from white marble, echoing the Taoist statues and painted murals in the hall, forming the most solemn and sacred sacrificial space in Qingyang Palace. Every year during major Taoist festivals such as the Spring Festival and the birthday of the Sanqing, a grand Zhaijiao ceremony will be held in front of the Sanqing Hall, which is the most concentrated place for Taoist cultural activities in Qingyang Palace. The Ming and Qing wood carvings, stone carvings and paintings inside and outside the hall are of high artistic value, and are precious objects for studying the history of Chinese Taoist architecture and art. The Sanqing Hall is the core place for visitors to understand Qingyang Palace and the highest deity system of Taoism. Visitors are advised to keep quiet and respect religious etiquette when visiting.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_02', 'qingyangg', '八卦亭 / Bagua Pavilion (Eight Trigrams Pavilion)', '八卦亭', '<p>The Bagua Pavilion is located after the Hunyuan Hall and before the Sanqing Hall, and is one of the most iconic buildings in Qingyang Palace, as well as a perfect combination of the architectural art and Taoist philosophy of Qingyang Palace. The Bagua Pavilion is a double-eave octagonal pyramidal building, and the body of the pavilion is mainly decorated with green glazed tiles - the eight sides of the pavilion roof and the eight sides of the pavilion body correspond to the eight trigrams of Qian, Kun, Zhen, Xun, Kan, Li, Gen and Dui. The center of the pavilion roof is a black and white Taiji diagram, with the Yin and Yang fish of the Taiji embracing and rotating, symbolizing the cosmic evolution of "The Tao gives birth to one, one gives birth to two, two gives birth to three, three gives birth to all things". The whole Bagua Pavilion has a unique shape and elegant color, the green glazed tiles shine in the sun, forming a sharp contrast with the surrounding red walls and gray tiles, and is a masterpiece of traditional Chinese Taoist temple architectural art. The pavilion originally enshrined a bronze statue of Laozi riding a green ox through Hangu Pass (which was moved to another place during some periods), which is the core cultural symbol of Qingyang Palace. The Bagua Pavilion is not only the visual "commanding height" of Qingyang Palace, but also carries the Taoist cosmology of "the unity of heaven and man" - visitors standing under the pavilion and looking up at the Taiji diagram can intuitively feel the core idea of "Tao follows nature" in Taoism. The square in front of the pavilion often hosts Taoist cultural exhibitions and Tai Chi performances, making it a must-visit place to experience the Taoist culture of Qingyang Palace.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_03', 'qingyangg', '山门 / Mountain Gate (Temple Gate)', '山门', '<p>The Mountain Gate is the first hall-style gate after the main gate in Qingyang Palace, located between the main gate and the Lingzu Hall, and is the first gate for visitors to enter the core sacrificial area of Qingyang Palace. The Mountain Gate is a single-eave Xieshan-style building, with gray tube tile roof and vermilion red door panels, and the ridge is decorated with Taoist-style chiwen ridge beasts. The four gilded characters "Purple Air Comes from the East" are hung high on the lintel - the allusion comes from the "Liexian Zhuan" (Biographies of Immortals) in which Laozi rode the green ox westward through Hangu Pass, and Guan Ling Yinxi saw the purple air coming from the east, which is in line with the core legend of Qingyang Palace''s "Laozi''s Transformation into a Barbarian". On both sides of the gate stands a majestic stone lion, male on the left and female on the right, symbolizing the guardianship and majesty of the Taoist temple. In front of the gate, you can often see traces of men and women burning incense and paper on the floor tiles, and the air is filled with the sandalwood and the unique ancient atmosphere of the temple. The mountain gate has the ceremonial significance of "separating the secular from the sacred" in the architectural pattern of the Taoist temple. Crossing the mountain gate, you will officially enter the altar area of Qingyang Palace, and visitors should keep quiet and respect religious etiquette here. The mountain gate itself does not have a separate hall, but on both sides there are often drum towers and bell towers standing symmetrically, making it an important ceremonial space node in Qingyang Palace.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_04', 'qingyangg', '斗姥殿 / Doumu Hall (Mother of the Big Dipper Hall)', '斗姥殿', '<p>The Doumu Hall is located after the Sanqing Hall and before the Jade Emperor Hall, and is one of the core halls on the central axis of Qingyang Palace. The Doumu Hall is a single-eave Xieshan-style brick and wood structure, with gray tiles, red walls, and a solemn atmosphere. The main deity in the hall is Doumu Yuanjun, also known as "Doumou Yuanjun", the highest goddess in the Taoist star worship system, who is in charge of the constellations in the sky, fertility and longevity in the mortal world. The image of Doumu Yuanjun is unique, with three faces and four heads, or three faces and eight heads, holding the sun and moon in her hands or holding the sun and moon beads, symbolizing her supreme divine power over the stars of the heavens. On both sides of the Doumu Hall are often accompanied by the "Big Dipper Seven Star Lords" - the statues of the seven star lords Tianshu, Tianxuan, Tianji, Tianquan, Yuheng, Kaiyang and Yaoguang. The Doumu Hall has a very high status in folk beliefs, and it is said that Doumu Yuanjun is one of the incarnations of the "Goddess of Child Giving", and pilgrims often pray here for offspring, health and longevity. Every year on the ninth day of the ninth lunar month, the birthday of Doumu, a grand blessing ceremony will be held in front of the hall. The Taoist statues and painted murals in the Doumu Hall are exquisite, and the stone and wood carvings outside the hall are exquisite. The Doumu Hall is a representative place to experience the Taoist star worship and female deity belief in Qingyang Palace, and is also a popular hall for visitors to pray and make wishes.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_05', 'qingyangg', '正门 / Main Gate (Front Gate)', '正门', '<p>The Main Gate is the formal entrance of the Chengdu Qingyang Palace, located on the south side of the west section of the First Ring Road, facing the city''s main road, and is magnificent. The main gate is a three-bay imitation of the official Ming and Qing style archway building, the main body is built of green bricks, covered with gray tiles and flying eaves, and the lintel has the three gilded characters "Qingyang Palace" hanging high, vigorous and simple. On both sides of the gate stands a stone carved green sheep - this is the origin of the name of Qingyang Palace: according to legend, when Laozi rode the green ox through Hangu Pass, he said "Find me in Chengdu Qingyang Market a thousand days later", and the Tang Dynasty built the temple here based on this legend. In front of the gate, the square is filled with curling incense and a crowd of visitors, and pilgrims often stop here to burn incense and pay their respects. Stepping into the main gate, you enter the outer altar area of Qingyang Palace, and you can successively pass through the Mountain Gate, Lingzu Hall, Hunyuan Hall, Bagua Pavilion, Sanqing Hall, Doumu Hall, Jade Emperor Hall and other main halls, with the central axis being symmetrical and progressive layer by layer, creating a solemn and sacred ceremonial sense of the traditional Chinese Taoist temple. The main gate is open all day, and buying a ticket to enter the park is the standard starting point for visiting Qingyang Palace.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_06', 'qingyangg', '混元殿 / Hunyuan Hall (Primordial Chaos Hall)', '混元殿', '<p>The Hunyuan Hall is located after the Lingzu Hall and before the Bagua Pavilion, and is the second main hall on the central axis of Qingyang Palace. The Hunyuan Hall was first built in the Ming Dynasty and rebuilt during the Kangxi period of the Qing Dynasty. It is one of the oldest and most historically valuable halls in Qingyang Palace. The word "Hunyuan" comes from the Taoist classic "Dao De Jing" (Tao Te Ching) "The Tao gives birth to one, one gives birth to two, two gives birth to three, three gives birth to all things" cosmology, symbolizing the original state of heaven and earth not yet divided and chaos at the beginning. The main deity in the hall is the "Dao De Tianzun" (Heavenly Worthy of the Way and its Virtue), one of the "Sanqing" in Taoism, i.e. Laozi Li Er, the philosopher of the Spring and Autumn Period. In the center of the hall, a bronze statue of Laozi is enshrined, holding a ruyi in his left hand and pressing his knee with his right hand, looking peaceful. The statue of Laozi is one of the treasures of Qingyang Palace, and it is said that on the 15th day of the second lunar month, the birthday of Laozi, a grand birthday ceremony will be held in the palace. The Hunyuan Hall is a single-eave Xieshan-style building, with exquisite Taoist ridge beasts on the roof, and the wood carvings, brick carvings and stone carvings inside and outside the hall are exquisite, integrating the architectural aesthetics of the Ming and Qing dynasties. In front of the Hunyuan Hall, Taoists often chant sutras and confess here, which is an important place to experience the core connotation of the Taoist culture of Qingyang Palace.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_07', 'qingyangg', '灵祖殿 / Lingzu Hall (Patriarch Hall)', '灵祖殿', '<p>The Lingzu Hall is located after the Mountain Gate and before the Hunyuan Hall, and is the first main hall on the central axis of Qingyang Palace, as well as the first large hall that visitors see after entering the core sacrificial area of Qingyang Palace. The Lingzu Hall is a single-eave Xieshan-style brick and wood structure, with gray tiles, red walls, flying eaves, five bays wide, and a solemn atmosphere. The main worship in the hall is the Taoist "Sanqing" one of the "Lingbao Tianzun" (Heavenly Worthy of Spiritual Treasure), also known as "Shangqing Lingbao Tianzun", one of the highest deities in Taoism. The two sides of the Lingzu Hall are often accompanied by Taoist Dharma protector generals, with various shapes and exquisite painted statues. In front of the hall, there is a large incense burner, where pilgrims and visitors burn incense to worship and pray for blessings. The Lingzu Hall plays a transitional role in the overall architectural pattern of Qingyang Palace - it not only continues the "separation of secular and sacred" of the mountain gate, but also paves the way for the rituals of the Hunyuan Hall, Sanqing Hall and other main halls behind. The plaques and couplets inside and outside the hall are mostly written by famous Qing dynasty calligraphers, containing rich Taoist cultural connotations. The Lingzu Hall has been bustling with incense all year round, and is an important place to experience the Taoist atmosphere of Qingyang Palace and understand Taoist etiquette.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_08', 'qingyangg', '玉皇殿（福禄寿照壁）/ Jade Emperor Hall (Fulu Shou Screen Wall)', '玉皇殿（福禄寿照壁）', '<p>The Jade Emperor Hall is located after the Doumu Hall and before the Descent Birth Platform and Preaching Platform, and is the last main hall on the central axis of Qingyang Palace. The Jade Emperor Hall is a double-eave Xieshan-style brick and wood structure, with gray tiles, red walls and a grand scale. The main deity in the hall is the Jade Emperor - one of the highest deities in the Taoist pantheon, second only to "Sanqing", who is in charge of the three realms and ten directions, the master of all gods, so it is also called "Tiangong" (Lord of Heaven). In front of the Jade Emperor Hall is an exquisite screen wall called the "Fulu Shou Screen Wall", which is the most popular blessing check-in landscape in Qingyang Palace. The screen wall is built of green bricks, with the three characters "Fulu Shou" inlaid in the center. "Fu" represents good fortune and well-being, "Lu" represents fame and salary, and "Shou" represents longevity and well-being - the three characters together represent the three most simple and beautiful wishes of the Chinese people. The three characters "Fulu Shou" use the same late Qing dynasty blue and white porcelain fragment inlay technique as the "Caotang" Screen Wall of Du Fu Thatched Cottage. Craftsmen cut and polished hundreds of blue and white porcelain fragments and then inlaid them together. The blue and white porcelain fragments shine in the sun, which is an outstanding representative of late Qing folk craft. Many visitors queue up here to take photos and touch the word "Fu" to pray for good luck. The Jade Emperor Hall is the "finale" of the Qingyang Palace building complex, and a grand birthday ceremony will be held every year on the ninth day of the first lunar month, the birthday of the Jade Emperor.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_09', 'qingyangg', '紫金台（唐王殿）/ Purple Gold Platform (Tang King Hall)', '紫金台（唐王殿）', '<p>The Purple Gold Platform, also known as the Tang King Hall, is located after the Descent Birth Platform and Preaching Platform, and is one of the most historically legendary commemorative buildings at the westernmost end of Qingyang Palace. The origin of the Purple Gold Platform is closely related to Emperor Xuanzong of Tang Li Longji: it is said that during the Anshi Rebellion (after 755 AD), Tang Xuanzong took refuge in Shu, once stayed in Qingyang Palace, and dreamed of Laozi appearing at night in the palace, telling him an omen of peace in the world. Tang Xuanzong, in gratitude for Laozi''s kindness, ordered the rebuilding of Qingyang Palace and built the Purple Gold Platform here in commemoration. The Purple Gold Platform is a high-platform building built of green bricks, on which there were originally portraits or statues of Tang Xuanzong, some of which were lost due to age, but the platform base, steps and pattern are still clearly visible. In front of the platform, there are often stone inscription steles recording the legend of Tang Xuanzong''s visit to Shu and the historical evolution of Qingyang Palace. The Purple Gold Platform has a "finale" status in the architectural pattern of Qingyang Palace - it is not only the end of the Taoist cultural narrative of Qingyang Palace (the spread of Laozi''s thought), but also the node of the historical narrative of Qingyang Palace (Tang Xuanzong''s visit to Shu), connecting the Taoist legend and historical truth. The Purple Gold Platform is often visited by tourists, and is a representative place in Qingyang Palace to understand the history of the Tang Dynasty and the interaction between emperors and Taoism. The whole Purple Gold Platform is not large in scale but has profound cultural connotations, and is the "finale" scenic spot on the tour route of Qingyang Palace.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_10', 'qingyangg', '茶园与老庄书院 / Tea Garden and Laozhuang Academy (Lao-Zhuang Academy)', '茶园与老庄书院', '<p>The Tea Garden and Laozhuang Academy are located in the middle and rear of the Qingyang Palace building complex, near the back gate of Qingyang Palace, and are the most leisurely characteristic cultural space in Qingyang Palace. The Tea Garden is a typical Sichuan-Western folk-style teahouse building, with green bricks, gray tiles, rattan chairs, bamboo tables, and green plants. The tea garden provides authentic Chengdu gaiwan tea (Bitan Piaoxue, Zhuyeqing, etc.), Sichuan-Western snacks (San Da Pao, Zhong Dumplings, Lai Tangyuan, Fuqi Feipian, etc.), Sichuan-style cold dishes and health tea. Visitors can rest in the tea garden after visiting the halls, brew a pot of tea, taste some snacks, listen to a section of Sichuan opera Qingyin, watch a tea art performance, and experience the most authentic "teahouse culture" in Chengdu. The Laozhuang Academy is adjacent to the tea garden and is a special academic space for displaying, researching and disseminating Taoist culture in Qingyang Palace. The academy is named after the two representative figures of Taoism - Laozi (Li Er) and Zhuangzi (Zhuang Zhou). The academy has a collection of Taoist classic versions such as the "Tao Te Ching" and "Zhuangzi", Taoist calligraphy stone inscriptions and rubbings from past dynasties, and books on Taoist culture research. The cloister outside the academy often has calligraphy exhibitions, displaying calligraphy works of famous Taoist articles. The Tea Garden and the Laozhuang Academy together form a "dynamic-static" combination of leisure and cultural system in Qingyang Palace - the halls are "dynamic" religious and cultural spaces, and the tea garden and academy are "static" cultural leisure spaces, allowing visitors to find a quiet place in the hustle and bustle of the city after pilgrimage and worship, and experience the "Taoist slow life".</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'qingyangg_sa_11', 'qingyangg', '降生台与说法台 / Descent Birth Platform and Preaching Platform', '降生台与说法台', '<p>The Descent Birth Platform and Preaching Platform are located after the Jade Emperor Hall and before the Purple Gold Platform, and are two commemorative buildings with profound cultural connotations in Qingyang Palace. The Descent Birth Platform is a commemorative building in Qingyang Palace for the birth of Laozi. According to legend, Laozi Li Er was born in Ku County, Chu State (now Luyi, Henan). In order to commemorate this "Taoist Master" and promote Taoist culture, the Taoists of later generations specially built this platform in Qingyang Palace. The Descent Birth Platform is a high platform built of green bricks, on which there were originally sculptures or murals on the theme of the birth legend of Laozi, some of which were lost due to age, but the platform base and pattern are still clearly visible, and it is an important part of the "Laozi''s Transformation into a Barbarian" cultural narrative of Qingyang Palace. The Preaching Platform is adjacent to the Descent Birth Platform, built to commemorate Laozi''s westward journey through Hangu Pass and his writing of the 5,000-character Tao Te Ching at the request of Guan Ling Yinxi. The platform originally had a statue of Laozi riding a green ox out of the pass with "purple air coming from the east" or related stone carvings, symbolizing the spread and dissemination of Taoist thought. The two platforms stand side by side in the east and west, complementing each other, and together tell the complete narrative of Laozi from birth, cultivation to the creation of Taoist philosophy, which is the core memorial space of the Taoist history and culture of Qingyang Palace. Visitors can stop here and deeply feel the philosophical mood of "Tao follows nature" and "do nothing and everything is done", which is a must-visit place to experience the deep connotation of the Taoist culture of Qingyang Palace.</p>', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wenshuyuan_sa_01', 'wenshuyuan', 'wenshuyuan sub area 01', '三大士殿（观音殿）', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wenshuyuan_sa_02', 'wenshuyuan', 'wenshuyuan sub area 02', '千佛和平塔与碑廊', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wenshuyuan_sa_03', 'wenshuyuan', 'wenshuyuan sub area 03', '园林与放生池', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wenshuyuan_sa_04', 'wenshuyuan', 'wenshuyuan sub area 04', '大雄宝殿', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wenshuyuan_sa_05', 'wenshuyuan', 'wenshuyuan sub area 05', '山门（天王殿）', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wenshuyuan_sa_06', 'wenshuyuan', 'wenshuyuan sub area 06', '文殊阁', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wenshuyuan_sa_07', 'wenshuyuan', 'wenshuyuan sub area 07', '正门（照壁）', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wenshuyuan_sa_08', 'wenshuyuan', 'wenshuyuan sub area 08', '茶园与香斋堂', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wenshuyuan_sa_09', 'wenshuyuan', 'wenshuyuan sub area 09', '藏经楼（宸经楼）', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'wenshuyuan_sa_10', 'wenshuyuan', 'wenshuyuan sub area 10', '说法堂（药师殿）', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_silk_museum_sa_01', 'hangzhou_silk_museum', 'hangzhou silk museum sub area 01', '中国丝绸博物馆入口', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_silk_museum_sa_02', 'hangzhou_silk_museum', 'hangzhou silk museum sub area 02', '户外园林与茶园', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_silk_museum_sa_03', 'hangzhou_silk_museum', 'hangzhou silk museum sub area 03', '丝路馆：中国丝绸故事', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_silk_museum_sa_04', 'hangzhou_silk_museum', 'hangzhou silk museum sub area 04', '蚕桑馆', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_silk_museum_sa_05', 'hangzhou_silk_museum', 'hangzhou silk museum sub area 05', '织造馆', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_silk_museum_sa_06', 'hangzhou_silk_museum', 'hangzhou silk museum sub area 06', '服饰馆：华美服饰', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_silk_museum_sa_07', 'hangzhou_silk_museum', 'hangzhou silk museum sub area 07', '修复馆：纺织品文物修复', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_silk_museum_sa_08', 'hangzhou_silk_museum', 'hangzhou silk museum sub area 08', '锦绣廊', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_silk_museum_sa_09', 'hangzhou_silk_museum', 'hangzhou silk museum sub area 09', '时装馆', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_silk_museum_sa_10', 'hangzhou_silk_museum', 'hangzhou silk museum sub area 10', '晓风书屋与文创空间', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_grand_canal_sa_01', 'hangzhou_grand_canal', 'hangzhou grand canal sub area 01', '武林门码头', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_grand_canal_sa_02', 'hangzhou_grand_canal', 'hangzhou grand canal sub area 02', '运河广场', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_grand_canal_sa_03', 'hangzhou_grand_canal', 'hangzhou grand canal sub area 03', '西湖文化广场', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_grand_canal_sa_04', 'hangzhou_grand_canal', 'hangzhou grand canal sub area 04', '信义坊', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_grand_canal_sa_05', 'hangzhou_grand_canal', 'hangzhou grand canal sub area 05', '富义仓', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_grand_canal_sa_06', 'hangzhou_grand_canal', 'hangzhou grand canal sub area 06', '小河直街', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_grand_canal_sa_07', 'hangzhou_grand_canal', 'hangzhou grand canal sub area 07', '小河公园', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_grand_canal_sa_08', 'hangzhou_grand_canal', 'hangzhou grand canal sub area 08', '桥西历史文化街区', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_grand_canal_sa_09', 'hangzhou_grand_canal', 'hangzhou grand canal sub area 09', '中国京杭大运河博物馆', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_grand_canal_sa_10', 'hangzhou_grand_canal', 'hangzhou grand canal sub area 10', '拱宸桥', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liuhe_pagoda_sa_01', 'hangzhou_liuhe_pagoda', 'hangzhou liuhe pagoda sub area 01', '六和塔景区入口', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liuhe_pagoda_sa_02', 'hangzhou_liuhe_pagoda', 'hangzhou liuhe pagoda sub area 02', '碑亭', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liuhe_pagoda_sa_03', 'hangzhou_liuhe_pagoda', 'hangzhou liuhe pagoda sub area 03', '六和塔', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liuhe_pagoda_sa_04', 'hangzhou_liuhe_pagoda', 'hangzhou liuhe pagoda sub area 04', '塔基与地宫', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liuhe_pagoda_sa_05', 'hangzhou_liuhe_pagoda', 'hangzhou liuhe pagoda sub area 05', '塔身一至七层', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liuhe_pagoda_sa_06', 'hangzhou_liuhe_pagoda', 'hangzhou liuhe pagoda sub area 06', '塔顶层观景台', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liuhe_pagoda_sa_07', 'hangzhou_liuhe_pagoda', 'hangzhou liuhe pagoda sub area 07', '六和塔文化陈列馆', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liuhe_pagoda_sa_08', 'hangzhou_liuhe_pagoda', 'hangzhou liuhe pagoda sub area 08', '中华古塔博览苑', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liuhe_pagoda_sa_09', 'hangzhou_liuhe_pagoda', 'hangzhou liuhe pagoda sub area 09', '钱塘江观景平台', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liuhe_pagoda_sa_10', 'hangzhou_liuhe_pagoda', 'hangzhou liuhe pagoda sub area 10', '六合钟声', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_qiandao_lake_sa_01', 'hangzhou_qiandao_lake', 'hangzhou qiandao lake sub area 01', '千岛湖中心湖区旅游码头', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_qiandao_lake_sa_02', 'hangzhou_qiandao_lake', 'hangzhou qiandao lake sub area 02', '东南湖区黄山尖', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_qiandao_lake_sa_03', 'hangzhou_qiandao_lake', 'hangzhou qiandao lake sub area 03', '梅峰岛', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_qiandao_lake_sa_04', 'hangzhou_qiandao_lake', 'hangzhou qiandao lake sub area 04', '渔乐岛', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_qiandao_lake_sa_05', 'hangzhou_qiandao_lake', 'hangzhou qiandao lake sub area 05', '龙山岛', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_qiandao_lake_sa_06', 'hangzhou_qiandao_lake', 'hangzhou qiandao lake sub area 06', '海瑞祠', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_qiandao_lake_sa_07', 'hangzhou_qiandao_lake', 'hangzhou qiandao lake sub area 07', '月光岛', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_qiandao_lake_sa_08', 'hangzhou_qiandao_lake', 'hangzhou qiandao lake sub area 08', '锁岛', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_qiandao_lake_sa_09', 'hangzhou_qiandao_lake', 'hangzhou qiandao lake sub area 09', '状元桥', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_qiandao_lake_sa_10', 'hangzhou_qiandao_lake', 'hangzhou qiandao lake sub area 10', '温馨岛', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xiaohe_street_sa_01', 'hangzhou_xiaohe_street', 'hangzhou xiaohe street sub area 01', '小河直街历史文化街区入口', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xiaohe_street_sa_02', 'hangzhou_xiaohe_street', 'hangzhou xiaohe street sub area 02', '小河直街夜景', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xiaohe_street_sa_03', 'hangzhou_xiaohe_street', 'hangzhou xiaohe street sub area 03', '小河直街运河码头遗址', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xiaohe_street_sa_04', 'hangzhou_xiaohe_street', 'hangzhou xiaohe street sub area 04', '小河直街老邮局', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xiaohe_street_sa_05', 'hangzhou_xiaohe_street', 'hangzhou xiaohe street sub area 05', '小河直街手作工坊集群', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xiaohe_street_sa_06', 'hangzhou_xiaohe_street', 'hangzhou xiaohe street sub area 06', '小河直街运河主题餐厅', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xiaohe_street_sa_07', 'hangzhou_xiaohe_street', 'hangzhou xiaohe street sub area 07', '小河公园', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xiaohe_street_sa_08', 'hangzhou_xiaohe_street', 'hangzhou xiaohe street sub area 08', '小河直街独立书店', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xiaohe_street_sa_09', 'hangzhou_xiaohe_street', 'hangzhou xiaohe street sub area 09', '小河直街民宿集群', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xiaohe_street_sa_10', 'hangzhou_xiaohe_street', 'hangzhou xiaohe street sub area 10', '小河直街古桥', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_gongchen_bridge_sa_01', 'hangzhou_gongchen_bridge', 'hangzhou gongchen bridge sub area 01', '运河广场', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_gongchen_bridge_sa_02', 'hangzhou_gongchen_bridge', 'hangzhou gongchen bridge sub area 02', '富义仓', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_gongchen_bridge_sa_03', 'hangzhou_gongchen_bridge', 'hangzhou gongchen bridge sub area 03', '拱宸桥', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_gongchen_bridge_sa_04', 'hangzhou_gongchen_bridge', 'hangzhou gongchen bridge sub area 04', '桥西历史文化街区', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_gongchen_bridge_sa_05', 'hangzhou_gongchen_bridge', 'hangzhou gongchen bridge sub area 05', '中国伞博物馆', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_gongchen_bridge_sa_06', 'hangzhou_gongchen_bridge', 'hangzhou gongchen bridge sub area 06', '中国刀剪剑博物馆', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_gongchen_bridge_sa_07', 'hangzhou_gongchen_bridge', 'hangzhou gongchen bridge sub area 07', '中国扇博物馆', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_gongchen_bridge_sa_08', 'hangzhou_gongchen_bridge', 'hangzhou gongchen bridge sub area 08', '杭州工艺美术博物馆', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_gongchen_bridge_sa_09', 'hangzhou_gongchen_bridge', 'hangzhou gongchen bridge sub area 09', '张大仙庙', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_gongchen_bridge_sa_10', 'hangzhou_gongchen_bridge', 'hangzhou gongchen bridge sub area 10', '小河公园', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_hefang_street_sa_01', 'hangzhou_hefang_street', 'hangzhou hefang street sub area 01', '河坊街东入口', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_hefang_street_sa_02', 'hangzhou_hefang_street', 'hangzhou hefang street sub area 02', '吴山广场与城隍阁', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_hefang_street_sa_03', 'hangzhou_hefang_street', 'hangzhou hefang street sub area 03', '鼓楼', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_hefang_street_sa_04', 'hangzhou_hefang_street', 'hangzhou hefang street sub area 04', '望仙阁', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_hefang_street_sa_05', 'hangzhou_hefang_street', 'hangzhou hefang street sub area 05', '胡庆余堂中药博物馆', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_hefang_street_sa_06', 'hangzhou_hefang_street', 'hangzhou hefang street sub area 06', '方回春堂', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_hefang_street_sa_07', 'hangzhou_hefang_street', 'hangzhou hefang street sub area 07', '朱炳仁铜雕艺术博物馆', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_hefang_street_sa_08', 'hangzhou_hefang_street', 'hangzhou hefang street sub area 08', '江南铜屋', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_hefang_street_sa_09', 'hangzhou_hefang_street', 'hangzhou hefang street sub area 09', '南宋御街', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_hefang_street_sa_10', 'hangzhou_hefang_street', 'hangzhou hefang street sub area 10', '大井巷', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_faxi_temple_sa_01', 'hangzhou_faxi_temple', 'hangzhou faxi temple sub area 01', '法喜寺山门', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_faxi_temple_sa_02', 'hangzhou_faxi_temple', 'hangzhou faxi temple sub area 02', '法喜寺素斋堂', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_faxi_temple_sa_03', 'hangzhou_faxi_temple', 'hangzhou faxi temple sub area 03', '天王殿', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_faxi_temple_sa_04', 'hangzhou_faxi_temple', 'hangzhou faxi temple sub area 04', '圆通宝殿', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_faxi_temple_sa_05', 'hangzhou_faxi_temple', 'hangzhou faxi temple sub area 05', '大雄宝殿', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_faxi_temple_sa_06', 'hangzhou_faxi_temple', 'hangzhou faxi temple sub area 06', '藏经楼', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_faxi_temple_sa_07', 'hangzhou_faxi_temple', 'hangzhou faxi temple sub area 07', '地藏殿', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_faxi_temple_sa_08', 'hangzhou_faxi_temple', 'hangzhou faxi temple sub area 08', '五百罗汉堂', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_faxi_temple_sa_09', 'hangzhou_faxi_temple', 'hangzhou faxi temple sub area 09', '白云峰观景台', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_faxi_temple_sa_10', 'hangzhou_faxi_temple', 'hangzhou faxi temple sub area 10', '御碑亭', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_zhejiang_museum_sa_01', 'hangzhou_zhejiang_museum', 'hangzhou zhejiang museum sub area 01', '浙江省博物馆之江馆区主入口与大堂', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_zhejiang_museum_sa_02', 'hangzhou_zhejiang_museum', 'hangzhou zhejiang museum sub area 02', '之江文化中心整体参观指南', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_zhejiang_museum_sa_03', 'hangzhou_zhejiang_museum', 'hangzhou zhejiang museum sub area 03', '浙江历史文化陈列厅', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_zhejiang_museum_sa_04', 'hangzhou_zhejiang_museum', 'hangzhou zhejiang museum sub area 04', '青瓷文化馆', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_zhejiang_museum_sa_05', 'hangzhou_zhejiang_museum', 'hangzhou zhejiang museum sub area 05', '海洋文化馆', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_zhejiang_museum_sa_06', 'hangzhou_zhejiang_museum', 'hangzhou zhejiang museum sub area 06', '书画馆', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_zhejiang_museum_sa_07', 'hangzhou_zhejiang_museum', 'hangzhou zhejiang museum sub area 07', '雷峰塔文物馆', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_zhejiang_museum_sa_08', 'hangzhou_zhejiang_museum', 'hangzhou zhejiang museum sub area 08', '之江馆区数字体验馆', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_zhejiang_museum_sa_09', 'hangzhou_zhejiang_museum', 'hangzhou zhejiang museum sub area 09', '之江馆区文创商店', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_zhejiang_museum_sa_10', 'hangzhou_zhejiang_museum', 'hangzhou zhejiang museum sub area 10', '之江馆区特展厅', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_lingyin_temple_sa_01', 'hangzhou_lingyin_temple', 'hangzhou lingyin temple sub area 01', '灵隐寺景区入口', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_lingyin_temple_sa_02', 'hangzhou_lingyin_temple', 'hangzhou lingyin temple sub area 02', '五百罗汉堂', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_lingyin_temple_sa_03', 'hangzhou_lingyin_temple', 'hangzhou lingyin temple sub area 03', '飞来峰造像', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_lingyin_temple_sa_04', 'hangzhou_lingyin_temple', 'hangzhou lingyin temple sub area 04', '理公塔与冷泉亭', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_lingyin_temple_sa_05', 'hangzhou_lingyin_temple', 'hangzhou lingyin temple sub area 05', '天王殿', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_lingyin_temple_sa_06', 'hangzhou_lingyin_temple', 'hangzhou lingyin temple sub area 06', '大雄宝殿', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_lingyin_temple_sa_07', 'hangzhou_lingyin_temple', 'hangzhou lingyin temple sub area 07', '药师殿', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_lingyin_temple_sa_08', 'hangzhou_lingyin_temple', 'hangzhou lingyin temple sub area 08', '藏经楼', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_lingyin_temple_sa_09', 'hangzhou_lingyin_temple', 'hangzhou lingyin temple sub area 09', '华严殿', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_lingyin_temple_sa_10', 'hangzhou_lingyin_temple', 'hangzhou lingyin temple sub area 10', '济公殿', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liangzhu_ancient_city_sa_01', 'hangzhou_liangzhu_ancient_city', 'hangzhou liangzhu ancient city sub area 01', '良渚古城遗址公园南入口', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liangzhu_ancient_city_sa_02', 'hangzhou_liangzhu_ancient_city', 'hangzhou liangzhu ancient city sub area 02', '雉山观景台', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liangzhu_ancient_city_sa_03', 'hangzhou_liangzhu_ancient_city', 'hangzhou liangzhu ancient city sub area 03', '陆城门遗址', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liangzhu_ancient_city_sa_04', 'hangzhou_liangzhu_ancient_city', 'hangzhou liangzhu ancient city sub area 04', '水城门遗址', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liangzhu_ancient_city_sa_05', 'hangzhou_liangzhu_ancient_city', 'hangzhou liangzhu ancient city sub area 05', '南城墙遗址', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liangzhu_ancient_city_sa_06', 'hangzhou_liangzhu_ancient_city', 'hangzhou liangzhu ancient city sub area 06', '钟家港古河道', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liangzhu_ancient_city_sa_07', 'hangzhou_liangzhu_ancient_city', 'hangzhou liangzhu ancient city sub area 07', '莫角山宫殿遗址', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liangzhu_ancient_city_sa_08', 'hangzhou_liangzhu_ancient_city', 'hangzhou liangzhu ancient city sub area 08', '反山王陵', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liangzhu_ancient_city_sa_09', 'hangzhou_liangzhu_ancient_city', 'hangzhou liangzhu ancient city sub area 09', '姜家山贵族墓地', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_liangzhu_ancient_city_sa_10', 'hangzhou_liangzhu_ancient_city', 'hangzhou liangzhu ancient city sub area 10', '美人地遗址', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_01', 'hangzhou_west_lake', 'hangzhou west lake sub area 01', '断桥残雪', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_02', 'hangzhou_west_lake', 'hangzhou west lake sub area 02', '柳浪闻莺', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_03', 'hangzhou_west_lake', 'hangzhou west lake sub area 03', '湖滨公园', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_04', 'hangzhou_west_lake', 'hangzhou west lake sub area 04', '三潭印月', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_05', 'hangzhou_west_lake', 'hangzhou west lake sub area 05', '白堤', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_06', 'hangzhou_west_lake', 'hangzhou west lake sub area 06', '平湖秋月', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_07', 'hangzhou_west_lake', 'hangzhou west lake sub area 07', '孤山与西泠印社', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_08', 'hangzhou_west_lake', 'hangzhou west lake sub area 08', '曲院风荷', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_09', 'hangzhou_west_lake', 'hangzhou west lake sub area 09', '苏堤春晓', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_10', 'hangzhou_west_lake', 'hangzhou west lake sub area 10', '花港观鱼', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_11', 'hangzhou_west_lake', 'hangzhou west lake sub area 11', '雷峰塔', '<p>Description</p>', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_sa_12', 'hangzhou_west_lake', 'hangzhou west lake sub area 12', '南屏晚钟', '<p>Description</p>', 11, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_cultural_plaza_sa_01', 'hangzhou_west_lake_cultural_plaza', 'hangzhou west lake cultural plaza sub area 01', '西湖文化广场主雕塑', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_cultural_plaza_sa_02', 'hangzhou_west_lake_cultural_plaza', 'hangzhou west lake cultural plaza sub area 02', '西湖文化广场银杏大道', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_cultural_plaza_sa_03', 'hangzhou_west_lake_cultural_plaza', 'hangzhou west lake cultural plaza sub area 03', '浙江省科技馆', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_cultural_plaza_sa_04', 'hangzhou_west_lake_cultural_plaza', 'hangzhou west lake cultural plaza sub area 04', '浙江自然博物院', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_cultural_plaza_sa_05', 'hangzhou_west_lake_cultural_plaza', 'hangzhou west lake cultural plaza sub area 05', '浙江省博物馆（武林馆区）', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_cultural_plaza_sa_06', 'hangzhou_west_lake_cultural_plaza', 'hangzhou west lake cultural plaza sub area 06', '西湖文化广场音乐喷泉', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_cultural_plaza_sa_07', 'hangzhou_west_lake_cultural_plaza', 'hangzhou west lake cultural plaza sub area 07', '运河魂雕塑与亲水平台', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_cultural_plaza_sa_08', 'hangzhou_west_lake_cultural_plaza', 'hangzhou west lake cultural plaza sub area 08', '西湖文化广场地下商业街', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_cultural_plaza_sa_09', 'hangzhou_west_lake_cultural_plaza', 'hangzhou west lake cultural plaza sub area 09', '西湖文化广场七夕灯会会场', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_west_lake_cultural_plaza_sa_10', 'hangzhou_west_lake_cultural_plaza', 'hangzhou west lake cultural plaza sub area 10', '西湖文化广场城市观景台', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xixi_wetland_sa_01', 'hangzhou_xixi_wetland', 'hangzhou xixi wetland sub area 01', '西溪国家湿地公园北门入口', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xixi_wetland_sa_02', 'hangzhou_xixi_wetland', 'hangzhou xixi wetland sub area 02', '西溪洪园', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xixi_wetland_sa_03', 'hangzhou_xixi_wetland', 'hangzhou xixi wetland sub area 03', '秋雪庵', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xixi_wetland_sa_04', 'hangzhou_xixi_wetland', 'hangzhou xixi wetland sub area 04', '深潭口与河渚街', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xixi_wetland_sa_05', 'hangzhou_xixi_wetland', 'hangzhou xixi wetland sub area 05', '西溪梅墅', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xixi_wetland_sa_06', 'hangzhou_xixi_wetland', 'hangzhou xixi wetland sub area 06', '莲花滩观鸟区', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xixi_wetland_sa_07', 'hangzhou_xixi_wetland', 'hangzhou xixi wetland sub area 07', '西溪草堂', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xixi_wetland_sa_08', 'hangzhou_xixi_wetland', 'hangzhou xixi wetland sub area 08', '西溪龙舟陈列馆', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xixi_wetland_sa_09', 'hangzhou_xixi_wetland', 'hangzhou xixi wetland sub area 09', '西溪湿地生态科普馆', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_xixi_wetland_sa_10', 'hangzhou_xixi_wetland', 'hangzhou xixi wetland sub area 10', '西溪湿地摇橹船体验', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_leifeng_pagoda_sa_01', 'hangzhou_leifeng_pagoda', 'hangzhou leifeng pagoda sub area 01', '雷峰塔景区入口', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_leifeng_pagoda_sa_02', 'hangzhou_leifeng_pagoda', 'hangzhou leifeng pagoda sub area 02', '雷峰塔遗址底层', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_leifeng_pagoda_sa_03', 'hangzhou_leifeng_pagoda', 'hangzhou leifeng pagoda sub area 03', '新雷峰塔一层', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_leifeng_pagoda_sa_04', 'hangzhou_leifeng_pagoda', 'hangzhou leifeng pagoda sub area 04', '新雷峰塔二至四层', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_leifeng_pagoda_sa_05', 'hangzhou_leifeng_pagoda', 'hangzhou leifeng pagoda sub area 05', '雷峰塔顶层观景台', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_leifeng_pagoda_sa_06', 'hangzhou_leifeng_pagoda', 'hangzhou leifeng pagoda sub area 06', '雷峰塔文化陈列馆', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'hangzhou_leifeng_pagoda_sa_07', 'hangzhou_leifeng_pagoda', 'hangzhou leifeng pagoda sub area 07', '夕照亭与放生池', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tongli_ancient_town_sa_01', 'suzhou_tongli_ancient_town', 'Tuisi Garden (Retreat & Reflection Garden)', '退思园', '<p>Description： 退思园建于清光绪年间，园主任兰生被革职回乡后筑此园，取《左传》"进思尽忠，退思补过"之意命名。园林面积仅九亩八分，却以精湛的布局在有限空间内营造出亭台楼阁、水池假山、花木廊桥的无限意境。园内建筑皆贴水而筑，形成"坐春望月楼""菰雨生凉轩""桂花厅"等贴水建筑群，水面如镜倒映亭阁，虚实交融。退思园是世界文化遗产，也是同里古镇最核心的观赏景点，其"小中见大"的造园手法被誉为江南园林的典范。 Built in the Guangxu era of the Qing dynasty, the garden was constructed by Ren Lansheng after his dismissal from office, named after the Zuo Zhuan phrase "Advance to serve with loyalty, retreat to reflect and mend faults." Though only 9.8 mu in area, its masterly layout creates infinite poetic resonance within limited space — pavilions, towers, pools, rockeries, flowers, trees, corridors, and bridges. All buildings are constructed flush against the water, forming a "water-hugging" architectural ensemble including Spring View Tower, Cool Arrowroot Rain Pavilion, and Osmanthus Hall. The mirror-like water reflects pavilions, merging reality and illusion. As a UNESCO World Heritage site and Tongli''s core attraction, its "seeing the vast in the small" design philosophy is hailed as the paradigm of Jiangnan gardens.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tongli_ancient_town_sa_02', 'suzhou_tongli_ancient_town', 'Pearl Tower', '珍珠塔', '<p>Description： 珍珠塔并非一座实体的塔，而是同里流传已久的戏曲故事与与之关联的陈氏旧宅的合称。故事讲述同里望族方卿家道中落后投奔姑母陈翠娥，陈家假称赠珍珠塔实为以塔藏银资助方卿，终成佳话。这段"珍珠塔"传奇被编为苏州评弹与戏曲广为传唱，成为同里最著名的民间叙事。现存陈家旧宅经修复后对游客开放，宅内可观赏与故事相关的展示与场景还原，让游客在行走中重温这段跨越数百年的江南忠义与深情。 The Pearl Tower is not a physical tower, but the combined name of a long-celebrated opera story in Tongli and the associated Chen family mansion. The tale tells of Fang Qing, a Tongli noble fallen into poverty, seeking help from his aunt Chen Cuie; the Chen family pretended to gift a pearl tower but actually hid silver within it to aid Fang Qing, eventually leading to a happy ending. This "Pearl Tower" legend has been adapted into Suzhou pingtan (storytelling) and opera, becoming Tongli''s most famous folk narrative. The restored Chen mansion is now open to visitors, with displays and scene reconstructions related to the story, allowing guests to relive this tale of Jiangnan loyalty and deep affection spanning centuries.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tongli_ancient_town_sa_03', 'suzhou_tongli_ancient_town', 'Three Bridges', '三桥', '<p>Description： 三桥是同里古镇最具标志性的景观，指横跨镇中心河道的三座古石桥——太平桥、吉利桥与长庆桥。三桥呈"品"字形排列，彼此相距不远，构成同里水乡空间的视觉焦点。当地传统中，新人婚嫁须走三桥以求太平吉利长庆，每逢节庆居民亦喜走三桥祈福，这一习俗延续数百年至今不衰。三桥之下碧水悠悠，两岸粉墙黛瓦，桥上行人络绎，桥下舟楫往来，是同里水乡生活画卷中最生动的一帧，也是摄影师最钟爱的取景角度。 The Three Bridges are Tongli''s most iconic landscape — three ancient stone bridges spanning the town''s central waterways: Taiping (Peace), Jili (Good Fortune), and Changqing (Lasting Celebration). Arranged in a "品" (pin) pattern close together, they form the visual focal point of Tongli''s waterside space. In local tradition, newlyweds must walk the three bridges for blessings of peace, fortune, and lasting joy; residents also stroll the bridges during festivals to pray for good luck — a custom sustained for centuries. Below the bridges, emerald water flows gently; on both banks, white walls and black tiles; on the bridges, pedestrians stream; beneath them, boats pass — the most vivid frame of Tongli''s waterside life scroll, and photographers'' favorite angle.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tongli_ancient_town_sa_04', 'suzhou_tongli_ancient_town', 'Chongben Hall', '崇本堂', '<p>Description： 崇本堂建于清宣统年间，为同里富商钱友琴所建宅第，取"崇本思源"之意命名。宅第虽面积不大，却以极其精美的砖雕门楼与木雕装饰在同里古建筑中独树一帜。门楼上的砖雕层次丰富，题材涵盖戏文故事与吉祥图案，刀法细腻入微；厅堂内的木雕门窗则以《西厢记》等戏曲场景为蓝本，人物栩栩如生。崇本堂沿河而建，前后三进，从门厅到正厅再到内宅，空间层层递进，体现了江南民居"前店后宅"或"前厅后寝"的典型格局，是解读同里商人阶层生活方式的珍贵实例。 Built in the Xuantong era of the Qing dynasty, Chongben Hall was the residence of wealthy Tongli merchant Qian Youqin, named for the principle of "honoring roots and reflecting on origins." Though modest in scale, it stands out among Tongli''s ancient architecture for its exceptionally refined brick-carved gate towers and wood-carved decorations. The gate tower''s brick carvings are richly layered, depicting theatrical tales and auspicious motifs with meticulous knife work; interior wood-carved doors and windows render scenes from The Romance of the Western Chamber and other operas with lifelike figures. Built along the river in three progressive courtyards — from entrance hall to main hall to inner quarters — it embodies the typical Jiangnan residential pattern of "front hall, rear dwelling," a precious case study of Tongli merchant-class life.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tongli_ancient_town_sa_05', 'suzhou_tongli_ancient_town', 'Jiayin Hall', '嘉荫堂', '<p>Description： 嘉荫堂建于民国初年，为同里富商柳炳南所建。宅第规模宏大，前后五进院落依次展开，从门厅、轿厅、正厅到内厅与后花园，完整再现了江南大户人家的空间序列。正厅俗称"纱帽厅"，因其梁架结构形似明代官员乌纱帽的帽翅而得名，厅内雕梁画栋，工艺精湛。嘉荫堂沿河布局，正门临水，侧面设有私家码头，商人以舟代步的生活方式在此留下清晰印记。整组建筑既有官宅的庄重，又有商宅的实用，是了解近代同里商业社会阶层结构的绝佳窗口。 Built in the early Republic of China era, Jiayin Hall was the mansion of wealthy Tongli merchant Liu Bingnan. Grand in scale, its five progressive courtyards unfold sequentially — entrance hall, sedan hall, main hall, inner hall, and rear garden — fully reproducing the spatial sequence of a great Jiangnan household. The main hall is called the纱帽 (Gauze-Hat) Hall because its roof-beam structure resembles the wings of a Ming official''s gauze hat; inside, carved beams and painted pillars showcase superb craftsmanship. Jiayin Hall is laid out along the river, its main gate facing the water with a private pier on the side — a clear imprint of the merchant lifestyle of traveling by boat. The complex balances official dignity with commercial practicality, an excellent window into Tongli''s modern business-social class structure.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tongli_ancient_town_sa_06', 'suzhou_tongli_ancient_town', 'Gengle Hall', '耕乐堂', '<p>Description： 耕乐堂为明代处士朱祥所建，取"耕读传家、乐在其中"之意命名，是同里现存最古老的民居之一。朱祥一生不愿入仕，以农耕读书为乐，其宅园也因此带有质朴恬淡的文人气质。耕乐堂前后四进，附有小型园林，园内植有桂花、白皮松等古树，幽径回廊之间尽显明代文人园居的朴素美学。与同里其他富商宅第相比，耕乐堂少有奢华雕饰，更多是清水砖墙与素木梁架的本色呈现，恰恰因此保留了明代江南民居的原真风貌，为研究明代民间建筑提供了珍贵的实物标本。 Gengle Hall was built by Ming-era recluse Zhu Xiang, named for the ideal of "farming and studying as family tradition, joy within" — one of Tongli''s oldest surviving dwellings. Zhu Xiang refused official career all his life, finding joy in farming and reading; his residence and garden thus carry the plain, serene character of a literati-scholar. Four progressive courtyards with an attached small garden planted with osmanthus and white-bark pine, its winding paths and corridors embody the austere aesthetics of Ming literati garden-living. Compared with Tongli''s merchant mansions, Gengle Hall has few ornate carvings — instead, plain brick walls and bare wooden beams reveal their natural beauty, preserving the authentic appearance of Ming Jiangnan dwellings and providing precious physical specimens for studying Ming vernacular architecture.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tongli_ancient_town_sa_07', 'suzhou_tongli_ancient_town', 'Ming-Qing Street', '明清街', '<p>Description： 明清街是同里古镇的主要商业街巷，全长约三百米，两侧保留了明清时期的店铺建筑格局与街面风貌。青石板路面上百年足迹磨出的光泽至今可见，两侧店铺经营着苏绣、太湖珍珠、同里特产酱菜与状元蹄等传统商品，老字号与新商铺混搭出古今交织的独特市井气息。街巷上空偶见横跨的廊棚，为行人遮阳挡雨，是江南水乡商业街的典型特征。漫步明清街，视觉上是粉墙黛瓦的古镇画卷，嗅觉上是酱菜与桂花藕的甜香，触觉上是石板的温润，感官在此汇聚成完整的同里记忆。 Ming-Qing Street is Tongli''s main commercial lane, roughly 300 meters long, with Ming-Qing-era shop layouts and street-front character preserved on both sides. Gloss from centuries of foot traffic still gleams on the flagstone pavement. Shops sell Su embroidery, Lake Tai pearls, Tongli''s signature pickled vegetables and "champion''s trotter" braised pork — old brands and new stalls mixing into a unique marketplace atmosphere interweaving past and present. Occasional langpeng (roofed corridors) span the street overhead, sheltering pedestrians from sun and rain — a hallmark of Jiangnan waterside commercial streets. Strolling Ming-Qing Street, the eyes take in the scroll of white walls and black tiles; the nose catches the sweet scent of pickles and lotus-root sweets; the hands feel flagstones'' warmth — senses converge into a complete Tongli memory.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tongli_ancient_town_sa_08', 'suzhou_tongli_ancient_town', 'Nanyuan Tea House', '南园茶社', '<p>Description： 南园茶社始建于清末，是同里古镇最具代表性的传统茶馆，临河而设，楼上楼下两层空间皆是木窗临水的苏式格局。茶社以碧螺春与本地茶点为主，下午时段常有苏州评弹艺人驻场演出，弦索叮咚、唱腔婉转，在水乡茶馆的语境中格外动人。临窗而坐，一壶清茶在手，窗外河上舟来舟往，耳畔评弹声声入耳，时间在此仿佛放慢了脚步。南园茶社不仅是一个饮茶之所，更是同里水乡生活方式的活态标本，让游客得以在短暂的停留中触摸到江南茶馆文化绵延百年的脉搏。 Founded in the late Qing dynasty, Nanyuan Tea House is Tongli''s most iconic traditional tea house, set along the river with two floors of wood-windowed, water-facing Suzhou-style spaces. The house features Biluochun tea and local snacks; afternoon sessions often host Suzhou pingtan performers — plucked strings ringing, melodic voices soaring, particularly moving in the waterside tea-house context. Sitting by the window with a pot of clear tea, watching boats pass on the river outside, pingtan melodies drifting into the ears, time seems to slow its pace. Nanyuan Tea House is more than a place for tea — it is a living specimen of Tongli''s waterside lifestyle, allowing visitors, in a brief pause, to touch the century-long pulse of Jiangnan tea-house culture.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tongli_ancient_town_sa_09', 'suzhou_tongli_ancient_town', 'Chen Qubai''s Former Residence', '陈去病故居', '<p>Description： 陈去病故居是近代著名革命志士、南社创始人之一陈去病在同里的旧居。陈去病（1874-1933）为清末民初重要的革命文人，与柳亚子等共创南社，以文学为武器鼓吹反清革命与民主思想。故居为传统江南民居格局，内有陈去病生平事迹展，通过书信、照片、手稿等实物呈现其从同里书生到革命先驱的人生轨迹。故居所在的同里旧巷宁静幽深，与陈去病波澜壮阔的革命生涯形成鲜明对照，恰恰揭示了一个真理：近代中国的巨变，往往始于江南小镇一间不起眼的屋舍之中。 Chen Qubai''s Former Residence is the old home of the renowned modern revolutionary and Nanshe (Southern Society) co-founder in Tongli. Chen Qubai (1874–1933) was a pivotal revolutionary literatus of the late Qing and early Republic, co-founding Nanshe with Liu Yazi and others, wielding literature as a weapon to advocate anti-Qing revolution and democratic ideals. The residence follows a traditional Jiangnan dwelling layout; inside, an exhibition of Chen''s life uses letters, photographs, and manuscripts to trace his journey from Tongli scholar to revolutionary pioneer. The quiet, deep old alley where the house sits contrasts sharply with Chen''s turbulent revolutionary career, revealing a truth: modern China''s upheavals often began in an unremarkable room in a small Jiangnan town.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tongli_ancient_town_sa_10', 'suzhou_tongli_ancient_town', 'Luoxing Island', '罗星洲', '<p>Description： 罗星洲是同里湖中的一座小岛，需从古镇码头乘船约十分钟方可抵达。岛上现存观音殿、文昌阁、斗姆阁等宗教建筑，佛道儒三教并存，体现了江南民间信仰的包容传统。岛上还设有小型园林，曲径通幽，花木扶疏，临水环望四周湖光山色，远眺同里古镇的黛瓦屋脊隐约可见。罗星洲历史上多次毁于战火与灾害又屡次重建，现存建筑多为近代重修，但岛上古树与遗址犹存沧桑记忆。乘船往罗星洲，水上风来，波光粼粼，抵达小岛如入世外桃源，是同里游览中最富仪式感的一段旅程。 Luoxing Island is a small island in Tongli Lake, reached by roughly a ten-minute boat ride from the ancient town pier. Existing structures include the Guanyin Hall, Wenchang Pavilion, and Doumu Pavilion, where Buddhist, Daoist, and Confucian faiths coexist — reflecting Jiangnan folk religion''s inclusive tradition. A small garden on the island features winding paths, lush plantings, and panoramic lake-and-hill views; gazing across the water, Tongli''s black-tiled rooftops appear faintly in the distance. Luoxing Island has been destroyed and rebuilt multiple times through war and disaster; current buildings are largely modern reconstructions, but ancient trees and ruins preserve memories of past turmoil. The boat journey — wind on the water, shimmering waves — makes arriving at the island feel like entering an otherworld paradise, the most ritual-laden segment of any Tongli visit.</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_zhouzhuang_ancient_town_sa_01', 'suzhou_zhouzhuang_ancient_town', 'Ancient Stage', '古戏台', '<p>Description： 周庄古戏台位于古镇入口区域，是一座典型的江南传统戏台建筑，始建于清代，后经修缮，保留了原有的木结构形制。戏台坐南朝北，背面临水，前台歇山顶，飞檐翘角，后台化妆间与前台以木屏相隔。台基以石柱支撑，高出地面约一米，四面可观。戏台木雕精美，梁枋、雀替、额枋上雕有戏曲故事与吉祥纹样，刀法细腻，是研究江南民间雕刻艺术的重要实物。昔日逢年过节，镇上请来戏班在此演出昆曲、越剧、锡剧等地方戏曲，乡民聚于台前水畔听戏看热闹，是周庄民间文化生活的重要记忆。如今古戏台仍定期有昆曲等传统戏曲演出，游客可免费入内观赏。 The Ancient Stage is located near the entrance of Zhouzhuang and is a classic example of a traditional Jiangnan theatrical stage. First built during the Qing Dynasty and later restored, it retains its original timber-frame structure. The stage faces north, with its back to the water. The front stage features a gable-and-hip roof with upturned flying eaves, while the backstage dressing area is separated from the front by a wooden screen. The stone-pillar foundation raises the stage about one meter above ground, allowing viewing from all four sides. Wood carvings adorn the beams, brackets, and lintels — depicting opera scenes and auspicious motifs with exquisite craftsmanship, making this stage an important artifact for the study of Jiangnan folk carving art. In centuries past, opera troupes were invited to perform Kunqu, Yueju, and Xiju during festivals, with townsfolk gathering at the water''s edge to watch — a cherished memory of Zhouzhuang''s cultural life. Today, the stage still hosts regular performances of Kunqu and other traditional operas, open to all visitors at no additional charge.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_zhouzhuang_ancient_town_sa_02', 'suzhou_zhouzhuang_ancient_town', 'Twin Bridges', '双桥', '<p>Description： 双桥由世德桥和永安桥两座古桥组成，因一横一竖、一圆一方相连如古代钥匙，又被称为"钥匙桥"。世德桥为石拱桥，建于明万历年间（1573-1620），永安桥为石梁桥，建于同一时期。两桥横跨银子浜与南北市河交汇处，桥下流水潺潺，桥畔粉墙黛瓦的民居倒映水中，构成一幅天然的水墨画卷。1984年，著名画家陈逸飞以双桥为题材创作油画《故乡的回忆》，后经哈默推荐被联合国选为首日封图案，周庄由此走向世界，双桥也成为了江南水乡最具辨识度的文化符号。每逢清晨薄雾或黄昏夕照，双桥便呈现出最动人的光影，是摄影爱好者不可错过的取景地。 The Twin Bridges — Shide Bridge and Yong''an Bridge — are so named because they intersect at right angles, one arched and one straight, together resembling an ancient Chinese key. Hence they are also called "Key Bridge" (钥匙桥). Shide Bridge is a stone arch bridge built during the Wanli era of the Ming Dynasty (1573–1620); Yong''an Bridge, a stone beam bridge, dates from the same period. The two bridges span the confluence of Yinzi Stream and the North-South River. Water murmurs below; whitewashed houses with dark-tiled roofs line the banks, their reflections creating a natural ink-wash painting. In 1984, the renowned painter Chen Yifei created the oil painting "Memory of Hometown" featuring the Twin Bridges. Recommended by Armand Hammer, the painting was selected by the United Nations for a first-day cover — launching Zhouzhuang onto the world stage and making the Twin Bridges the most recognizable cultural symbol of Jiangnan water towns. At dawn, when mist rises from the river, or at dusk, when golden light floods the scene, the Twin Bridges reveal their most breathtaking beauty — an unmissable subject for photographers.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_zhouzhuang_ancient_town_sa_03', 'suzhou_zhouzhuang_ancient_town', 'Shen Hall', '沈厅', '<p>Description： 沈厅是周庄古镇内规模最大的民居建筑，由江南首富沈万三的后裔沈本仁于清乾隆七年（1742年）建成，占地两千余平方米，大小房屋百余间。整个建筑群坐东朝西，共七进五门楼，沿中轴线依次排列前厅、正厅、后厅等，两侧有厢房、走廊相连，形成严谨有序的院落格局。正厅"松茂堂"面阔五间，梁柱粗壮，楠木雕花落地长窗精美绝伦，门楼砖雕层次丰富，刻有"红楼梦""西厢记"等戏文故事，是江南民居砖雕艺术的精品。沈厅的格局体现了江南富商家族"前店中宅后花园"的生活模式，也是了解明清时期商业家族兴衰史的重要窗口。如今厅内设有沈万三生平事迹展，讲述了这位传奇商人的跌宕人生。 Shen Hall is the largest private residence in Zhouzhuang, built in 1742 (the seventh year of the Qianlong reign) by Shen Benren, a descendant of the legendary "richest man in Jiangnan" — Shen Wansan. Covering over 2,000 square meters with more than 100 rooms, the complex faces west and comprises seven courtyards with five gateways along a central axis — front hall, main hall, rear hall, and more — flanked by side chambers and connecting corridors in a rigorously ordered layout. The main hall, "Songmao Hall," spans five bays with massive beams and columns. Its nanmu-wood carved floor-to-ceiling latticed windows are works of art, and the brick carvings on the gateways — depicting scenes from "Dream of the Red Chamber" and "Romance of the Western Chamber" — are masterpieces of Jiangnan residential brick sculpture. The layout reflects the classic merchant-family pattern of "shop in front, residence in the middle, garden behind," offering a vital window into the rise and fall of Ming-Qing commercial dynasties. Today, the hall houses an exhibition on Shen Wansan''s life, telling the dramatic story of this legendary merchant.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_zhouzhuang_ancient_town_sa_04', 'suzhou_zhouzhuang_ancient_town', 'Zhang Hall', '张厅', '<p>Description： 张厅原名"玉燕堂"，始建于明代正统年间（1436-1449），由中山王徐达之弟徐孟清后裔所建，后归张姓所有，故称张厅。整座建筑坐东朝西，共六进，占地逾千平方米，房屋七十余间。张厅最大的特色是穿镇而过的明泾河从其院落中直接流过，河上建有私家小码头，可泊船登岸。这种"前有街巷可通行轿，后有河道可行舟船"的建筑格局，被形象地概括为"轿从门进，船自家中过"，是江南水乡民居建筑中最具代表性的空间形式之一。厅内楠木柱础、木雕窗棂保存完好，后院有小巧水景园林，芭蕉翠竹点缀其间，既有官宦宅第的庄重，又具水乡人家的灵动温情。参观张厅，是理解"依水而居"这一江南水乡生存智慧的最好课堂。 Zhang Hall, originally named "Yuyan Hall," was built during the Zhengtong era of the Ming Dynasty (1436–1449) by descendants of Xu Mengqing, brother of the Prince of Zhongshan, Xu Da. It later passed to the Zhang family, hence its current name. The residence faces west, with six courtyards, over 1,000 square meters of floor area, and more than 70 rooms. Its most distinctive feature is that the Mingjing River — a canal running through the town — flows directly through the courtyard, complete with a private mooring where boats could dock. This spatial arrangement, in which "sedans enter through the front gate and boats pass through the house," is one of the most representative layouts of Jiangnan water-town residences. Inside, nanmu-wood columns and intricately carved window lattices remain well preserved. The rear courtyard contains a miniature water garden with banana palms and bamboo — combining the dignity of an official''s mansion with the warmth and vitality of a riverside home. Visiting Zhang Hall is the best way to understand the centuries-old wisdom of "living by the water."</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_zhouzhuang_ancient_town_sa_05', 'suzhou_zhouzhuang_ancient_town', 'Fu''an Bridge', '富安桥', '<p>Description： 富安桥始建于元至正年间（1341-1368），由沈万三之弟沈万四出资建造，后经多次修缮，是周庄现存历史最悠久的石拱桥之一。桥身横跨南北市河，单孔石拱，全长约17米，桥面呈弧形，以花岗岩石板铺就。富安桥最独特之处在于桥身四角各建有一座桥楼，形成"桥楼合一"的罕见建筑形制——桥上可通行，桥楼内可设店铺、茶肆，既实用又美观，这种将交通与商业功能融为一体的设计，在江南水乡古桥中极为少见。桥楼飞檐高翘，倒映水中，远望如楼阁浮于水面。据传，沈万三发迹前曾在桥畔摆摊，后富甲一方，桥名"富安"寓意富贵平安。登桥远眺，河两岸的临水民居参差错落，乌篷船缓缓穿行桥下，构成一幅经典的水乡风情画。 First built during the Zhizheng era of the Yuan Dynasty (1341–1368), Fu''an Bridge was funded by Shen Wansi, the younger brother of the legendary merchant Shen Wansan. After multiple restorations, it is one of the oldest surviving stone arch bridges in Zhouzhuang. The bridge spans the North-South River in a single arch, about 17 meters long, with a gently arched deck paved in granite slabs. Its most distinctive feature is the four corner buildings — "bridge towers" — that rise from the bridge''s four corners, creating the rare architectural form of "bridge and building as one." The bridge deck remains a thoroughfare, while the towers house shops and teahouses — a design that fuses transportation and commerce, exceedingly rare among Jiangnan water-town bridges. The towers'' upturned eaves reflect in the water; from a distance, they look like pavilions floating on the river. Legend has it that Shen Wansan ran a small stall near the bridge before his fortune was made, and "Fu''an" (literally "wealth and peace") commemorates his rise. Standing on the bridge, one sees the staggered riverside dwellings along both banks, with awning boats gliding slowly beneath the arch — a quintessential water-town tableau.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_zhouzhuang_ancient_town_sa_06', 'suzhou_zhouzhuang_ancient_town', 'Milou', '迷楼', '<p>Description： 迷楼原为镇上一家名为"德记酒楼"的小酒馆，始建于清末民初，是一栋临河的二层小楼。1920年，南社诗人柳亚子、叶楚伧、王大觉等人曾在此饮酒赋诗，叶楚伧后将其诗作结集为《迷楼集》出版，酒楼因此声名远播，后人遂称此楼为"迷楼"。"迷"字既指酒酣迷醉之态，亦暗含对乱世时局的迷惘与感怀。楼内空间不大，木楼梯陡峭狭窄，二楼临河设窗，可眺望河道景致。如今迷楼内陈列有南社诗人的生平介绍与手迹复制品，再现了民国初年江南文人以诗酒寄怀、忧国忧民的精神世界。此处虽非周庄最大景点，却因其深厚的人文底蕴，成为文学爱好者必到之地。 Milou was originally a small riverside tavern called "Deji Wine House," built in the late Qing or early Republican era — a modest two-story building by the water. In 1920, poets of the Southern Society (南社), including Liu Yazi, Ye Chucang, and Wang Dajue, gathered here to drink and compose poetry. Ye Chucang later published his poems from this gathering as the collection "Milou Ji" (Labyrinth Tower Collection), and the tavern became widely known — henceforth called "Milou." The character "迷" (lost/bewitched) conveys both the intoxication of wine and the poets'' bewilderment and lament over the turbulent times. The interior is small, with a steep, narrow wooden staircase; the second floor has windows overlooking the canal. Today, Milou displays reproductions of the Southern Society poets'' biographies and handwritten works, recreating the spiritual world of early Republican-era Jiangnan literati who expressed their patriotism and sorrow through wine and verse. Though not the largest attraction in Zhouzhuang, its literary depth makes it a must-visit for lovers of literature and history.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_zhouzhuang_ancient_town_sa_07', 'suzhou_zhouzhuang_ancient_town', 'Zhouzhuang Museum', '周庄博物馆', '<p>Description： 周庄博物馆位于镇内朱家老宅内，是一座以展示周庄本地历史文化为主题的综合性博物馆。馆舍本身就是一座典型的江南民居建筑，清代格局，粉墙黛瓦，庭院天井俱全。馆内设有多个展厅，分别展示周庄的建镇历史、商业发展、民俗文化、名人轶事等内容。馆藏珍贵文物包括明清时期的契约文书、地契、商号账簿、古钱币、民俗器物等，其中以沈万三相关史料和江南水乡传统生活用具最为丰富。博物馆还通过模型、图片、多媒体等方式，直观呈现了周庄"因水成镇、因商而兴"的发展脉络。参观博物馆是全面了解周庄的最佳起点——先在此构建历史框架，再实地游览各景点，体验将大为不同。 Zhouzhuang Museum is located within the historic Zhu family residence — a comprehensive museum dedicated to the local history and culture of Zhouzhuang. The building itself is a typical Jiangnan residence with a Qing Dynasty layout: whitewashed walls, dark tiles, courtyards, and sky-wells. Multiple exhibition halls cover the town''s founding, commercial development, folk customs, and notable figures. The collection includes precious Ming and Qing-era contracts, land deeds, merchant account books, ancient coins, and folk implements — with the richest materials relating to Shen Wansan and traditional water-town daily life. Models, photographs, and multimedia displays vividly illustrate how Zhouzhuang grew "from water into a town, and from commerce into prosperity." Visiting the museum is the ideal starting point for understanding Zhouzhuang: build a historical framework here first, then explore the town''s sights — and the experience will be transformed.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_zhouzhuang_ancient_town_sa_08', 'suzhou_zhouzhuang_ancient_town', 'Guailou', '怪楼', '<p>Description： 怪楼是周庄古镇内一座以视觉错觉与互动体验为主题的特色景点，楼高三层，外观即与周边传统建筑有所不同，透出几分新奇气息。楼内设有多个主题空间，利用光学、几何、透视原理设计出种种令人称奇的视觉效果——有的房间地板倾斜却墙面平正，令人产生失重错觉；有的利用镜面与灯光营造出无限延伸的空间幻觉；有的以三维立体画让人"置身画中"。每个空间都鼓励游客亲身体验和互动拍照，趣味性极强。怪楼为周庄这一千年古镇注入了一抹现代艺术的亮色，传统与创意在此碰撞，尤其受年轻游客和家庭亲子游客的欢迎，是古镇游览中一个轻松活泼的调剂。 Guailou is a distinctive attraction within Zhouzhuang themed around optical illusions and interactive experiences. Standing three stories tall, its exterior already differs subtly from the surrounding traditional buildings, hinting at the novelty within. Multiple themed rooms inside use principles of optics, geometry, and perspective to create astonishing visual effects: one room has a sloping floor with level walls, producing a sensation of weightlessness; another uses mirrors and lighting to simulate infinite space; yet another employs 3D murals that make visitors feel they have stepped into a painting. Each space encourages hands-on experience and creative photography, making it tremendous fun. Guailou injects a splash of modern artistic vibrancy into this thousand-year-old town, where tradition and creativity collide to delightful effect. It is especially popular with younger visitors and families — a lighthearted counterpoint to the town''s historical sights.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_zhouzhuang_ancient_town_sa_09', 'suzhou_zhouzhuang_ancient_town', 'Zhenfeng Bridge', '贞丰桥', '<p>Description： 贞丰桥是一座横跨中市河的单孔石拱桥，始建年代不详，现存为清代重建。"贞丰"二字取自周庄的古名——周庄原名"贞丰里"，宋代元祐年间（1086年）周迪功郎在此设庄，捐赠田产给全福寺，百姓感念其恩，遂将地名改为"周庄"。贞丰桥之名，正是这一千年更名记忆的活化石。桥身不长，拱形优美，石栏板素朴无华，桥头两端各有数级石阶。桥畔民居临水而筑，垂柳依依，河中偶有摇橹船悠然经过，橹声欸乃，与石桥古韵相得益彰。此处游人较少，比双桥和富安桥更为幽静，是静坐桥上、感受水乡慢时光的绝佳去处。桥畔旧有茶肆，传说南社文人亦曾在此吟诗论事，为贞丰桥增添了几分文人雅韵。 Zhenfeng Bridge is a single-arch stone bridge spanning the Zhongshi River. Its date of original construction is unknown; the current structure dates from a Qing Dynasty rebuilding. "Zhenfeng" derives from Zhouzhuang''s ancient name — "Zhenfeng Li." During the Yuanyou era of the Song Dynasty (1086), a local official named Zhou Digonglang established a manor here and donated farmland to Quanfu Temple. The grateful residents renamed the place "Zhouzhuang" in his honor. The name "Zhenfeng Bridge" is a living fossil of this thousand-year-old renaming. The bridge is modest in length, with an elegant arch, plain stone railings, and stone steps at both ends. Riverside houses rise directly from the water; willows dip their branches toward the river; an occasional sculling boat drifts past with a rhythmic creak of the oar, complementing the ancient bridge''s quiet charm. Fewer tourists gather here than at the Twin Bridges or Fu''an Bridge, making Zhenfeng Bridge a serene spot to sit, slow down, and savor the unhurried rhythms of water-town life. A teahouse once stood by the bridge, and it is said that Southern Society poets gathered here to compose verse, adding a literary luster to its stones.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_zhouzhuang_ancient_town_sa_10', 'suzhou_zhouzhuang_ancient_town', 'Quanfu Temple', '全福讲寺', '<p>Description： 全福讲寺位于周庄古镇南侧白蚬湖畔，始建于宋代元祐年间（1086年），由周迪功郎捐地所建，是周庄历史最悠久的佛教寺院。寺庙依湖而建，主要殿堂临水而立，远远望去，殿宇楼阁仿佛浮于水面之上，故有"水中佛国"之美称。寺院坐北朝南，中轴线上依次为山门、大雄宝殿、藏经楼等，建筑恢弘庄严，黄墙黛瓦，飞檐重叠，在碧水蓝天的映衬下格外壮丽。寺内原有宋代铜钟，声传数里，"全福晓钟"为旧时周庄八景之一。寺院历经兴废，现存建筑为近代重建，但仍保留了传统佛寺的格局与气度。每逢清晨，寺内钟声悠扬，穿过湖面薄雾传向四方，水光与梵音交融，令人心生宁静。登临藏经楼远眺，白蚬湖烟波浩渺，周庄水乡风貌尽收眼底，是镇内难得的登高揽胜之所。 Quanfu Temple stands on the shore of Lake Bianxian, south of Zhouzhuang Old Town. Founded in 1086 during the Song Dynasty''s Yuanyou era — built on land donated by Zhou Digonglang — it is the oldest Buddhist temple in Zhouzhuang. The temple rises directly from the lake, with its main halls standing at the water''s edge. From a distance, the halls and pavilions appear to float upon the water, earning it the name "Buddhist Kingdom on Water" (水中佛国). The complex faces south, with a gate, main hall, and scripture repository along its central axis. The architecture is grand and solemn — golden walls, dark tiles, layered flying eaves — striking against the blue water and sky. The temple once housed a Song Dynasty bronze bell whose peal carried for miles; "Quanfu Dawn Bell" was one of the historic Eight Scenes of Zhouzhuang. Destroyed and rebuilt multiple times, the current structures are modern reconstructions that nonetheless preserve the layout and dignity of a traditional Buddhist monastery. At dawn, the temple bell rings across the misty lake, its sound blending with the water''s shimmer to instill a deep tranquility. From the upper floors of the scripture repository, one looks out over the vast expanse of Lake Bianxian, with Zhouzhuang''s water-town panorama spread below — one of the few elevated vantage points in the town.</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_pingjiang_road_sa_01', 'suzhou_pingjiang_road', 'Xiangmen Entrance', '相门入口', '<p>Description： 相门，又称匠门，是苏州古城八大城门之一，相传因吴王阖闾曾命工匠于此造剑而得名。如今修复后的相门城墙巍然矗立于平江路南端，成为游客步入这片千年历史街区的重要门户。城墙遗址公园绿荫环绕，登城远眺可将古城水巷风貌尽收眼底。这里既是平江路漫步之旅的起点，也是感受苏州城池格局与城门文化的重要地标。 Xiangmen, also known as Jiangmen (Craftsman''s Gate), is one of the eight ancient gates of Suzhou, named after the legend that King Helu of Wu ordered swordsmiths to work here. The restored city wall now stands majestically at the southern end of Pingjiang Road, serving as the primary gateway for visitors entering this thousand-year-old historic block. The surrounding city wall heritage park is shaded by lush greenery, and climbing the wall offers panoramic views of the ancient city''s canal-and-alley landscape. It serves both as the starting point of a Pingjiang Road stroll and as a significant landmark for appreciating Suzhou''s city layout and gate culture.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_pingjiang_road_sa_02', 'suzhou_pingjiang_road', 'Yuan Bridge', '苑桥', '<p>Description： 苑桥横跨平江河，是一座具有典型江南水乡风格的石拱桥。桥名源于其附近曾有的皇家苑圃或私家园林，虽旧时苑圃已不可寻，但桥身古朴典雅的形态仍让人遥想当年繁盛景致。驻足桥上，东望粉墙黛瓦的民居沿河排列，西眺石板路蜿蜒延伸，水中倒影与岸上人家相映成趣。苑桥不仅是平江路水陆并行格局的重要节点，更是摄影师与游人捕捉"小桥流水人家"经典意象的理想取景地。 Yuan Bridge spans the Pingjiang River as a classic stone arch bridge embodying the Jiangnan water-town aesthetic. Its name derives from the royal or private gardens that once graced its vicinity; though those gardens have faded into history, the bridge''s elegant form still evokes the prosperity of bygone eras. Standing on the bridge, one gazes east at whitewashed residences lining the canal and west at the winding flagstone path, where reflections and dwellings create a charming interplay. Yuan Bridge is not only a key node in Pingjiang Road''s dual water-and-land layout but also an ideal spot for photographers and visitors to capture the iconic imagery of "small bridge, flowing water, and humble home."</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_pingjiang_road_sa_03', 'suzhou_pingjiang_road', 'Sipo Bridge', '思婆桥', '<p>Description： 思婆桥是平江路上年代最为久远的古桥之一，相传因一位善良老妇常在此施茶济困而得名"思婆"，亦有说法称"思婆"为"师婆"之讹，与旧时女巫或尼姑有关。无论名称来源如何，这座单孔石拱桥已历经数百年风雨，桥面石板被脚步打磨出温润光泽，桥栏低矮朴素，与两岸低层民居的尺度浑然一体。清晨薄雾中或黄昏灯影下，思婆桥勾勒出一幅淡墨水巷画卷，是理解苏州"桥即生活"这一市井哲学的最佳窗口之一。 Sipo Bridge is among the oldest bridges on Pingjiang Road. Legend attributes its name—"Sipo" meaning "remembering the granny"—to a kind old woman who offered tea and alms here; another theory links it to "Shipo" (female shaman or nun). Regardless of origin, this single-arch stone bridge has endured centuries of weather, its flagstones polished to a warm sheen by countless footsteps, its low rail blending seamlessly with the modest riverside dwellings. In morning mist or evening lamplight, Sipo Bridge paints a faint ink-wash canal scene, serving as one of the finest windows into Suzhou''s neighborhood philosophy that "bridges are life itself."</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_pingjiang_road_sa_04', 'suzhou_pingjiang_road', 'Dingxiang Lane (Lilac Lane)', '丁香巷', '<p>Description： 丁香巷是平江路东侧一条窄而幽深的支巷，因旧时巷内遍植丁香树而得名，春末夏初花开时节，紫色花瓣随风飘落石板路，巷弄弥漫淡淡芬芳。这里也是苏州近代名人顾颉刚的故居所在，学术文脉与花巷诗意交织。巷内老宅门扉半掩，偶有猫影闪过，晾晒的衣物与门楣上的雕花并存，呈现出真实而生动的市井图景。丁香巷以它的安静与芬芳，成为平江路繁华主街之外最令人动容的文学角落，吸引无数写作者与漫步者在此驻足寻梦。 Dingxiang Lane is a narrow, deeply secluded branch lane east of Pingjiang Road, named after the lilac trees that once filled it. In late spring and early summer, purple petals drift onto flagstones, perfuming the alley with a subtle fragrance. It also houses the former residence of the modern scholar Gu Jiegang, intertwining academic heritage with floral poetry. Old doorways stand half-open, cats dart past, and drying clothes coexist with carved lintels in a vivid neighborhood tableau. With its quietude and scent, Dingxiang Lane becomes the most moving literary corner beyond the bustling main street, drawing writers and wanderers who linger here in search of inspiration.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_pingjiang_road_sa_05', 'suzhou_pingjiang_road', 'Zhongzhangjia Lane (Pingtan Museum)', '中张家巷（评弹博物馆）', '<p>Description： 中张家巷是平江路上一条与评弹文化深度绑定的巷弄，巷内的苏州评弹博物馆是国内唯一以苏州评弹为主题的专题博物馆。馆内陈列了大量评弹历史文献、手稿、唱片与演出道具，系统呈现了评弹自清代至今的发展脉络。最令人期待的是馆内定期安排的现场演出，游客可于传统书场中坐下，品一杯碧螺春，听一段正宗弹词开篇，感受吴侬软语的说唱韵律与弦索叮咚的伴奏之美。这里是理解苏州"声音文化"不可绕过的殿堂，也是平江路最具活态传承意义的景点。 Zhongzhangjia Lane is intimately tied to Pingtan culture. The Suzhou Pingtan Museum housed here is China''s only museum dedicated to Suzhou Pingtan (storytelling and musical performance). Its collections include extensive historical documents, manuscripts, records, and stage props tracing Pingtan''s evolution from the Qing dynasty to today. The highlight is the regular live performances: visitors can sit in a traditional storytelling house, sip Biluochun tea, and hear authentic Pingtan openings, experiencing the rhythmic cadence of Wu dialect singing and the delicate accompaniment of stringed instruments. This is an essential殿堂 for understanding Suzhou''s "sound culture" and Pingjiang Road''s most vibrant site of living heritage.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_pingjiang_road_sa_06', 'suzhou_pingjiang_road', 'Niujia Lane (Zhuangyuan Museum)', '钮家巷（状元博物馆）', '<p>Description： 钮家巷内的苏州状元博物馆，设在清代状元潘世恩的故居——凤池园之中。苏州自宋代以来共出状元五十余人，居全国之冠，素有"状元之乡"美誉。博物馆以潘世恩的生平为切入点，通过科举试卷、匾额、服饰与生活器物，全面展示古代状元从寒窗苦读到金榜题名的历程，以及状元家族对苏州文教传统的深远影响。故居本身亦是一座精致的苏州宅院，厅堂轩朗、花木扶疏，参观博物馆的同时也能领略江南士大夫宅第的格局美学。这里是一处将学术精神与建筑之美完美融合的文化殿堂。 The Suzhou Zhuangyuan Museum on Niujia Lane is set within Fengchi Garden, the former residence of Qing dynasty Zhuangyuan Pan Shi''en. Suzhou has produced over fifty Zhuangyuan since the Song dynasty—more than any other city in China—earning the title "Home of Zhuangyuan." Using Pan Shi''en''s life as an entry point, the museum displays exam papers, honor plaques, robes, and daily artifacts, comprehensively illustrating the journey from arduous study to imperial triumph and the profound influence of Zhuangyuan families on Suzhou''s educational traditions. The residence itself is an elegant Suzhou mansion with spacious halls and graceful landscaping, allowing visitors to appreciate the layout aesthetics of Jiangnan scholar-official dwellings alongside the exhibits. It is a cultural hall where scholarly spirit and architectural beauty merge seamlessly.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_pingjiang_road_sa_07', 'suzhou_pingjiang_road', 'Daru Lane', '大儒巷', '<p>Description： 大儒巷因明代著名学者王仁而得名，"大儒"二字本身就是苏州崇文重教传统的浓缩符号。巷内至今保留了多处明清时期的民居与名人故居遗址，青砖门楼与木格窗棂透露出往昔书香气。与此同时，大儒巷也是平江路上手工艺业态最为集中的支巷之一，苏绣工作室、核雕坊、木作铺等匠人空间点缀其间，文人风骨与匠人精神在此并行不悖。巷弄尺度亲切，行人稀疏，适合慢走细看，在门扉与窗框之间读懂苏州"文与工"共生的人文生态。 Daru Lane takes its name from the renowned Ming dynasty scholar Wang Ren—"Daru" (Great Scholar) itself distills Suzhou''s reverence for learning. Several Ming and Qing residences and scholar sites still survive here, their blue-brick gateways and lattice windows hinting at a bygone literary aura. Meanwhile, Daru Lane is also one of Pingjiang Road''s most concentrated artisan branches, dotted with Su embroidery studios, nut-carving workshops, and woodwork shops, where literati ethos and craftsman spirit run parallel. The lane''s intimate scale and sparse foot traffic invite unhurried exploration, allowing visitors to read between doorways and window frames the symbiotic humanistic ecology of Suzhou''s "letters and crafts."</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_pingjiang_road_sa_08', 'suzhou_pingjiang_road', 'Xuanqiao Lane (Hong Jun''s Former Residence & Boat House)', '悬桥巷（洪钧故居、船屋）', '<p>Description： 悬桥巷因巷口旧有悬桥而得名，是平江路上最具传奇色彩的支巷。巷内27号为清末状元洪钧的故居，洪钧曾出使欧洲诸国，归国后携名妓赛金花寓居于此，二人的故事至今为人津津乐道。故居最独特的建筑是一座"船屋"——整栋房屋仿船形建造，两舱分列，舷窗式木格窗排列有序，恍若泊于巷内的旱船，堪称苏州民居建筑中最富创意的孤例。悬桥巷本身幽深安静，旧宅檐角与藤蔓交织，漫步其间仿佛走进一段被时光折叠的晚清风云。 Xuanqiao Lane, named after a suspension bridge that once stood at its entrance, is Pingjiang Road''s most legendary branch. No. 27 is the former residence of late-Qing Zhuangyuan Hong Jun, who served as envoy to several European nations and later lived here with the famous courtesan Sa Jinhua—a story still avidly recounted. The residence''s most distinctive feature is a "boat house"—an entire building constructed in the shape of a boat, with two cabins and orderly hull-style lattice windows, resembling a dry-docked vessel in the lane, standing as Suzhou''s most creative singular example of residential architecture. The lane itself is deep and tranquil, old eaves intertwining with creeping vines; a stroll here feels like walking into a fold of late-Qing turbulence compressed by time.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_pingjiang_road_sa_09', 'suzhou_pingjiang_road', 'Qingshi Bridge (Bluestone Bridge)', '青石桥', '<p>Description： 青石桥因桥身以青色石料砌筑而得名，是平江河上形态简朴而意蕴悠长的古桥之一。桥畔是平江路上最具烟火气的段落，几家临河茶馆撑出木制凉棚，桌椅半探水面，茶客品茗闲话之间，乌篷船从桥下缓缓穿过，构成一幅活的水乡市井图。青石桥也是平江路夜景最迷人的区域之一，入夜后河面灯影浮动，茶馆暖光映水，古桥轮廓在明灭之间若隐若现。推荐在此停留半小时以上，坐进桥边茶馆，用一杯苏州碧螺春的时间，真正读懂平江路"慢即是美"的生活哲学。 Qingshi Bridge, named for its bluestone construction, is one of Pingjiang River''s most understated yet evocative ancient bridges. The bridge vicinity is Pingjiang Road''s most lived-in stretch, where several canal-side teahouses extend wooden awnings with tables half-reaching over the water. As patrons sip tea and chat, awning boats glide slowly beneath the bridge, composing a living water-town tableau. Qingshi Bridge is also among the most enchanting night scenes on Pingjiang Road: after dark, lantern reflections float on the canal, teahouse warm light mirrors on the water, and the ancient bridge silhouette flickers between brightness and shadow. We recommend lingering at least half an hour—sit in a bridge-side teahouse and, over a cup of Suzhou Biluochun tea, truly read Pingjiang Road''s philosophy that "slowness is beauty."</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_pingjiang_road_sa_10', 'suzhou_pingjiang_road', 'Quanjin Guild Hall - Suzhou Chinese Opera Museum', '全晋会馆 - 苏州戏曲博物馆', '<p>Description： 全晋会馆是平江路上最具建筑震撼力的地标，由清代在苏经商的山西商人于乾隆年间集资兴建，用于同乡联谊与商务议事。会馆最引人瞩目的是其戏楼，戏台上方穹顶藻井以数百块木雕构件层层叠砌而成，形如倒置穹隆，红漆金描，气势恢宏，是江南地区现存最为精美的古戏楼藻井之一。如今全晋会馆已改为苏州戏曲博物馆，馆内陈列昆曲、京剧、苏剧等多种戏曲的文物与影像资料，并定期举办昆曲展演。这座建筑既是晋商在苏州的历史印记，也是中国传统戏曲艺术的立体教科书。 Quanjin Guild Hall is Pingjiang Road''s most architecturally stunning landmark. Built with funds raised by Shanxi merchants doing business in Suzhou during the Qianlong era, it served for fellow-provincial gatherings and business deliberations. The hall''s most striking feature is its theater building: above the stage, a caisson ceiling composed of hundreds of carved wooden components stacked into an inverted dome, painted red and gold, stands as one of the finest surviving ancient theater caissons in the Jiangnan region. Today the guild hall has been transformed into the Suzhou Chinese Opera Museum, displaying artifacts and visual materials of Kunqu, Peking Opera, Su Opera, and other genres, with regular Kunqu performances. This building is both a historical imprint of Shanxi merchants in Suzhou and a three-dimensional textbook of Chinese traditional opera art.</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_humble_administrators_garden_sa_01', 'suzhou_humble_administrators_garden', 'Lanxue Hall (Hall of Orchid and Snow)', '兰雪堂', '<p>Description： 兰雪堂是拙政园正门入口的主厅堂，面阔三间，为三开间硬山顶建筑。堂名取自李白诗句"独立天地间，清风洒兰雪"，寓意园主志趣高远、洁身自好。堂前设有大型漆雕《拙政园全景图》，生动展现全园山水格局。堂内布置简雅，中堂悬挂松竹图，两侧楹联书"此地有崇山峻岭茂林修竹，是能读三坟五典八索九丘"，将园林与读书之乐融为一体，奠定了全园文人园林的基调。 / Lanxue Hall is the main entrance hall of the Humble Administrator''s Garden, a three-bay structure with a rigid gable roof. Its name comes from Li Bai''s verse "Standing alone between heaven and earth, a fresh breeze scatters orchids and snow," reflecting the garden owner''s lofty aspirations and integrity. In front of the hall stands a large lacquer carving of the full garden panorama. Inside, the decor is restrained and refined, with a painting of pines and bamboo hanging in the central hall and a couplet extolling both natural beauty and scholarly pursuits — setting the tone for the entire literati garden.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_humble_administrators_garden_sa_02', 'suzhou_humble_administrators_garden', 'Yuanxiang Hall (Hall of Distant Fragrance)', '远香堂', '<p>Description： 远香堂是拙政园中部的核心建筑，面阔三间，建于青石台基之上。堂名取意周敦颐《爱莲说》中"香远益清"之句，暗含园主以莲花自喻高洁品格之意。建筑四面均为透空落地长窗，无墙体阻隔，人在堂中即可环顾四周景物——北望雪香云蔚亭和待霜亭，南观黄石假山和广玉兰，西看荷风四面亭，东赏绣绮亭，将园中风光尽收眼底，是中国古典园林"框景"和"借景"手法的典范之作。 / Yuanxiang Hall is the architectural centerpiece of the garden''s middle section, a three-bay hall raised on a bluestone platform. Its name draws from Zhou Dunyi''s famous essay "On Loving the Lotus" — "the farther the fragrance travels, the purer it becomes" — subtly expressing the owner''s self-identification with the lotus''s noble character. With floor-to-ceiling latticed windows on all four sides and no solid walls, the hall offers uninterrupted views in every direction: northward to the Snow-Fragrant Cloud-Like Pavilion, southward to the yellowstone rockery and magnolia, westward to the Lotus Breeze Pavilion, and eastward to the Embroidered Silk Pavilion. It is a masterclass in the Chinese garden techniques of "framed views" and "borrowed scenery."</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_humble_administrators_garden_sa_03', 'suzhou_humble_administrators_garden', 'Xiangzhou (Fragrant Isle)', '香洲', '<p>Description： 香洲是拙政园中最具特色的建筑之一，整个建筑由亭、台、楼、阁四种形式组合而成，前舱为石砌平台如船头，中舱为廊道如船舱，后舱为楼阁如船尾，整体造型宛如一艘华丽画舫停泊于水边。香洲之名寓意芳草萋萋的水中小洲。船头悬有文徵明所书"香洲"匾额，船楼二层名"澄观楼"，登楼远眺，园中水光潋滟尽收眼底。此处是拙政园"旱船"建筑的代表作，将水乡意象与园林建筑完美结合。 / Xiangzhou is one of the garden''s most distinctive structures, ingeniously combining four architectural forms into a single composition: a stone-paved platform at the bow, a covered corridor as the cabin, and a two-story tower at the stern — creating the illusion of an ornate pleasure boat moored by the water. The name "Fragrant Isle" evokes a lush, grassy islet. A plaque inscribed by the Ming master Wen Zhengming hangs at the bow, while the upper level, named "Chengguan Tower" (Tower of Clear Contemplation), offers sweeping views across shimmering garden waters. This is a quintessential example of the "dry boat" motif in classical Chinese gardens, brilliantly merging water-town imagery with garden architecture.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_humble_administrators_garden_sa_04', 'suzhou_humble_administrators_garden', 'Hefeng Simian Pavilion (Lotus Breeze from All Sides Pavilion)', '荷风四面亭', '<p>Description： 荷风四面亭是一座玲珑精致的六角攒尖亭，建于园中部水池中央的石矶之上，通过曲桥与两岸相连。亭名取自唐代诗人孟浩然名句"荷风送香气"，点明了此亭的意境所在。盛夏时节，亭周满池荷花盛开，清风徐来，荷香弥漫四面，亭中人如在画中。亭柱上的楹联"四面荷花三面柳，半潭秋水一房山"，精妙地概括了此处四时风光之变。此亭不仅是赏荷佳处，更是拙政园水景构图的点睛之笔，巧妙连接了远香堂、香洲、见山楼等景观节点。 / Hefeng Simian Pavilion is a delicate hexagonal pavilion with a pointed roof, built on a rocky islet at the center of the garden''s main pond and connected to both shores by winding bridges. Its name, borrowed from Tang poet Meng Haoran''s line "the lotus breeze bears its fragrance," perfectly captures its poetic essence. In midsummer, when lotus blooms carpet the surrounding water and a gentle breeze carries their scent from all four sides, one feels as though standing inside a painting. The couplet on its pillars — "Lotus blossoms on four sides, willows on three; half a pool of autumn water, a mountain in one room" — elegantly evokes the changing seasons. Beyond being an exquisite lotus-viewing perch, this pavilion is the compositional linchpin of the garden''s waterscape, skillfully linking Yuanxiang Hall, Xiangzhou, and Jianshan Tower.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_humble_administrators_garden_sa_05', 'suzhou_humble_administrators_garden', 'Xiaofeihong (Little Flying Rainbow)', '小飞虹', '<p>Description： 小飞虹是拙政园中一处极具诗意的廊桥建筑，也是苏州古典园林中仅存的一座廊桥。桥身三跨，朱红栏杆，上有廊顶覆盖，桥下碧水穿流。桥名取自南北朝诗人鲍照诗句"飞虹眺秦河"，以彩虹比喻桥的轻盈优美。一端连接倚玉轩，另一端通向得真亭，两侧临水，廊影映水，虚实相生。从远香堂南望，小飞虹如一弯朱虹横架水上，与背后的亭台、假山、花木构成一幅层次丰富的立体画卷，是"借景"与"分景"手法的绝佳体现。 / Xiaofeihong is a supremely poetic covered bridge and the only surviving example of its kind among Suzhou''s classical gardens. The three-span bridge features vermilion balustrades beneath a full-length roof, with green water flowing gently beneath. Its name, drawn from Bao Zhao''s verse "a flying rainbow gazes upon the Qin River," likens the bridge''s graceful arc to a rainbow. Connecting Yiyu Pavilion on one end to Dezhi Pavilion on the other, the bridge casts its reflection onto the water, blurring the line between reality and illusion. Viewed from Yuanxiang Hall, Xiaofeihong appears as a crimson arc suspended above the water, forming a richly layered composition with the pavilions, rockeries, and foliage beyond — a brilliant demonstration of "borrowed" and "divided" scenic techniques.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_humble_administrators_garden_sa_06', 'suzhou_humble_administrators_garden', 'Jianshan Tower (Tower of Seeing the Mountain)', '见山楼', '<p>Description： 见山楼是拙政园中最为高耸的建筑，为两层重檐歇山顶楼阁，矗立于园北部水域北岸。楼名取自陶渊明"采菊东篱下，悠然见南山"的诗意，寄托了园主寄情山水、超然物外的人生理想。底层为四面通透的凉厅，可凭栏观鱼赏荷；上层为书房，推窗远眺，苏州古城标志性建筑北寺塔赫然映入眼帘，实现了中国园林"借景"手法的最高境界——将园外的城市地标纳入园内景观，极大地拓展了空间的纵深感。楼前设平台临水，是观赏园中全景和拍照的最佳位置之一。 / Jianshan Tower is the tallest structure in the garden, a two-story double-eaved building with a hip-and-gable roof standing on the northern shore of the garden''s main pond. Its name echoes Tao Yuanming''s famous lines "Picking chrysanthemums by the eastern hedge, I gaze in leisure upon the southern mountain," expressing the owner''s longing for a life of reclusion amid nature. The open-sided ground floor serves as a cool hall for watching fish and lotus, while the upper study commands a view that frames Suzhou''s iconic North Temple Pagoda — the supreme achievement of the Chinese garden technique of "borrowed scenery," pulling a city landmark into the garden''s visual field and vastly expanding its perceived depth. The waterfront terrace in front is one of the best spots for panoramic photography.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_humble_administrators_garden_sa_07', 'suzhou_humble_administrators_garden', 'Sanshiliu Yuanyang Guan (Thirty-Six Mandarin Duck Hall)', '卅六鸳鸯馆', '<p>Description： 卅六鸳鸯馆是拙政园西部的主体建筑，原名"卅六鸳鸯馆"，因馆前池中曾蓄养三十六对鸳鸯而得名。建筑为鸳鸯厅形式——南北两厅以屏风隔断，南厅宜冬（日照充足），北厅宜夏（临水通风），充分体现了传统建筑的智慧。最大的特色是四面的彩色玻璃花窗，蓝白相间的菱形格纹窗在阳光下折射出梦幻光影，这在中国古典园林中极为罕见，是清末西风东渐的珍贵印记。当年园主张履谦常在此款待宾客、欣赏昆曲，厅内精致的木雕和匾额对联处处透露着文人雅趣。 / Sanshiliu Yuanyang Guan is the principal building of the garden''s western section, originally named for the thirty-six pairs of mandarin ducks that once graced the pond before it. The hall follows the "mandarin duck hall" layout — two halls separated by a screen partition: the southern hall is warm in winter with abundant sunlight, while the northern hall stays cool in summer with cross-ventilation from the water, a brilliant demonstration of traditional architectural wisdom. Its most striking feature is the stained-glass lattice windows on all four sides — blue-and-white diamond-patterned panes that refract dreamlike light and shadow, a rarity in classical Chinese gardens and a precious trace of Western influence during the late Qing period. The owner Zhang Luqian once entertained guests and enjoyed Kunqu opera here, and the hall''s exquisite wood carvings, plaques, and couplets still whisper of literati refinement.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_humble_administrators_garden_sa_08', 'suzhou_humble_administrators_garden', 'Yushei Tongzuo Pavilion (With Whom Shall I Sit Pavilion)', '与谁同坐轩', '<p>Description： 与谁同坐轩是拙政园中最别出心裁的建筑设计之一，整座亭子平面呈扇形——亭顶、墙面、门窗、石桌、石凳乃至悬挂的匾额均为扇形，精巧绝伦。亭名出自苏轼名句"与谁同坐？明月清风我"，以反问的形式传达了一种超然物外、独与天地精神往来的孤高境界。此亭位于西园水池东南角，三面临水，视野开阔，背倚长廊，面朝卅六鸳鸯馆，是品味园主精神世界的绝佳窗口。小小的扇面空间，却容纳了无限的诗意和哲思，堪称中国古典园林"以小见大"美学思想的一个缩影。 / Yushei Tongzuo Pavilion is one of the garden''s most inventive architectural designs: the pavilion is fan-shaped in plan — its roof, walls, doors, windows, stone table, stone stools, and even the hanging plaque are all in the form of a fan, an exquisite conceit. Its name comes from Su Shi''s celebrated verse "With whom shall I sit? The bright moon, the fresh breeze, and me" — a rhetorical question that conveys a transcendent detachment, a communion with the universe in splendid solitude. Perched at the southeastern corner of the western pond, with water on three sides and a covered corridor at its back, it faces Sanshiliu Yuanyang Guan across the water. This tiny fan-shaped space holds infinite poetry and philosophy, a perfect distillation of the classical Chinese garden aesthetic of "seeing the great in the small."</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_humble_administrators_garden_sa_09', 'suzhou_humble_administrators_garden', 'Liuting Ge (Pavilion for Lingering and Listening)', '留听阁', '<p>Description： 留听阁是拙政园西部一座小巧雅致的临水楼阁，单层歇山顶，三面环水，环境清幽。阁名出自晚唐诗人李商隐《宿骆氏亭寄怀崔雍崔衮》中"留得枯荷听雨声"一句，意境深远而略带感伤。秋日里，当满池荷花凋谢、只余枯叶残梗，细雨落在枯荷上发出簌簌之声，那是一种不完美的、寂静的美——正是中国传统美学中"残缺之美"的最高体现。从阁中凭栏而望，池水澄明，远处塔影隐约，近处残荷低语，使人顿生时光悠悠、物我两忘之感。留听阁不仅是一处观景点，更是一种心境。 / Liuting Ge is a small, elegantly understated waterside pavilion in the garden''s western section — a single-story structure with a hip-and-gable roof, surrounded by water on three sides in serene seclusion. Its name is taken from the late Tang poet Li Shangyin''s haunting line "Leave the withered lotus to listen to the sound of rain," a verse suffused with melancholy and depth. In autumn, when the lotus blooms have faded and only withered stalks remain, the patter of rain on dry lotus leaves creates a rustling, intimate music — a celebration of imperfect, quiet beauty that represents the highest expression of the traditional Chinese aesthetic of wabi-like poignancy. Leaning on the railing, one gazes upon clear pond waters, a distant pagoda silhouette, and nearby withered lotus whispering in the rain — a moment of transcendence where time dissolves and the self merges with the scene. Liuting Ge is not merely a viewpoint; it is a state of mind.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_canglang_pavilion_sa_01', 'suzhou_canglang_pavilion', 'Mianshui Pavilion', '面水轩', '<p>Description： 面水轩位于沧浪亭园门入口处北侧，是入园后第一处景观建筑。轩北临水，面阔三间，前有石台探入水面，是观赏园外葑溪水面与远处借景的最佳位置。轩名"面水"，恰如其分地道出其临水而筑的空间特征。建筑采用歇山卷棚顶，檐口低矮，与水面关系极为亲近。游人至此，尚未深入园内，便已感受到沧浪亭"未入园先得景、以水环园"的总体布局精妙之处，堪称全园序曲。</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_canglang_pavilion_sa_02', 'suzhou_canglang_pavilion', 'Guanyu Spot', '观鱼处', '<p>Description： 观鱼处位于面水轩东侧，是一处临水石台与小型观景空间。此处水面开阔，游鱼往来穿梭，意境源自《庄子·秋水》中濠梁观鱼的典故，寄寓园林主人超然物外的哲学追求。石台以湖石叠砌，高低错落，水边植有垂柳与菖蒲，倒影入水，景致清幽。游人立于台上俯观水中锦鲤悠游，可体会宋代文人对"鱼之乐"的精神共鸣，是沧浪亭中最富哲学意趣的观景点之一。</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_canglang_pavilion_sa_03', 'suzhou_canglang_pavilion', 'Canglang Pavilion (Main Pavilion)', '沧浪亭（主体亭）', '<p>Description： 沧浪亭为全园主景，位于园中部土石假山之巅，是苏州园林中罕见的"以山为园、环以水"布局的集中体现。亭为方形，四角攒尖顶，飞檐翘角，古朴典雅。亭柱镌刻名联"清风明月本无价，近水远山皆有情"，为晚清学者俞樾所书。亭名取自《楚辞》中"沧浪之水清兮，可以濯我缨"之句，寓意园林主人归隐山林、洁身自好的高洁志趣。立于亭中，南望园内假山古木，北眺园外一池碧水，"内外合一、借景入园"的设计理念在此达到高潮。</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_canglang_pavilion_sa_04', 'suzhou_canglang_pavilion', 'Mingdao Hall', '明道堂', '<p>Description： 明道堂位于沧浪亭南侧，是园内体量最大的厅堂建筑，面阔三间，进深较深，前有宽阔月台。堂名"明道"取"明先圣之道"之意，为宋代苏舜钦筑园时已有此名，后历经重建。厅堂内部梁架结构裸露，用材粗大，不施彩绘，呈现宋式建筑质朴的遗风。堂前庭院宽敞，植有古玉兰与翠竹，清雅宜人。此处原为园主与文人雅士会聚讲学、吟诗论道之所，充分体现了沧浪亭作为宋代文人园林的精神内核，至今仍可感受到读书讲学的肃穆氛围。</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_canglang_pavilion_sa_05', 'suzhou_canglang_pavilion', 'Kanshan Tower', '看山楼', '<p>Description： 看山楼位于沧浪亭园内南端假山高处的石台之上，为二层歇山式楼阁建筑，是全园地势最高点。楼名"看山"，因其登临可远眺苏州西南方向的天平、灵岩、狮子诸山。此楼充分利用了苏州园林"远借"的造景手法，将园外自然山景借入园内视觉范围，使有限的园内空间产生无限延伸之感。楼体外观两层，下层以黄石叠筑为基座，上层木构，翼角舒展。登楼凭窗，近观园内翠竹芭蕉，远望群山如黛，正是"悠然见南山"的园林意境，体现了宋代文人的山水观照精神。</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_canglang_pavilion_sa_06', 'suzhou_canglang_pavilion', 'Cui Linglong', '翠玲珑', '<p>Description： 翠玲珑位于看山楼西侧，是一间隐于修竹丛中的小型书斋建筑。建筑面阔仅一间半，体量精巧，三面环竹，绿荫如盖，日光透过竹叶洒落地面，光影斑驳，意境幽远。名"翠玲珑"极富诗意，"翠"指周围翠竹，"玲珑"形容其精致通透。此斋为苏舜钦当年的读书之所，他在《沧浪亭记》中描绘了在竹林中读书忘忧的生活场景。斋前小径曲折，以湖石点缀，竹影石姿交相辉映。此处远离主游览线，环境格外静谧，是体味宋代文人隐逸生活的绝佳之处，体现了沧浪亭以小见大、以幽衬雅的造园手法。</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_canglang_pavilion_sa_07', 'suzhou_canglang_pavilion', 'Five Hundred Sages Shrine', '五百名贤祠', '<p>Description： 五百名贤祠位于沧浪亭园内西北部，始建于清道光七年（1827年），由当时江苏巡抚陶澍主持建造。祠内壁间嵌有五百九十四位苏州历代名贤的半身石刻像，从春秋季札到清代林则徐等，跨越两千余年，涵盖政治、文学、艺术、科学等领域。每幅画像旁刻有姓名与简要介绍，刀法简洁传神。此祠不仅是一座纪念性建筑，更是一部石刻的苏州人文史，集中展现了苏州"人杰地灵、人文荟萃"的深厚文化底蕴。祠堂建筑朴素庄重，青砖灰瓦，与名贤画像的肃穆气质相得益彰，是沧浪亭中最具人文历史厚度的景点。</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_canglang_pavilion_sa_08', 'suzhou_canglang_pavilion', 'Imperial Stele Pavilion', '御碑亭', '<p>Description： 御碑亭位于沧浪亭园内中部偏西处，是一座专为保护清代康熙皇帝御笔碑刻而建的小型亭式建筑。亭内立有康熙帝南巡时赐予沧浪亭的御碑，碑文为康熙亲题，内容褒扬沧浪亭景致与苏舜钦之贤。碑身以青石琢制，碑首雕蟠龙纹饰，碑座为赑屃形制，具有典型的清代皇家碑刻形制特征。亭为四方形，攒尖顶，四角立石柱，通透开敞，便于四面观碑。此亭不仅具有重要的历史文物价值，也体现了沧浪亭自宋至清一直受到历代统治者与文人的重视，是苏州园林中少见的皇家赐碑实物遗存。</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_canglang_pavilion_sa_09', 'suzhou_canglang_pavilion', 'Ouhua Water Pavilion', '藕花水榭', '<p>Description： 藕花水榭位于沧浪亭园内北部临水区域，是一座半架于水面之上的古典水榭建筑。建筑面水而筑，下部以石柱支撑探出水面，上部为木构歇山顶，四面通透，可凭栏环赏水景。榭名"藕花"即指荷花，此处在历史上植有大片荷花，盛夏时节"接天莲叶无穷碧，映日荷花别样红"的景致尤为动人。水榭不仅是赏荷佳处，也是观赏园外水面与借景北岸风光的最佳位置之一。榭前水面上残荷枯叶在秋冬亦有一番萧瑟之美，体现了苏州园林"四时皆景"的审美追求，是游客休憩观景的必到之处。</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lion_grove_garden_sa_01', 'suzhou_lion_grove_garden', 'Yanyu Hall', '燕誉堂', '<p>Description： 燕誉堂是狮子林的正厅，也是游客步入园林后首先映入眼帘的核心建筑。"燕誉"二字出自《诗经·小雅·南有嘉鱼》中"南有嘉鱼，烝然罩罩，君子有酒，嘉宾式燕以乐"与"南有嘉鱼，烝然汕汕，君子有酒，嘉宾式燕以衎"之句，"燕"通"宴"，"誉"通"衎"，意为宴饮欢悦。堂内陈设典雅，屏风与挂屏上多绘狮子林全景图与历代名家题咏，从这里出发，整座园林的湖石假山迷宫已在窗外隐约可见。燕誉堂以宴游之乐奠定狮子林的基调，暗示此园并非仅为静观，更是一场充满游趣的感官冒险。 Yanyu Hall is Lion Grove Garden''s main hall and the first building visitors encounter. "Yanyu" derives from the Shijing (Book of Odes): "The gentleman has wine, and the guests feast joyfully"—where "Yan" means banquet and "Yu" means delight. The hall''s interior is elegantly appointed, with screen paintings depicting Lion Grove panoramas and poetic inscriptions by masters past. Through the windows, the garden''s lake-stone labyrinth already looms tantalizingly. Yanyu Hall establishes the garden''s tone of festive exploration, signaling that Lion Grove is not merely for contemplation but for a sensory adventure brimming with playfulness.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lion_grove_garden_sa_02', 'suzhou_lion_grove_garden', 'Xiaofang Hall (Small Square Hall)', '小方厅', '<p>Description： 小方厅紧邻燕誉堂北侧，是一间面积不大但设计精巧的方形厅堂。厅名"小方"既指其平面方正规整，也暗含"方寸之间见天地"的园林哲思。小方厅最巧妙之处在于其窗框设计——东、西两侧花窗如画框般将假山群的不同片段精确裁取，游客站在厅中便能透过窗洞预览即将踏入的石山迷宫的局部景观，这种"框景"手法让方寸之厅成为整座假山群的视觉序曲。厅内陈设简约，几案清供与四壁留白构成克制而雅致的空间氛围，与窗外嶙峋湖石形成柔与刚的精彩对仗。 Xiaofang Hall sits directly north of Yanyu Hall—a small yet meticulously designed square hall. The name "Xiaofang" refers both to its regular square plan and to the garden philosophy of "seeing the cosmos within a square inch." Its most ingenious feature is the window design: east and west ornamental windows act as picture frames, precisely cropping different fragments of the rockery group, so that standing inside, visitors preview sections of the stone labyrinth they will soon enter. This framing technique turns the diminutive hall into a visual prelude for the entire rockery. The interior is restrained—simple furnishings and blank walls creating an austere elegance that contrasts brilliantly with the rugged lake stones beyond the windows, a dialogue of softness and strength.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lion_grove_garden_sa_03', 'suzhou_lion_grove_garden', 'Nine Lion Peak', '九狮峰', '<p>Description： 九狮峰是狮子林假山群中最引人注目的单体石峰，也是整座园林命名由来最直观的视觉印证。此峰由多块太湖石天然拼接而成，整体轮廓与局部凹凸皆有狮形可辨，或昂首、或伏卧、或嬉戏、或守望，细细端详可辨认出九头狮子姿态各异、栩栩如生的造型。狮子林由元代天如禅师为纪念其师中峰和尚而建，"狮子"既指假山石峰的狮形外观，也暗合佛教中"狮子吼"说法之威严象征。九狮峰矗立于小方厅与指柏轩之间的假山入口处，既是石山迷宫的地标，也是佛教禅意与世俗赏石趣味交汇的奇绝之作。 Nine Lion Peak is the rockery group''s most arresting单体 and the most direct visual proof of the garden''s naming origin. Composed of multiple Taihu (lake) stones assembled in their natural forms, its overall silhouette and surface undulations reveal lion shapes—some head-raised, some crouching, some playing, some guarding. Careful observation identifies nine lions in distinct, vivid poses. Lion Grove Garden was built by Yuan dynasty monk Tianru to honor his master Zhongfeng; "lion" refers both to the rockery''s lion-like forms and to the Buddhist metaphor of the "lion''s roar" symbolizing the power of enlightenment preaching. Nine Lion Peak stands at the rockery entrance between Xiaofang Hall and Zhibai Pavilion, serving as both the labyrinth''s landmark and a extraordinary work where Buddhist Chan philosophy and secular stone-appreciation aesthetics intersect.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lion_grove_garden_sa_04', 'suzhou_lion_grove_garden', 'Zhibai Pavilion (Point-to-Cypress Pavilion)', '指柏轩', '<p>Description： 指柏轩是狮子林假山群南侧的主要观景厅堂，其名源自禅宗公案：有僧问赵州从谂禅师"如何是祖师西来意"，赵州答"庭前柏树子"，以此寻常之物直指佛法本义，不落文字窠臼。指柏轩正是将这一禅意融入园林建筑的典范——厅前古柏苍翠挺拔，厅后假山嶙峋如兽，人在轩中既可以俯瞰石山迷宫的全貌，又能在"指柏"的典故中体悟"眼前即道"的禅机。轩内曾为僧人禅修之所，后改为文人雅集之处，屏门上悬有历代题咏。指柏轩是狮子林中将佛教禅思与江南园林赏景功能结合最为紧密的建筑。 Zhibai Pavilion is the main viewing hall on the south side of the rockery group. Its name originates from a Chan (Zen) koan: when a monk asked Zhaozhou Congshen, "What is the meaning of the Patriarch''s coming from the West?" Zhaozhou replied, "The cypress tree in the courtyard"—pointing to an ordinary object to expound the dharma''s essence, transcending textual convention. Zhibai Pavilion embodies this Chan spirit in garden architecture: an ancient cypress stands verdant and upright before the hall, rugged lion-shaped rocks behind it; from within, one can survey the entire stone labyrinth while contemplating the Chan insight that "the path is right before your eyes." The pavilion once served as a monk''s meditation space, later transforming into a literati gathering place, with poetic inscriptions on screen panels. It is Lion Grove''s building where Buddhist Chan thought and Jiangnan garden viewing are most tightly interwoven.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lion_grove_garden_sa_05', 'suzhou_lion_grove_garden', 'Hualan Hall (Flower Basket Hall)', '花篮厅', '<p>Description： 花篮厅是狮子林水池南侧的一座精美厅堂，因其檐下垂莲柱（即短柱）上雕刻有花篮纹样而得名。这些花篮雕饰工艺精湛，篮中花卉各异，或牡丹、或莲荷、或梅兰，线条流畅、层次分明，堪称苏州园林木雕装饰的上乘之作。花篮厅半架于水面之上，厅基部分浸入池中，坐于厅内可观池中倒影与对面假山全景，水面波光与石峰嶙峋在此交汇，营造出"厅在水中、山在镜里"的奇特视觉体验。厅内陈设以花为主题，四季更换瓶花，与檐下花篮雕饰形成"木雕花"与"真花"的有趣对照。 Hualan Hall is an exquisite hall on the south side of Lion Grove''s pool, named after the flower-basket motifs carved on its dangling-lotus columns (short eaves columns). These carved flower baskets demonstrate superb craftsmanship—each basket holds different blooms: peony, lotus, plum, or orchid, with flowing lines and layered depth, representing the finest of Suzhou garden wood-carved ornamentation. The hall is partially built over the water, its base partly submerged in the pool. Sitting inside, one views the pool reflections and the full rockery panorama opposite, where rippling light and rugged peaks converge, creating the uncanny visual experience of "the hall in the water, the mountain in the mirror." Interior displays follow a floral theme, with seasonal vase flowers creating an engaging contrast between "carved flowers" and "real flowers."</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lion_grove_garden_sa_06', 'suzhou_lion_grove_garden', 'Zhenqu Pavilion (True Delight Pavilion)', '真趣亭', '<p>Description： 真趣亭位于狮子林假山群东侧水池边，是园中与乾隆皇帝渊源最深的建筑。乾隆六次南巡均曾到狮子林游览，有一次在假山迷宫中流连忘返、乐不思归，遂挥毫写下"真有趣"三字。随行大臣认为"有趣"二字过于俗俚，巧妙建议取"有"字之半成"真趣"，既保留了帝王的欢愉之情，又提升了文字的雅致境界，乾隆欣然采纳。"真趣"二字既有帝王游园之乐的纪实意味，亦暗含禅宗"真如实相"的哲学层次——在迷宫般的假山中嬉游，方得人生"真趣"。亭内匾额至今保存，是狮子林最珍贵的历史文物之一。 Zhenqu Pavilion sits beside the pool on the east side of the rockery group, the garden''s building most deeply connected to Emperor Qianlong. During his six southern tours, Qianlong visited Lion Grove each time; on one occasion, lost in delight within the rockery maze, he brush-wrote "Zhen You Qu" (truly interesting). A accompanying minister deemed "You Qu" too colloquial and tactfully suggested keeping "Zhen" and changing to "Qu" (delight), preserving imperial joy while elevating literary refinement—Qianlong gladly agreed. "Zhen Qu" (True Delight) carries both the documentary sense of the emperor''s garden pleasure and the Chan philosophical dimension of "true suchness"—only by playful wandering in the labyrinthine rockery does one attain life''s "true delight." The plaque remains preserved inside the pavilion, one of Lion Grove''s most precious historical artifacts.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lion_grove_garden_sa_07', 'suzhou_lion_grove_garden', 'Stone Boat', '石舫', '<p>Description： 石舫是狮子林水池中一座仿船形的水上建筑，整体以石材构筑，船头、船舱、船尾形态逼真，舷侧石栏环绕，舱内设有石桌石凳可供小憩。石舫固定于池中不移动，故称"不系舟"——这一意象源自庄子"泛若不系之舟"的哲学寓言，寓意心灵的自由与无执。石舫是江南园林中极具代表性的建筑类型，它既满足了人在水上的驻留需求，又以"舟停水不动"的静态矛盾创造出独特的审美张力。坐于石舫舱内，四面环水，池中倒影与远处假山构成框景，恍若真的泛舟湖上而又不必忧风浪之险，虚实之间尽得游趣。 The Stone Boat is a boat-shaped water structure in Lion Grove''s pool, entirely constructed of stone with realistic bow, cabin, and stern forms, stone railings along the sides, and stone tables and benches inside for resting. Fixed in place, it is called an "untethered boat"—an image derived from Zhuangzi''s philosophical parable of drifting "like an untethered boat," symbolizing spiritual freedom and non-attachment. The stone boat is a highly representative Jiangnan garden building type: it fulfills the desire to linger on water while creating unique aesthetic tension through the static paradox of "a boat that stays, water that moves." Sitting inside the cabin, surrounded by water on all sides, pool reflections and distant rockery compose a framed view—as if truly boating on a lake yet without risk of wind or waves, achieving playful delight between reality and illusion.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lion_grove_garden_sa_08', 'suzhou_lion_grove_garden', 'Anxiang Shuying Building (Faint Scent & Sparse Shadows Building)', '暗香疏影楼', '<p>Description： 暗香疏影楼位于狮子林西北角，是一座以赏梅为主题的两层楼阁。楼名取自北宋隐士林逋的千古咏梅名句"疏影横斜水清浅，暗香浮动月黄昏"，这两句诗几乎定义了中国文化中梅花的审美标准——枝影疏朗、香气幽远。楼前植有数株古梅，冬日花开时节，登楼俯瞰可见枝影映于池水，幽香随风入窗，诗句中的意境在此得到最直接的感官兑现。楼内悬有相关题咏书画，窗格设计刻意压低视线以贴合观梅角度，整座建筑从命名到空间设计都紧扣"梅"的主题，是狮子林中将诗词意境转化为建筑体验的杰出范例。 Anxiang Shuying Building sits at the northwest corner of Lion Grove, a two-story pavilion themed around plum appreciation. Its name draws from the Northern Song recluse Lin Bu''s immortal plum verses: "Sparse shadows slant across clear shallow water; faint scent drifts at moonlit dusk"—two lines that virtually defined the plum blossom aesthetic standard in Chinese culture: sparse branches, subtle fragrance. Several ancient plum trees grow before the building; in winter bloom, ascending the upper floor reveals branch shadows reflected in the pool and delicate fragrance drifting through windows, making the poem''s imagery tangibly realized through direct sensory experience. Interior displays include related poetic calligraphy and paintings; window lattice designs deliberately lower the sightline to match plum-viewing angles. From naming to spatial design, the building is tightly bound to the plum theme—an outstanding example of translating poetic imagery into architectural experience at Lion Grove.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lion_grove_garden_sa_09', 'suzhou_lion_grove_garden', 'Huxin Pavilion (Lake-Center Pavilion)', '湖心亭', '<p>Description： 湖心亭位于狮子林中央水池的正中位置，是一座六角形的单层小亭，通过石曲桥与两岸相连。亭虽小巧，却占据全园空间构图的绝对核心——站在亭中360度环视，假山群、指柏轩、花篮厅、石舫等主要景观环绕如画，亭本身也成为其他建筑借景的对象，形成"以亭为心、景景相看"的互借关系。湖心亭的设计体现了苏州园林"以小见大"的精髓：最小体量的建筑置于最大尺度的水面中央，以亭的空透换取池的辽阔感，人在亭中不觉亭小而觉池广。朝晖夕阴之下，亭影浮水，是狮子林最上镜的取景点之一。 Huxin Pavilion occupies the exact center of Lion Grove''s main pool—a single-story hexagonal pavilion connected to both banks by stone curved bridges. Though small, it holds the absolute core of the garden''s spatial composition: standing inside with a 360-degree panorama, the rockery group, Zhibai Pavilion, Hualan Hall, Stone Boat, and other major scenes encircle the view like a painting; the pavilion itself becomes a borrowed-view object for other buildings, creating a mutual viewing relationship of "the pavilion as center, every scene seeing every scene." Huxin Pavilion''s design embodies Suzhou garden''s essence of "seeing the vast through the small": the smallest-volume building placed at the center of the largest-scale water surface, the pavilion''s transparency换取 the pool''s sense of expansiveness—inside, one does not feel the pavilion small but the pool vast. Under morning light or evening shadow, the pavilion floats on the water as one of Lion Grove''s most photogenic spots.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lion_grove_garden_sa_10', 'suzhou_lion_grove_garden', 'Woyun Chamber (Cloud-Reclining Chamber)', '卧云室', '<p>Description： 卧云室位于狮子林假山群的最高处，是整座园林海拔最高的建筑，也是唯一一座嵌入石峰之中的禅修空间。"卧云"二字极具诗意与禅意——云在天上，室在山中，人在室内仿佛高卧云端，俯瞰人间；亦暗合天如禅师"云水禅心"的修行理念。卧云室体量极小，仅可容数人静坐，室内素净无华，仅设蒲团与简素几案，与假山石壁的粗犷质感形成内外对比。从卧云室向外望去，假山石洞、池水波光与远处园墙构成一幅框景，人在"云端"俯瞰"红尘"，空间的高差赋予了真实的心理超脱感。这是狮子林将建筑嵌入假山的最精妙之作，也是禅意与园林融合的至高表达。 Woyun Chamber occupies the highest point of Lion Grove''s rockery—the garden''s highest-altitude building and the only Chan meditation space embedded within a stone peak. "Woyun" (Cloud-Reclining) is richly poetic and Chan-inflected: clouds above, the chamber amid the rocks, the person inside seemingly resting on clouds looking down at the mortal world; it also echoes monk Tianru''s "cloud-and-water Chan mind" practice philosophy. The chamber is extremely small, accommodating only a few seated people, austere inside—just meditation cushions and a simple table contrasting with the rough stone walls outside. Gazing outward, rock tunnels, pool ripples, and distant garden walls compose a framed view; the spatial elevation confers a genuine sense of psychological detachment—looking down from the "clouds" upon the "red dust." This is Lion Grove''s most exquisite work of embedding architecture within rockery, and the supreme expression of Chan philosophy merged with garden art.</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lingering_garden_sa_01', 'suzhou_lingering_garden', 'Ancient Trees Interlocking', '古木交柯', '<p>Description： 古木交柯位于留园入口区域，是游人踏入园林后首先映入眼帘的景致。一株古柏与一株山茶枝干交错缠绕，宛如恋人相依，故得名"交柯"。此景取意于古树苍劲之美与花木柔媚之姿的和谐共生，暗合中国传统文化中阴阳相济的哲学思想。明代文徵明曾绘类似景致，留园此景堪称活态再现，亦为园林"以小见大"造景手法的绝佳范例。 Ancient Trees Interlocking lies at the entrance area of Lingering Garden, greeting visitors as the first scenic vista upon stepping into the garden. An ancient cypress and a camellia intertwine their branches, resembling lovers leaning upon each other, hence the name "Interlocking." This scene embodies the harmonious coexistence of rugged strength and delicate beauty, reflecting the Chinese philosophical concept of yin-yang complementarity. The Ming dynasty painter Wen Zhengming once depicted similar imagery; this living scene in Lingering Garden serves as a vivid re-creation and a superb example of the garden design principle of "seeing the grand in the small."</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lingering_garden_sa_02', 'suzhou_lingering_garden', 'Green Shade Pavilion', '绿荫轩', '<p>Description： 绿荫轩位于留园中部，紧邻涵碧山房，是一座依墙而筑、面水而立的小型轩式建筑。轩前古树浓荫蔽日，夏日坐于其中，微风拂面，荷香暗度，别有清幽之趣。"绿荫"二字点明其环境特质——以树荫营造清凉意境，是苏州园林"借景遮景"手法的典型运用。轩内陈设简雅，窗外绿意满目，一几一椅便可品茗赏景，堪称留园中最宜静坐冥思之所。 Green Shade Pavilion sits in the central part of Lingering Garden, adjacent to Hanbi Mountain House. It is a small pavilion-style structure built against a wall and facing the water. Ancient trees before the pavilion cast dense shade; sitting here in summer, one enjoys gentle breezes and faint lotus scents—a uniquely tranquil pleasure. The name "Green Shade" highlights its environmental essence—using tree canopy to create a cooling ambiance, a classic example of Suzhou garden techniques of "borrowed and screened views." With simple furnishings and verdant views beyond the windows, a single table and chair suffice for tea-sipping and scenery appreciation—arguably the most ideal spot for quiet contemplation in Lingering Garden.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lingering_garden_sa_03', 'suzhou_lingering_garden', 'Hanbi Mountain House', '涵碧山房', '<p>Description： 涵碧山房是留园中部景区的主厅，坐南朝北，面阔三间，前临碧波荡漾的水池，后倚假山花木，是留园赏景的最佳立足点之一。"涵碧"取自宋代朱熹诗句"一水方涵碧"，意为水光包容翠色，意境清远。厅内敞亮明净，南北皆可观景：南望假山古木，北览池水映天，山房之名实为"山水皆涵于此房"的精妙概括。此建筑体现了苏州园林厅堂与山水互为因果的设计哲学，人在室中而景在窗外，内外交融，浑然一体。 Hanbi Mountain House is the principal hall in Lingering Garden''s central scenic area, facing north with three bays wide. It fronts a rippling pond and backs onto artificial hills and floral plantings—one of the garden''s premier vantage points. "Hanbi" derives from the Song dynasty poet Zhu Xi''s line "One water just embraces emerald," meaning water''s radiance contains verdant hues—an imagery of pristine expansiveness. The hall is bright and open, with scenic views both north and south: southward toward hills and ancient trees, northward over a pool mirroring the sky. The name encapsulates the idea that "both mountain and water are embraced within this house." This structure embodies the Suzhou garden design philosophy where hall and landscape are mutually constitutive—one sits indoors while scenery unfolds beyond the windows, interior and exterior seamlessly interwoven.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lingering_garden_sa_04', 'suzhou_lingering_garden', 'Osmanthus Fragrance Pavilion', '闻木犀香轩', '<p>Description： 闻木犀香轩位于留园西部景区，是一座专为品赏桂花芬芳而设的轩式建筑。"木犀"即桂花之古称，轩名直白地表达了其造景意图——以嗅觉体验丰富园林感官维度。秋季金桂盛开之际，满轩馥郁，香气沁人心脾，游人至此无不驻足深呼吸，感叹造园者以香入景的独运匠心。轩周遍植桂树，配以假山石径，构成留园中一处以嗅觉为主导的独特审美空间，打破了园林仅以视觉赏景的常规，堪称中国园林中"闻香识景"的经典范例。 Osmanthus Fragrance Pavilion is located in the western scenic area of Lingering Garden, a pavilion-style structure expressly designed for appreciating the scent of osmanthus. "Muxi" is the classical term for osmanthus; the pavilion name plainly declares its design intent—enriching the garden''s sensory dimensions through olfactory experience. When golden osmanthus blooms in autumn, the pavilion is suffused with intoxicating fragrance; visitors inevitably pause to breathe deeply, marveling at the garden maker''s ingenuity in incorporating scent as scenery. Osmanthus trees are planted all around, complemented by rockery paths, forming a unique aesthetic space in Lingering Garden where olfaction takes precedence—breaking the convention of purely visual garden appreciation, and standing as a classic paradigm of "recognizing scenery through fragrance" in Chinese garden design.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lingering_garden_sa_05', 'suzhou_lingering_garden', 'Winding Stream Tower', '曲溪楼', '<p>Description： 曲溪楼位于留园东部，是一座临水而建的二层楼阁式建筑。楼名取自园中水道蜿蜒曲折之态，"曲溪"二字既写实又写意——溪水曲行是实景，人生曲径是喻意。楼上设敞窗长栏，登临远眺，东部水景尽收眼底：曲桥回廊、亭台倒影、水波涟漪层层叠映。楼下临水设廊，可近距离观赏溪石与游鱼。曲溪楼兼具"登高望远"与"临水听波"的双重体验，是留园建筑中观景功能最为丰富的楼阁之一，也体现了苏州园林楼阁设计"上下皆景"的巧思。 Winding Stream Tower stands in the eastern section of Lingering Garden, a two-story tower-style structure built beside the water. The name draws from the winding course of the garden''s waterway—"Winding Stream" is both descriptive and poetic: the actual winding stream and the metaphorical winding paths of life. The upper floor features open windows and a long railing; ascending for a distant view, the entire eastern water scene unfolds—winding bridges, corridor reflections, ripple layers upon layers. The lower floor has a waterside corridor for close viewing of stream stones and swimming fish. Winding Stream Tower offers the dual experience of "ascending for distant vistas" and "sitting by water to hear ripples," making it one of the most observationally versatile towers in Lingering Garden, and exemplifying the Suzhou garden design ingenuity of "scenery both above and below."</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lingering_garden_sa_06', 'suzhou_lingering_garden', 'Five Peaks Fairy Hall', '五峰仙馆', '<p>Description： 五峰仙馆是留园东部景区的核心建筑，也是全园体量最大的厅堂，面阔五间，气宇轩昂。厅前庭院中立有五座太湖石峰，高低参差，姿态各异，模拟传说中仙人居住的五座神山之意象，故名"五峰仙馆"。厅内梁柱用材考究，楠木为骨，雕饰精美而不繁缛，陈设典雅庄重，体现了江南文人厅堂"大而不奢、精而不俗"的审美追求。此厅为留园主人接待贵宾、举办雅集的主要场所，空间开阔而层次分明，是苏州园林中厅堂设计的典范之作。 Five Peaks Fairy Hall is the core building of Lingering Garden''s eastern scenic area and the largest hall in the entire garden, spanning five bays with imposing grandeur. In the courtyard before the hall stand five Taihu stone peaks of varying heights and distinct postures, simulating the imagery of the five divine mountains where immortals dwell—hence the name. The hall''s structural materials are meticulously chosen: nanmu wood frames the beams and columns, with refined carvings that are exquisite yet not excessive, and elegant, dignified furnishings—reflecting the Jiangnan literati aesthetic of "grand yet not extravagant, refined yet not vulgar." This hall served as the garden owner''s principal venue for receiving distinguished guests and hosting elegant gatherings, with spacious yet well-layered interiors, standing as a paradigm of hall design in Suzhou gardens.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lingering_garden_sa_07', 'suzhou_lingering_garden', 'Hall of Elderly Sages in Woodland Springs', '林泉耆硕之馆', '<p>Description： 林泉耆硕之馆位于留园东部，紧邻五峰仙馆，是一座风格独特的双面厅。"林泉"指山林泉石之隐逸环境，"耆硕"指年高德劭的长者贤士，馆名表达了园主人对隐逸高士的敬意与向往。此馆建筑形制特殊：一面面向庭院山石，另一面面向水池亭廊，南北景致迥异而建筑浑然一体，堪称苏州园林中"一厅两景"的极致设计。厅内匾额楹联皆为名家手笔，文气浓郁，是留园中最能体现文人园林精神内核的建筑空间。 Hall of Elderly Sages in Woodland Springs is located in the eastern part of Lingering Garden, adjacent to Five Peaks Fairy Hall, and is a distinctive double-facing hall. "Woodland Springs" refers to the reclusive environment of mountains, forests, and spring waters; "Elderly Sages" denotes venerable persons of high virtue and senior age. The hall name expresses the garden owner''s reverence and aspiration for reclusive scholars of distinction. Its architectural form is remarkable: one side faces the courtyard rockery, the other faces the pool and corridor pavilions—north and south scenes are strikingly different while the building remains seamlessly unified, representing the ultimate expression of "one hall, two views" in Suzhou garden design. Inscribed plaques and couplets inside are all by renowned calligraphers, with a strong literary atmosphere—arguably the building that best embodies the literati spirit at the core of Lingering Garden.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lingering_garden_sa_08', 'suzhou_lingering_garden', 'Cloud-Capped Peak', '冠云峰', '<p>Description： 冠云峰是留园最负盛名的景点，也是全园的镇园之宝。此石高约6.5米，重约5吨，为太湖石中的极品，具备"瘦、漏、透、皱"四大审美标准之极致表现。石峰姿态雄奇，顶耸如冠云端，故得名"冠云"。相传此石为宋代花石纲遗物，历经千年风雨仍屹立于此，堪称江南园林现存最高的独立太湖石峰。冠云峰四周环以水池亭廊，石影倒映水中，虚实相生，更增其灵秀之气。赏石是中国文人园林文化的精髓，冠云峰正是这一传统的巅峰之作。 Cloud-Capped Peak is Lingering Garden''s most celebrated landmark and its crown jewel. Standing approximately 6.5 meters tall and weighing about 5 tons, it is the supreme specimen among Taihu stones, achieving the ultimate expression of the four aesthetic criteria: "slender, perforated, translucent, and wrinkled." The peak''s posture is majestic, its summit soaring like a crown piercing the clouds—hence the name. Legend holds it as a remnant of the Song dynasty''s "Flower and Stone Network" tribute collection; having endured a millennium of wind and rain, it remains standing here—the tallest independent Taihu stone peak surviving in Jiangnan gardens. Surrounded by pools, pavilions, and corridors, the stone''s silhouette reflects in the water, generating an interplay of reality and illusion that enhances its ethereal elegance. Stone appreciation is the essence of Chinese literati garden culture, and Cloud-Capped Peak stands as the pinnacle of this tradition.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_lingering_garden_sa_09', 'suzhou_lingering_garden', 'Cloud-Capped Tower', '冠云楼', '<p>Description： 冠云楼位于留园东部，紧依冠云峰而建，是一座三层楼阁式建筑。楼名与石峰同名，因登楼即可俯瞰冠云峰全貌而得名。楼与峰构成一组经典的"楼峰对景"——自楼俯视，石峰巍峨挺拔之态尽现；自峰仰望，楼阁飞檐翘角之姿尽显。两者高低呼应，虚实互补，堪称苏州园林建筑与石峰组合的绝妙搭配。冠云楼内还藏有留园重要的碑刻与文物，楼上设窗可远眺园外姑苏城景，是留园中兼具近观与远望功能的观景制高点。 Cloud-Capped Tower stands in the eastern part of Lingering Garden, built right beside Cloud-Capped Peak, a three-story tower-style structure. It shares the peak''s name because ascending the tower affords a complete panoramic view of Cloud-Capped Peak. The tower and peak form a classic "tower-peak opposing view"—looking down from the tower, the peak''s majestic upright posture is fully revealed; gazing up from the peak, the tower''s sweeping eaves and corner brackets are entirely displayed. The two resonate in height and complement each other in solidity and void, arguably the most brilliant pairing of architecture and stone peak in Suzhou gardens. Cloud-Capped Tower also houses important inscribed stone tablets and artifacts of Lingering Garden. Windows on the upper floors allow distant views beyond the garden across the Gusu cityscape—it is the scenic high point in Lingering Garden combining both close and distant observation functions.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_master_of_nets_garden_sa_01', 'suzhou_master_of_nets_garden', 'Entrance Gate', '入口大门', '<p>Description： 网师园的入口大门位于阔家头巷11号，隐于苏州古城东南隅的居民巷弄之中。门厅为传统江南宅第样式，青砖门框，黑漆木门，门楣上方悬挂"网师园"匾额。门前巷道狭窄，两侧白墙灰瓦，行走在其中，很难想象巷尽头藏着一座世界文化遗产。这种"大隐隐于市"的选址正是网师园的特色所在——主人追求的不是临街的气派，而是在繁华城市中营造一处宁静的隐逸之所。推门而入，迎面是轿厅，透出一丝园内景致，引导访客从市井小巷过渡到园林雅境，空间收放之间尽显造园者的匠心。 The entrance gate of Wangshi Yuan is located at No. 11, Kuojia Tou Lane, nestled among residential alleyways in the southeastern corner of Suzhou''s old city. The gatehouse follows traditional Jiangnan residential style, with a grey-brick doorframe, black-lacquered wooden doors, and a plaque reading "Wangshi Yuan" above the lintel. The narrow lane approaching the gate is lined with white walls and grey-tiled eaves, giving no hint that a UNESCO World Heritage garden lies at its end. This "hidden within the city" setting is precisely the garden''s defining characteristic—the owner sought not street-facing grandeur, but a tranquil retreat within the bustling city. Pushing open the door reveals the Sedan Chair Hall, offering a glimpse of the garden within, guiding visitors from the mundane alley into a refined garden realm. The interplay of compression and release in spatial design showcases the masterful vision of the garden''s creator.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_master_of_nets_garden_sa_02', 'suzhou_master_of_nets_garden', 'Sedan Chair Hall', '轿厅', '<p>Description： 轿厅是网师园住宅部分的第一进建筑，也是访客入园后的第一个室内空间。厅堂面阔三间，梁架为抬梁式，简洁疏朗。这里最初用于停落轿舆，客人到此下轿，由仆人通报主人后迎入内厅。厅内正中悬有清代学者所书匾额，两侧悬挂楹联，内容多与渔隐、隐逸主题相关，呼应园名"网师"之意。厅内陈设有一面大型平面镜和一座大理石插屏——镜中映出身后庭景，使有限空间产生延伸之感，这是苏州园林中常见的"借景"手法。轿厅虽为过渡空间，却已通过这些精心布置透露出主人的文化品位和造园理念。 The Sedan Chair Hall is the first building in the residential section of Wangshi Yuan and the first interior space visitors enter. The hall spans three bays with a simple, open beam-frame structure. It was originally used for parking sedan chairs: guests would dismount here, and after a servant announced them to the master, they would be received into the inner hall. A plaque inscribed by a Qing Dynasty scholar hangs at the center, flanked by couplets whose texts often relate to fishing and reclusion, echoing the garden''s name "Master of the Nets." The hall contains a large wall mirror and a marble screen—the mirror reflects the courtyard scene behind, creating an illusion of extended space within the compact hall. This is a classic "borrowed scenery" technique in Suzhou gardens. Though merely a transitional space, the Sedan Chair Hall already reveals the owner''s cultural refinement and design philosophy through these carefully curated elements.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_master_of_nets_garden_sa_03', 'suzhou_master_of_nets_garden', 'Wanjuan Hall (Hall of Ten Thousand Scrolls)', '万卷堂', '<p>Description： 万卷堂为网师园住宅区的正厅，也是全园最重要的礼仪性建筑。"万卷堂"之名可追溯至南宋，时任吏部侍郎的史正志在此建园藏书，堂名寓意"读书万卷"，体现了中国文人"腹有诗书气自华"的理想。清乾隆年间宋宗元重建网师园时沿用此名，以示对前贤的敬意。厅堂面阔五间，高敞恢宏，梁柱用材粗壮，柱础为青石覆盆式。正中悬挂"万卷堂"匾额，为明代文征明手迹。厅内陈设按传统格式布置：居中长案，两侧太师椅，墙上悬挂名家书画。堂前有院，植金桂与白玉兰，取"金玉满堂"之意。这里是主人接待贵宾、举行家宴、展示文化品位的场所。 Wanjuan Hall is the main hall of Wangshi Yuan''s residential quarter and the garden''s most important ceremonial building. The name "Wanjuan Tang" (Hall of Ten Thousand Scrolls) traces back to the Southern Song Dynasty, when Shi Zhengzhi, Vice Minister of Personnel, built a garden here to house his vast book collection—the name embodying the Chinese literati ideal of "reading ten thousand scrolls." When Song Zongyuan rebuilt the garden during the Qianlong reign of the Qing Dynasty, he retained the name in tribute to his predecessor. The hall spans five bays with a lofty, imposing interior, robust timber columns, and blue-stone basin-shaped plinths. A plaque reading "Wanjuan Tang" hangs at the center, featuring calligraphy attributed to Ming Dynasty master Wen Zhengming. The interior follows traditional arrangement: a long narrow table at center, armchairs on either side, and celebrated paintings and calligraphy on the walls. The courtyard before the hall features golden osmanthus and white magnolia, symbolizing "abundance of gold and jade." This was where the owner received distinguished guests, hosted family banquets, and displayed his cultural refinement.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_master_of_nets_garden_sa_04', 'suzhou_master_of_nets_garden', 'Xiexiu Tower (Gathering Elegance Tower)', '撷秀楼', '<p>Description： 撷秀楼位于万卷堂正北，是网师园住宅区的内宅部分，为主人及家眷的日常生活之所。"撷秀"意为"采撷秀色"，取自南朝谢灵运诗意，寄托了主人对美好生活的向往。楼为两层建筑，楼下为起居与用餐之所，楼上为卧室与书房。楼上设有回廊与窗户，推窗可望见园中彩霞池及亭台楼阁。楼内原有红木家具、雕花栏杆与精美窗棂，工艺精湛。撷秀楼与万卷堂之间以天井相连，天井中设有花台，植有茶花与南天竹，四季有景。从万卷堂到撷秀楼，空间从公共礼仪区过渡到私人家居区，体现了"前厅后楼、内外有别"的传统宅第格局，也展示了苏州大户人家居家生活的精致与讲究。 Xiexiu Tower stands directly north of Wanjuan Hall, serving as the inner residence of Wangshi Yuan where the owner and family conducted daily life. "Xiexiu" means "gathering elegance," derived from the poetry of Xie Lingyun of the Southern Dynasties, expressing the owner''s aspiration for a refined life. The two-story building has a ground floor for living and dining, with bedrooms and a study upstairs. The upper floor features a corridor and windows that open onto views of Rosy Cloud Pool and the garden''s pavilions. The interior once contained rosewood furniture, carved railings, and exquisite latticed windows, all demonstrating superb craftsmanship. A small sky-well connects Xiexiu Tower to Wanjuan Hall, with a planted flower bed featuring camellia and nandina, providing year-round interest. The transition from Wanjuan Hall to Xiexiu Tower marks a shift from public ceremonial space to private domestic space, embodying the traditional residential layout of "front hall, rear tower, inner and outer distinct," while showcasing the refinement of a wealthy Suzhou household''s daily life.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_master_of_nets_garden_sa_05', 'suzhou_master_of_nets_garden', 'Tiyun Room (Cloud-Stepping Room)', '梯云室', '<p>Description： 梯云室位于网师园西北部，是园主读书治学之所。"梯云"取自唐代周生"梯云取月"的典故，暗喻登高望远、追求高远境界之意。此室最精妙之处在于其登楼方式——不设常规木梯，而是以太湖石叠成假山蹬道，人需沿湖石攀援而上方能到达二层书楼，如同踏云而行，故名"梯云"。湖石蹬道既是楼梯又是假山景观，一物两用，巧夺天工。室内原陈设书案、书架与文房四宝，环境清幽。窗外可见假山翠竹，营造出"书斋隐于山间"的意境。梯云室的设计充分体现了苏州园林"因地制宜、巧于因借"的造园原则，将实用功能与审美意趣完美结合，是园林建筑中"功能即艺术"的经典案例。 Tiyun Room is located in the northwest of Wangshi Yuan, serving as the owner''s study. "Tiyun" (Cloud-Stepping) derives from a Tang Dynasty tale of Zhou Sheng "climbing clouds to fetch the moon," metaphorically suggesting ascending to lofty heights in pursuit of elevated ideals. The most brilliant feature of this room is its means of access: rather than a conventional wooden staircase, a pathway of Taihu limestone rocks is stacked into a miniature mountain path. One must ascend along the rockery to reach the second-floor study, as if walking on clouds—hence "Tiyun." The rockery serves dual purpose as both staircase and landscape feature, a masterstroke of ingenuity. The interior was once furnished with a writing desk, bookshelves, and the Four Treasures of the Study, in a serene setting. Windows reveal rockeries and verdant bamboo outside, creating the atmosphere of "a study hidden in the mountains." Tiyun Room''s design exemplifies the Suzhou garden principle of "adapting to the terrain and borrowing cleverly," perfectly uniting practical function with aesthetic delight—a classic case of "function as art" in garden architecture.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_master_of_nets_garden_sa_06', 'suzhou_master_of_nets_garden', 'Kansong Duhua Veranda (Pine-Viewing and Painting-Reading Veranda)', '看松读画轩', '<p>Description： 看松读画轩位于彩霞池西岸，是网师园中最具文人气息的建筑之一。"看松读画"四字点明了此处的两大雅事——观赏古松、品读画意。轩为三开间，南向临水，前设坐栏，可坐可观。轩前院中植有一株罗汉松，相传已有数百年树龄，枝干苍劲，姿态古拙，与湖石相映成趣，本身便是一幅天然的"松石图"。主人坐于轩中，观松之苍劲、读画之意境，自然与艺术交融无间。轩内原有书案与书画悬挂，窗棂图案精美，框景如画。从轩中望出，彩霞池、月到风来亭、濯缨水阁等景致层层叠叠，如展开一幅山水长卷。此轩充分体现了苏州园林"静观"的审美方式——不是行走游览，而是安坐一室，让山水自然来就人。 Kansong Duhua Veranda stands on the western shore of Rosy Cloud Pool, one of the most literati-spirited buildings in Wangshi Yuan. The name "Kansong Duhua" (Viewing Pines and Reading Paintings) identifies the two refined pursuits associated with this space: admiring ancient pines and contemplating painted landscapes. The veranda has three bays facing south toward the water, with a seated railing at the front for both sitting and viewing. In the courtyard before the veranda grows a Buddhist pine (Podocarpus) estimated to be several centuries old, its weathered branches and ancient silhouette set against Taihu rocks, forming a natural "pine and rock painting." Seated inside, the owner could appreciate the vigor of the pine and the mood of paintings, with nature and art intermingling seamlessly. The interior once held a writing desk and hanging paintings, with delicately patterned latticed windows framing views like picture frames. Looking out from the veranda, Rosy Cloud Pool, the Moon-Arriving Pavilion, and Zhuoying Water Pavilion layer upon one another like an unrolling landscape scroll. This veranda exemplifies the Suzhou garden aesthetic of "still contemplation"—not wandering through scenery, but sitting peacefully and letting the landscape come to you.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_master_of_nets_garden_sa_07', 'suzhou_master_of_nets_garden', 'Dianchun Yi (Late Spring Cabin)', '殿春簃', '<p>Description： 殿春簃位于网师园西北角，是一处自成格局的独立小庭院。"殿春"指暮春时节——春季最后一个开花的芍药称为"殿春花"，此处原植芍药，花期在暮春，故名"殿春簃"。"簃"意为楼阁旁的小屋。庭院虽仅一亩余，却集建筑、假山、花木、泉水于一体，堪称"园中之园"。正房为书斋三间，陈设雅致，内有书案、琴桌与古玩。斋前有半亭名"冷泉亭"，旁有涵碧泉，泉水清冽，终年不涸。院中太湖石峰玲珑剔透，植有芍药、梅树与翠竹。1980年，美国纽约大都会艺术博物馆以殿春簃为蓝本，仿建了中国庭院"明轩"（Astor Court），成为中国古典园林走向世界的里程碑。殿春簃也因此成为中美文化交流史上的一段佳话。 Dianchun Yi is located in the northwest corner of Wangshi Yuan, a self-contained courtyard of its own. "Dianchun" refers to late spring—herbaceous peonies, the last flowers to bloom in spring, were called "dianchun flowers," and since peonies were originally planted here, the name "Dianchun Yi" was chosen. "Yi" means a small chamber beside a main building. Though the courtyard covers barely a quarter-acre, it integrates architecture, rockery, plantings, and a spring—a "garden within a garden." The main room is a three-bay study with refined furnishings including a writing desk, zither table, and antiquities. Before the study stands a half-pavilion named Lengquan Ting (Cold Spring Pavilion), beside Hanbi Spring, whose crystal-clear water never runs dry. Taihu stone peaks in the courtyard are exquisitely perforated, complemented by peonies, plum trees, and bamboo. In 1980, the Metropolitan Museum of Art in New York created the Astor Court (Ming Studio) based on Dianchun Yi, marking a milestone in the global journey of Chinese classical gardens. Dianchun Yi thus became a celebrated chapter in the history of Sino-American cultural exchange.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_master_of_nets_garden_sa_08', 'suzhou_master_of_nets_garden', 'Yuedao Fenglai Pavilion (Moon-Arriving and Wind-Coming Pavilion)', '月到风来亭', '<p>Description： 月到风来亭位于彩霞池西岸中部，三面环水，是网师园水景区的核心建筑。亭名取自宋代邵雍诗句"月到天心处，风来水面时"，意境高远：月到天心则光华遍洒，风来水面则波纹涟漪，皆为自然之至美。亭为方形，歇山顶，三面通透，一面依墙。亭内设美人靠栏杆，临水而坐，池中倒影如镜。此处是全园赏月最佳处——中秋之夜，明月从东面升起，映入池中，天上一轮月、水中一轮月交相辉映，堪称苏州园林赏月的极致体验。亭中悬有一面大镜，镜中映出对岸亭台倒影，虚实相生，使有限的水面空间产生了无尽的层次。月到风来亭将"月""风""水""镜"四种元素巧妙融合，体现了中国园林追求"虽由人作、宛自天开"的最高境界。 Yuedao Fenglai Pavilion stands at the center of Rosy Cloud Pool''s western shore, surrounded by water on three sides—the core structure of Wangshi Yuan''s waterscape. The name derives from a line by Song Dynasty poet Shao Yong: "When the moon reaches the heart of heaven, when the wind comes across the water''s surface"—a vision of transcendent beauty: moonlight at zenith bathes all in radiance, and wind on water ripples into endless patterns. The square pavilion has a gable-and-hip roof, open on three sides with one wall. A "beauty''s resting" railing faces the water; seated here, the pool''s surface mirrors the world. This is the garden''s premier moon-viewing spot—on Mid-Autumn night, the bright moon rises in the east and reflects into the pool, one moon above and one below shimmering in tandem, the ultimate Suzhou garden moon-viewing experience. A large mirror hangs inside the pavilion, reflecting the pavilions across the water—virtual and real intertwining, giving the compact pool infinite depth. The pavilion masterfully integrates four elements—moon, wind, water, and mirror—exemplifying the highest ideal of Chinese gardens: "though made by human hands, it seems created by nature itself."</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_master_of_nets_garden_sa_09', 'suzhou_master_of_nets_garden', 'Zhuoying Water Pavilion (Tassel-Washing Water Pavilion)', '濯缨水阁', '<p>Description： 濯缨水阁位于彩霞池南岸，是一座贴水而建的水阁。"濯缨"取自《楚辞·渔父》中"沧浪之水清兮，可以濯吾缨"之句。"缨"是古代官帽上的系带，"濯缨"意为洗涤官帽缨带，暗喻远离官场、归隐山林。这一命名与网师园"渔隐"的主题完美呼应。水阁面阔三间，歇山顶，四面通透，下以石柱支撑，凌于水面之上。阁内设有石桌石凳，夏日在此纳凉品茗，水面清风穿阁而过，暑气全消。从阁中北望，月到风来亭与看松读画轩隔水相望，倒映池中，如一幅对称的水墨画。阁名由清代学者题写，阁内还悬有楹联，内容与渔隐、沧浪主题相关。濯缨水阁以文学典故为内核，以水景为外显，将诗意、画意与园林意融为一体。 Zhuoying Water Pavilion stands on the southern shore of Rosy Cloud Pool, a water pavilion built flush with the surface. "Zhuoying" (washing tassels) derives from the Chu Ci (Songs of Chu) "Yu Fu" chapter: "When the waters of Canglang are clear, I can wash my hat-strings." "Ying" refers to the strings of an official''s cap; "washing the tassels" metaphorically means cleansing oneself of official life and retreating to nature. This naming perfectly echoes Wangshi Yuan''s theme of "fisherman''s reclusion." The pavilion spans three bays with a gable-and-hip roof, open on all sides, supported on stone columns above the water. Inside are stone tables and stools; on summer days, cool breezes sweep through off the pool, dispelling all heat. Looking north from the pavilion, Yuedao Fenglai Pavilion and Kansong Duhua Veranda face each other across the water, reflected in the pool like a symmetrical ink painting. The name plaque was inscribed by a Qing Dynasty scholar, with couplets relating to the themes of fishing and the Canglang River. Zhuoying Water Pavilion uses literary allusion as its inner core and waterscape as its outer expression, seamlessly fusing poetic, pictorial, and garden meaning into one.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_master_of_nets_garden_sa_10', 'suzhou_master_of_nets_garden', 'Zhuwai Yizhi Veranda (A Single Branch Beyond Bamboo Veranda)', '竹外一枝轩', '<p>Description： 竹外一枝轩位于彩霞池东北角，是一座窄长形的小轩，临水而筑。"竹外一枝"取自苏轼《和秦太虚梅花》"竹外一枝斜更好"之句，原写梅花在竹丛外斜伸一枝的清雅姿态。轩以此为名，既点出窗外竹与梅的植物配置，也暗示此处观景如同欣赏一幅文人画——简约而有余韵。轩为三开间，南北走向，西面临水，东面依墙。西面设通排长窗，窗框如画框，将池中景色尽收其中。窗外植翠竹数竿、梅树一株，冬日梅枝斜出竹外，正是"竹外一枝斜更好"的诗意再现。轩内空间窄长，设坐栏与小桌，宜独坐品茗、静观水景。从轩中望去，彩霞池对岸的月到风来亭、濯缨水阁如画中山水，虚实相生。此轩以少胜多，以小见大，是苏州园林"芥子纳须弥"哲学的生动写照。 Zhuwai Yizhi Veranda is located at the northeast corner of Rosy Cloud Pool, a narrow, elongated pavilion built along the water. "Zhuwai Yizhi" (A Single Branch Beyond Bamboo) derives from Su Shi''s poem "He Qin Taixu Meihua": "A single branch slanting beyond bamboo is all the more lovely," originally describing how a plum branch extending beyond a bamboo thicket embodies elegant restraint. The name identifies both the plantings outside the window—bamboo and plum—and the viewing experience itself, which resembles contemplating a literati painting: spare yet resonant. The veranda has three bays running north-south, facing the water to the west and backed by a wall to the east. The western side features a full run of tall latticed windows, each frame like a picture frame capturing the pool scenery. Outside, a few stalks of bamboo and a single plum tree grow; in winter, when a plum branch extends beyond the bamboo, the poem''s imagery comes alive. The narrow interior has a seated railing and small table, ideal for sitting alone with tea and quietly observing the water. Looking out, Yuedao Fenglai Pavilion and Zhuoying Water Pavilion across Rosy Cloud Pool appear like a landscape painting, virtual and real interplaying. This veranda achieves much with little, sees the large within the small—a vivid embodiment of the Suzhou garden philosophy of "a mustard seed holding Mount Sumeru."</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_ou_garden_sa_01', 'suzhou_ou_garden', 'Entrance Hall', '门厅', '<p>Description： 门厅是藕园的入口空间，也是整座园林对外展示的第一面。藕园虽为苏州名园，但其门面却不张扬，仅以普通民宅式样呈现，暗合苏州园林"大隐隐于市"的文化传统。门厅建筑朴素简洁，粉墙黛瓦，不设雕饰，恰如其分地传达了园主归隐田园、不求闻达的处世态度。步入门厅，穿过屏门，才渐见园林深处的山水之美，这种"由朴入雅"的空间序列，正是苏州园林设计"藏景"手法在入口处的经典体现。 The Entrance Hall is the gateway space of Couple''s Garden Retreat—the garden''s first outward-facing aspect. Despite its renown as a Suzhou classic garden, its facade is understated, presented in the style of an ordinary residence, aligning with the Suzhou garden cultural tradition of "great reclusion within the city." The Entrance Hall is simple and unadorned—white walls, black tiles, no decorative carvings—aptly conveying the garden owner''s philosophy of retreating to pastoral life without seeking fame. Only after stepping through the Entrance Hall and past the screen door does the scenic beauty of mountains and water gradually reveal itself. This spatial sequence of "from simplicity to refinement" is a classic embodiment of Suzhou garden design''s "concealed scenery" technique at the entry point.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_ou_garden_sa_02', 'suzhou_ou_garden', 'Sedan Chair Hall', '轿厅', '<p>Description： 轿厅位于门厅与大厅之间，是苏州传统宅园中不可或缺的过渡性建筑空间。旧时主人及宾客乘轿来访，轿子即停于此厅，故名"轿厅"。此厅既是功能性的停放与等候场所，也是空间节奏上的过渡节点——从外部的朴素门厅经轿厅步入大厅，建筑尺度逐步升高，装饰渐趋精美，形成"由外入内、由简入奢"的空间递进。轿厅体量适中，既不喧宾夺主，也不寒酸局促，恰到好处地衔接了门厅的低调与大厅的庄重，是苏州园林建筑序列中承前启后的关键环节。 The Sedan Chair Hall sits between the Entrance Hall and the Main Hall, an indispensable transitional architectural space in traditional Suzhou residence-gardens. In former times, when the owner or guests arrived by sedan chair, the conveyance was parked here—hence the name. This hall is both a functional parking and waiting area and a transitional node in spatial rhythm—from the modest Entrance Hall through the Sedan Chair Hall into the Main Hall, building proportions gradually increase and decorations become more refined, forming a spatial progression of "from exterior to interior, from simplicity to splendor." The Sedan Chair Hall is proportionately sized—neither overshadowing nor appearing shabby—perfectly bridging the understated Entrance Hall and the dignified Main Hall, serving as the pivotal connecting link in Suzhou garden architectural sequences.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_ou_garden_sa_03', 'suzhou_ou_garden', 'Main Hall (Shequ Hall)', '大厅（涉趣堂）', '<p>Description： 大厅又名"涉趣堂"，是藕园住宅区的核心建筑，面阔三间，体量宏大，是园中举行正式礼仪和接待宾客的主场所。"涉趣"二字取意于陶渊明"涉趣而往"之句，意为循着兴趣与趣味去探索体验，这正是藕园整体造园哲学的内核——不求宏大壮观，而求趣味盎然。厅内陈设庄重典雅，楠木家具与名家书画相映，堂匾"涉趣堂"为当时名人所题。大厅前后皆有庭院，前庭开阔方正，后庭幽深曲折，一厅之内兼得两种截然不同的空间感受，体现了苏州园林"厅堂居中、左右分流"的布局智慧。 The Main Hall, also named Shequ Hall, is the core building of Couple''s Garden Retreat''s residential area, spanning three bays with grand proportions—the principal venue for formal ceremonies and guest reception. "Shequ" derives from Tao Yuanming''s phrase "delving into delights as one goes," meaning following one''s interests and pleasures in exploration and experience—this is precisely the core philosophy of Couple''s Garden Retreat''s entire design: seeking not grand spectacle but rather abundant delight. The interior furnishings are dignified and elegant, with nanmu furniture complemented by paintings and calligraphy by renowned artists; the hall plaque "Shequ Hall" was inscribed by a prominent figure of the era. Courtyards exist both before and behind the hall—the front courtyard is open and square, the rear courtyard secluded and winding—within one hall, two entirely distinct spatial experiences are obtained, reflecting the Suzhou garden layout wisdom of "hall at center, divergent paths on either side."</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_ou_garden_sa_04', 'suzhou_ou_garden', 'Upper Hall (Residence Tower)', '楼厅（寝居楼）', '<p>Description： 楼厅又称寝居楼，位于藕园住宅区后部，是一座二层楼阁式建筑。楼下为日常起居空间，设有客堂与书房；楼上为私密寝居之所，是园主及家人的私人生活区域。楼厅建筑尺度较大厅略小，装饰更为温馨雅致，体现从公共礼仪空间到私人生活空间的过渡。楼厅后窗可望花园中假山与荷池景色，前窗可赏庭院花木，是宅与园交融的典型节点——居者在楼中即可感受到园林之美，无需刻意出游。这种"居即是游、游即是居"的生活方式，正是苏州宅园合一文化的精髓所在。 The Upper Hall, also called Residence Tower, lies at the rear of Couple''s Garden Retreat''s residential area—a two-story tower-style structure. The lower floor serves as daily living space with a reception room and study; the upper floor is the private sleeping quarters of the garden owner and family. The building''s scale is slightly smaller than the Main Hall, with warmer, more refined decorations, reflecting the transition from public ceremonial space to private living space. Rear windows overlook the garden''s rockery and lotus pool; front windows enjoy courtyard flowers and trees—it is a typical node where residence and garden intermingle. Occupants can experience garden beauty from within the tower without deliberately stepping out. This lifestyle of "living is touring, touring is living" embodies the essence of Suzhou''s integrated residence-garden culture.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_ou_garden_sa_05', 'suzhou_ou_garden', 'Study (Hanrui Study)', '书房（含蕊书斋）', '<p>Description： 含蕊书斋是藕园中园主专属的读书静修之所，位于住宅区与花园区的交界地带，是一处环境幽静、陈设雅致的小型书斋。"含蕊"意为花苞内蕴、蓄而未放，喻指文人涵养才学、静待时机的修养之道，与藕园整体"含蓄内敛"的气质高度契合。书斋面朝花园一侧，窗外可见假山翠竹，室内藏书丰盈，案头笔墨齐备，营造了一个沉浸式阅读与冥思的理想环境。此处是园主沈秉成夫妇吟诗作画、品茗论学的日常空间，也是藕园作为"夫妻同隐"园林的精神象征之一——在书斋中，两人共享读书之乐，琴瑟和鸣。 Hanrui Study is the garden owner''s dedicated space for quiet study and contemplation in Couple''s Garden Retreat, situated at the junction between the residential area and the garden area—a small study with a serene environment and elegant furnishings. "Hanrui" means containing flower buds—potential within, yet unreleased—metaphorically referring to the literati practice of nurturing talent and awaiting the right moment, highly congruent with Couple''s Garden Retreat''s overall "reserved and understated" temperament. The study faces the garden side; beyond the windows, rockery and green bamboo are visible. Inside, the book collection is plentiful and writing materials are complete, creating an immersive ideal environment for reading and meditation. This was the daily space where garden owners Shen Bingcheng and his wife composed poetry, painted, sipped tea, and discussed scholarship—also one of the spiritual symbols of Couple''s Garden Retreat as a "couple''s shared reclusion" garden. In the study, the two shared the joy of reading in harmonious companionship.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_ou_garden_sa_06', 'suzhou_ou_garden', 'Entertainment Hall (Tinglu Hall)', '戏厅（听橹厅）', '<p>Description： 听橹厅是藕园中极具生活气息与诗意想象的建筑空间。"听橹"之名源于藕园独特的地理环境——园东侧紧临苏州古城内城河，坐在厅中可闻河上船只桨橹划水之声，故以"听橹"为名。此厅是园主夫妇听曲赏戏、宴饮娱乐的场所，因此又称"戏厅"。厅内空间开阔，可容纳小型演出与雅集活动，临河一侧设有敞窗，将水巷的声景引入室内，形成"声景入室"的独特体验。苏州是水城，桨橹之声是其城市声音的标志，听橹厅以听觉为造景手段，将城市外部的生活节奏融入园林内部的静谧空间，是苏州园林中极为少见的"以声构景"的设计范例。 Tinglu Hall is a building space in Couple''s Garden Retreat rich in both everyday vitality and poetic imagination. "Tinglu" (listening to oars) derives from the garden''s unique geographical setting—the east side borders Suzhou''s ancient inner-city canal; sitting in the hall, one can hear the sound of boat sculls paddling through the water, hence the name. This hall served as the venue for the garden owner and his wife to enjoy music and performances, host banquets, and entertain guests—thus also called the Entertainment Hall. The interior is spacious enough for small performances and elegant gatherings. On the canal side, open windows bring the waterway''s sonic landscape indoors, forming a unique "sound scenery entering the room" experience. Suzhou is a water city; oar sounds are its urban auditory signature. Tinglu Hall employs hearing as a landscape design medium, integrating the city''s external living rhythm into the garden''s interior tranquility—a rare example of "constructing scenery through sound" in Suzhou gardens.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_ou_garden_sa_07', 'suzhou_ou_garden', 'Lotus Pond', '荷花池', '<p>Description： 荷花池是藕园花园区最核心的水景空间，也是全园视觉与生态的中心。池名直白而诗意——"藕"即荷根，藕园之名本就与荷花密切相关，荷花池正是这一命名的实景来源。池中遍植荷花，夏日莲叶接天、花红映日，清香远溢，与园名呼应成趣。池岸曲折有致，沿池设廊桥与亭榭，水面映照假山、亭阁与天光云影，虚实交织如画。荷花在中国文化中象征高洁清廉，藕园以荷为主题，既是景观选择，更是精神寄托——园主沈秉成夫妇以荷喻德，寓隐逸清廉之志于山水花木之间。 The Lotus Pond is the core water feature space in Couple''s Garden Retreat''s garden area, and the visual and ecological center of the entire garden. The name is straightforward yet poetic—"ou" means lotus root; Couple''s Garden Retreat''s name itself is closely connected to the lotus, and the Lotus Pond is the living scenic source of this naming. Lotuses are planted throughout the pond; in summer, lotus leaves stretch to the horizon, red blossoms reflect the sun, and pure fragrance drifts far—harmonizing with the garden''s name. The pond''s banks wind with deliberate irregularity; corridors, bridges, and pavilions line the water, the surface reflecting rockery, pavilions, skylight, and cloud shadows—real and virtual interwoven like a painting. In Chinese culture, the lotus symbolizes purity and integrity. Couple''s Garden Retreat''s lotus theme is both a scenic choice and a spiritual commitment—the garden owners Shen Bingcheng and his wife used the lotus as a moral metaphor, embedding their aspirations for reclusive integrity among mountains, waters, flowers, and trees.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_ou_garden_sa_08', 'suzhou_ou_garden', 'Rockery', '假山', '<p>Description： 藕园假山是花园区的立体景观核心，位于荷花池东侧，以太湖石堆叠而成，山体高低错落，路径曲折幽深，构成一处可游可赏的立体山水画卷。假山虽为人工营造，却追求"虽由人作、宛自天开"的自然意境——石峰嶙峋有姿，洞穴深邃有趣，石径蜿蜒如真山溪涧。假山顶部设有观景平台，登临可俯瞰荷花池全景与园中亭廊，远眺城墙外姑苏城廓。假山底部设有石洞与石室，夏日入内清凉宜人，是避暑赏景的绝佳去处。藕园假山虽规模不及狮子林之宏大，却以精致含蓄见长，与周围的池水亭廊构成"山环水绕"的经典格局。 The Rockery is the three-dimensional landscape centerpiece of the garden area, located east of the Lotus Pond, constructed from Taihu stones. The mountain body rises and falls in staggered layers, with winding, deep paths forming a three-dimensional landscape scroll that is both explorable and visually appreciable. Though artificially constructed, the rockery pursues the natural ideal of "crafted by humans yet appearing as if created by nature"—stone peaks are rugged and graceful, caves are deep and intriguing, stone paths wind like real mountain stream courses. An observation platform atop the rockery offers panoramic views of the Lotus Pond and garden pavilions, with distant views of Suzhou''s cityscape beyond the walls. Stone caves and chambers beneath provide cool respite in summer—an ideal spot for escaping heat while enjoying scenery. Though not as grandly scaled as Lion Grove Garden''s rockery, Couple''s Garden Retreat''s rockery excels in refinement and subtlety, forming a classic "mountains encircling, waters surrounding" layout with the adjacent pond and pavilions.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_ou_garden_sa_09', 'suzhou_ou_garden', 'Hexagonal Pavilion (Ouxiang Pavilion)', '六角亭（藕香亭）', '<p>Description： 藕香亭是藕园花园区中一座临水而建的六角形亭子，位于荷花池北侧，与假山隔池相望。亭名"藕香"直指其最大特色——每逢夏日荷花盛开，微风送来荷香，满亭馥郁，坐于亭中赏荷闻香，是藕园中最具感官诗意体验的空间。六角亭形制轻盈雅致，六面开窗，视野通透，四面景致皆可入目：南望荷花池面，东观假山巍峨，西览回廊曲折，北眺城墙古貌。亭中石桌石凳可供休憩品茗，是游人驻足小坐、沉浸园景的理想场所。藕香亭与藕园之名的呼应关系最为直接——"藕"与"荷"同源，"香"是荷之精髓，亭名与园名互为注解，堪称藕园的点题之作。 Ouxiang Pavilion is a hexagonal waterside pavilion in Couple''s Garden Retreat''s garden area, situated north of the Lotus Pond and facing the rockery across the water. The name "Ouxiang" (lotus root fragrance) directly highlights its defining feature—when lotus flowers bloom in summer, breezes carry their fragrance into the pavilion; sitting within to admire lotuses and inhale their scent constitutes the garden''s most poetically sensory experience. The hexagonal pavilion''s form is light and elegant, with open views on all six sides—every direction offers scenic entry: southward across the Lotus Pond, eastward to the majestic rockery, westward along winding corridors, northward toward the ancient city wall. Stone table and benches provide resting and tea-sipping spots—an ideal place for visitors to pause and immerse in garden scenery. Ouxiang Pavilion resonates most directly with the garden''s name—"ou" and "he" (lotus) share the same origin, "xiang" (fragrance) is the lotus''s essence—the pavilion name annotates the garden name, making it the garden''s signature thematic work.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_ou_garden_sa_10', 'suzhou_ou_garden', 'Winding Corridor', '回廊', '<p>Description： 回廊是藕园花园区中串联各景点的重要建筑元素，沿荷花池岸蜿蜒延伸，将亭、台、楼、阁与假山、池水有机连接为一座完整的观景序列。廊道宽度适中，一侧临水、一侧倚墙或花木，形成"左水右墙"或"左景右景"的双面观景格局，每一步都带来不同的视觉体验——这正是苏州园林"步移景换"原则的最佳实践。回廊屋顶采用苏州传统廊亭做法，梁柱简洁，檐角轻翘，廊中每隔数步便开一扇漏窗，窗形各异——圆形、方形、梅花形、扇形——透过漏窗可见不同角度的池景山色，使廊道本身也成为一件流动的观赏艺术品。回廊不仅是交通路径，更是一条精心编排的"视觉叙事线"，引导游人按设计节奏逐一体验园中各景。 The Winding Corridor is an essential architectural element threading together all scenic points in Couple''s Garden Retreat''s garden area, winding along the Lotus Pond''s edge, organically linking pavilions, terraces, towers, and halls with rockery and water into a complete observation sequence. The corridor is proportionately wide, with water on one side and walls or plantings on the other, forming a dual-view layout of "water on one side, wall on the other" or "scenes on both sides"—every step brings a different visual experience, representing the best practice of Suzhou garden''s "shifting views with each step" principle. The corridor roof follows Suzhou''s traditional corridor-pavilion construction: simple beams and columns, lightly sweeping eave corners. Every few steps, a pierced window opens—each uniquely shaped: round, square, plum blossom, or fan—through which different angles of pond and rockery scenes appear, making the corridor itself a flowing visual artwork. The corridor is not merely a traffic route but a carefully choreographed "visual narrative thread," guiding visitors to experience each garden scene in a designed rhythm.</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_yi_garden_sa_01', 'suzhou_yi_garden', 'Entrance Gate', '入口宅门', '<p>Description： 艺圃的入口并非气派张扬，而是隐匿于文衙弄这条狭窄幽深的弄堂深处，需穿过曲折的巷道方能抵达。这种"大隐隐于市"的布局方式，正是苏州文人园林典型的含蓄表达。宅门为传统的石库门式样，青砖灰瓦，门楣低调，与两侧民居几乎无异，初来者往往难以察觉此处藏有一座世界遗产级园林。推门而入，方觉别有洞天，市井喧嚣瞬间隔绝于外。这种从喧嚣到静谧的空间转换，是艺圃给予访客的第一重惊喜。 The entrance to Yipu Garden is deliberately inconspicuous, tucked away at the far end of Wenya Lane — a narrow, winding alleyway in Suzhou''s old city. This "hidden within the city" approach is characteristic of Suzhou''s literati gardens, which favor understatement over grandeur. The gate itself is a traditional stone-framed doorway with grey brick and dark tiles, virtually indistinguishable from neighboring residences. First-time visitors can easily walk past without realizing that a UNESCO World Heritage garden lies within. Stepping through the gate, the noise of the city falls away instantly, replaced by a serene courtyard — a spatial transition from bustle to tranquility that is Yipu''s first gift to every guest.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_yi_garden_sa_02', 'suzhou_yi_garden', 'Shilun Hall', '世纶堂', '<p>Description： 世纶堂是艺圃中路建筑序列的第一进正厅，坐北朝南，面阔三间，建筑风格朴素端方，不施彩绘，保留了明代建筑的典型特征。堂名"世纶"二字取自"世事经纶"，寓意主人经纶世务、兼济天下的志向。堂前有石板天井，植有古树一株，枝叶扶疏，光影斑驳，与粉墙黛瓦相映成趣。堂内原悬有匾额，为历代园主会客、品茗、论学之所。此处建筑尺度亲切可人，没有官式园林的森严气势，反而透出一种文人居所的温雅气息，体现了明代苏州文人士大夫"不求宏丽，但求雅洁"的审美追求。 Shilun Hall is the first main hall along Yipu Garden''s central axis, facing south with three bays. Its architectural style is plain and dignified — no painted beams, no gilded columns — preserving the hallmark simplicity of Ming Dynasty construction. The name "Shilun" derives from "经纶世务," reflecting the owner''s aspiration to engage meaningfully with worldly affairs. A stone-paved courtyard precedes the hall, graced by an old tree whose dappled shade plays against whitewashed walls and dark tiles. Originally adorned with calligraphic plaques, the hall served as a gathering place for receiving guests, sipping tea, and scholarly discussion. The intimate scale and absence of ostentation embody the Ming-era literati ideal: "seek not grandeur, but refinement and cleanliness."</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_yi_garden_sa_03', 'suzhou_yi_garden', 'Donglai Thatched Cottage', '东莱草堂', '<p>Description： 东莱草堂位于世纶堂之后，是艺圃中路建筑群中的第二进。草堂之名"东莱"暗含故土之思，相传与园主的籍贯或先祖渊源有关，而"草堂"二字则是中国文人常用的自谦之语，意在表达归隐田园、不慕荣利的心志。堂内陈设简朴，几案文房井然有序，窗棂透光，竹影摇曳，营造出一种清幽恬淡的读书环境。此处是园主日常读书、会友、吟诗之所，也是体验苏州文人园林"小中见大"造园手法的重要节点。从草堂推窗而望，可见园中水池假山，绿意盎然，仿佛将整座园林的精华尽收眼底。 Situated behind Shilun Hall, Donglai Thatched Cottage is the second building along the garden''s central axis. The name "Donglai" is believed to reference the garden owner''s ancestral homeland, carrying a note of nostalgia, while "thatched cottage" (草堂) is a humble term Chinese scholars have long favored to signal a life of reclusion, free from worldly ambition. The interior is simply furnished — a writing desk, calligraphy brushes, and inkstones neatly arranged. Light filters through latticed windows where bamboo shadows sway, creating a serene reading environment. This is where the garden owner spent his days reading, entertaining close friends, and composing poetry. From the cottage window, the central pond and rockery unfold in full view — a perfect demonstration of the Suzhou gardening principle of "seeing the universe within a small space."</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_yi_garden_sa_04', 'suzhou_yi_garden', 'Sishi Pavilion', '思嗜轩', '<p>Description： 思嗜轩位于艺圃水池南侧，是一座体量精巧的临水建筑。"思嗜"二字，意为思其所嗜、念其所爱，透露出园主对某种生活方式或精神追求的执着与深情。轩前临水，视野开阔，可以远眺池北的延光阁和假山亭台，是园中观景的绝佳位置之一。轩内仅设一几一椅，简素至极，却恰合文人独坐沉思之意境。每当清晨薄雾弥漫池面，或黄昏斜阳映照粉墙，此处便成为园中最富诗意的角落。园主于此煮一壶清茶，展一卷古籍，听池中鱼跃，看庭前花开花落，将文人生活之美演绎到了极致。 Sishi Pavilion sits on the southern bank of Yipu''s central pond — a delicately proportioned waterside structure. The name "Sishi" means "to reflect upon one''s passions and loves," revealing the garden owner''s devotion to a particular way of life and spiritual pursuit. The pavilion opens directly onto the water, offering sweeping views of Yanguang Pavilion, rockeries, and waterside towers to the north — making it one of the finest vantage points in the garden. Inside, a single table and chair suffice; the minimalism perfectly suits the literati ideal of solitary contemplation. On misty mornings or golden-hour evenings, when warm light bathes the whitewashed walls, this corner becomes the most poetic spot in the entire garden — a place to brew tea, open a book, listen to leaping fish, and watch blossoms unfold and fall.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_yi_garden_sa_05', 'suzhou_yi_garden', 'Ruyu Pool', '乳鱼池', '<p>Description： 乳鱼池是艺圃全园的核心水景，位于园林中部，面积约一亩有余，虽不大却层次丰富。池名"乳鱼"二字颇具诗意，取自古诗"乳鱼如冻痕，池面生微澜"之句，描绘小鱼如初凝之冰痕般在水面上微微游动的灵动景象。池水清澈，中有锦鲤悠然游弋，池岸曲折自然，以黄石叠砌驳岸，古朴天成。池的南岸有思嗜轩临水而立，北岸则有延光阁横卧水面，东西两侧假山亭台高低错落，形成"以水为中心，建筑环绕"的经典园林格局。站在池边，可见天光云影倒映水中，虚实相生，令人顿忘尘世纷扰。 Ruyu Pool is the heart of Yipu Garden''s landscape — a central pond of just over one mu (roughly 670 square meters) that, though modest in size, offers richly layered views. The name "Ruyu" (literally "nursling fish") is poetically drawn from a classical verse describing tiny fish moving across the water''s surface like freshly formed ice marks — a delicate, almost imperceptible animation. The water is clear, with koi gliding lazily beneath the surface. The pond''s irregular shoreline is edged with yellow stones laid in a naturalistic style. To the south, Sishi Pavilion rises at the water''s edge; to the north, Yanguang Pavilion stretches along the shore; rockeries and towers frame the east and west — together forming the classic garden layout of "water at the center, architecture encircling." Standing at the pond''s edge, sky and clouds reflect in the water, dissolving the boundary between reality and reflection, and the world beyond seems to vanish.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_yi_garden_sa_06', 'suzhou_yi_garden', 'Yanguang Pavilion', '延光阁', '<p>Description： 延光阁是艺圃最具代表性的建筑，坐落于乳鱼池北岸，面阔五间，单檐歇山造，是苏州古典园林中体量最大的水榭之一。"延光"二字意为延揽光影、纳景入室，阁名恰如其分——整座建筑三面临水，南向无墙，设长窗槅扇，全部敞开时，池光山色尽收眼底，仿佛将整个园景延揽入怀。阁内方砖铺地，陈设清雅，现为游客品茗休憩之所。坐在阁中饮一盏碧螺春，看池中倒影随微风轻颤，听檐下滴雨叮咚，方知古人"室雅何须大"的真意。延光阁也是观赏园中四季变化的最佳位置：春看新绿，夏赏荷风，秋观红叶，冬听雪落，四时之景不同而皆妙。 Yanguang Pavilion is Yipu Garden''s most iconic structure, perched on the northern shore of Ruyu Pool. Five bays wide with a single-eave gable roof, it is one of the largest waterside pavilions in all of Suzhou''s classical gardens. The name "Yanguang" means "extending light" — drawing sunlight and scenery into the interior. True to its name, the building opens on three sides to the water, with latticed windows on the south facade that, when fully opened, frame the entire garden panorama as if the whole landscape were gathered into one''s embrace. The interior is paved with square tiles and simply furnished; today it serves as a tea room where visitors can rest and sip tea. Seated inside with a cup of Biluochun green tea, watching the pond''s reflections tremble in the breeze and listening to raindrops tap the eaves, one truly understands the ancient wisdom that "a room need not be grand to be elegant." Yanguang Pavilion is also the finest vantage point for the garden''s seasonal pageant: tender green in spring, lotus breezes in summer, crimson leaves in autumn, and silent snow in winter.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_yi_garden_sa_07', 'suzhou_yi_garden', 'Chaoshuang Pavilion', '朝爽亭', '<p>Description： 朝爽亭坐落于艺圃水池东侧假山的最高处，是一座平面呈方形的敞亭。"朝爽"二字取自南朝宋刘义庆"朝来爽气"之语，意指清晨山间清新爽朗之气，亭名点明了此处登高远眺、吸纳山岚清风的意境。亭虽不大，却因位于假山之巅而成为全园的制高点。沿石阶曲折而上，至亭中小憩，放眼四望，园中水池、建筑、花木尽收眼底，构成一幅"以小见大"的立体山水画卷。亭柱有联，亭顶简洁，不加藻饰，与全园古朴统一的风格相谐。登亭的最佳时辰是清晨与黄昏：清晨薄雾未散，园景若隐若现，如水墨晕染；黄昏夕照，金光铺洒水面，古亭剪影如画。 Chaoshuang Pavilion crowns the summit of the rockery on the eastern side of Ruyu Pool — a small, open-sided square pavilion. The name "Chaoshuang" is drawn from a classical phrase meaning "the crisp, refreshing air that comes with morning," signaling that this is the place to ascend, gaze afar, and breathe in the pure mountain-like breeze. Though modest in size, the pavilion is the highest point in the garden. Ascending the winding stone steps and pausing at the top, visitors enjoy a sweeping panorama: the pond, architecture, and plantings of the entire garden spread below like a three-dimensional landscape painting — a masterful demonstration of "seeing the vast within the small." A couplet hangs on the pavilion columns; the roof is simple and unornamented, in keeping with the garden''s unified aesthetic of restrained antiquity. The finest moments to climb are at dawn and dusk: in the early morning, mist clings to the garden like ink wash on paper; at sunset, golden light carpets the water and the pavilion''s silhouette turns into a painting.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_yi_garden_sa_08', 'suzhou_yi_garden', 'Bilang Pavilion', '碧浪亭', '<p>Description： 碧浪亭位于艺圃水池东南角，是一座六角形的临水小亭，体量纤巧，比例优美。"碧浪"二字描绘池水在微风拂动下泛起的碧绿波纹，亭名本身即是一幅动态画面。亭子三面环水，一面接岸，立于亭中，低头可见池水清浅，鱼戏莲叶之间；抬头可望延光阁飞檐与朝爽亭高踞假山之巅，远近高低，层次分明。亭畔植有数株古树，枝叶垂入水面，随风轻拂，与水中倒影相映成趣。此处是园中最适合"闲坐"的角落——不急于赶路，不忙于拍照，只是安静地坐着，感受清风拂面、鸟鸣入耳，体会苏州园林"可游可居亦可坐"的完整生活美学。 Bilang Pavilion occupies the southeastern corner of Ruyu Pool — a slender hexagonal structure with gracefully proportioned eaves. The name "Bilang" (literally "emerald waves") evokes the green ripples that shimmer across the pond when a breeze passes over, so that the pavilion''s name is itself a living picture. Three sides of the pavilion face the water; the fourth connects to the shore. Standing inside, one can look down to see the clear, shallow pond and fish darting among lotus leaves; looking up, Yanguang Pavilion''s flying eaves and Chaoshuang Pavilion atop the rockery create a layered composition of near and far, high and low. Old trees grow beside the pavilion, their branches dipping into the water, swaying gently, mirrored in the pond below. This is the garden''s best spot for simply "sitting still" — not rushing to the next site, not fumbling with a camera, just quietly feeling the breeze and listening to birdsong, experiencing the complete aesthetic of Suzhou gardens where one can roam, dwell, and sit in equal measure.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_yi_garden_sa_09', 'suzhou_yi_garden', 'Qinlu', '芹庐', '<p>Description： 芹庐位于艺圃西部，是一座独立于主景区之外的小型院落，需经过曲折的廊道才能进入，是全园最为幽静隐秘的角落。"芹"字取自《诗经·鲁颂》"思乐泮水，薄采其芹"，芹为水边野菜，古人常以"献芹"作为自谦之语，意指所献之物虽微薄，却出于真心。以此为名，彰显了园主安于清贫、以素为美的精神品格。院中植有数竿修竹、一株古梅，粉墙前设石笋一二，构成一幅天然的文人画。院落虽小，却"芥子纳须弥"，方寸之间见天地。此处是园主读书静修之所，远离主景区的游人流连，至今仍保留着最纯粹的古朴气息。 Qinlu Hermitage lies in the western section of Yipu Garden — a small courtyard set apart from the main scenic area, accessible only through a winding corridor, making it the most secluded corner of the entire garden. The character "芹" (celery/water dropwort) comes from the Book of Odes: "By the joyful waters of Pan, I gather the water celery." Since ancient times, "offering celery" has been a scholar''s humble metaphor — the gift may be meager, but the sincerity is genuine. Naming this retreat "Qinlu" reveals the garden owner''s contentment with simplicity and his celebration of the unadorned. Within the courtyard stand a few stalks of bamboo, an old plum tree, and one or two scholar''s rocks set against whitewashed walls — a natural literati painting. Though tiny, the courtyard embodies the Buddhist principle of "a mustard seed holding Mount Sumeru" — the universe within a square inch. This was the owner''s retreat for reading and meditation, and even today, far from the flow of visitors in the main garden, it retains the purest breath of antiquity.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_yi_garden_sa_10', 'suzhou_yi_garden', 'Boya Hall', '博雅堂', '<p>Description： 博雅堂位于艺圃北部建筑群落的末端，是全园最深处的正厅。"博雅"二字取"博学于文，雅正于心"之意，体现了园主追求博学精深、品行端正的儒家理想。堂前有院，植有芭蕉、天竹等植物，四季各有姿色。堂内宽敞明亮，原为园主收藏古籍、书画、金石之所，也是与文友雅集、品鉴古物的重要场所。建筑风格延续了全园的朴素质朴，梁柱不施彩绘，墙面以白灰粉刷，地面铺方砖，仅以木质的自然纹理和简洁的线条取胜。博雅堂作为游览路线的终点，恰如一部好书的尾声——回望来路，池水亭台、假山花木依次浮现，令人回味悠长，对艺圃这座"小园极则"生出更深的敬意。 Boya Hall stands at the far northern end of Yipu Garden''s architectural sequence — the deepest hall in the entire compound. The name "Boya" means "broadly learned and upright in heart," reflecting the Confucian ideal of scholarly depth paired with moral integrity. A courtyard precedes the hall, planted with banana palms and heavenly bamboo that change character with each season. The interior is spacious and bright; it originally housed the owner''s collection of rare books, calligraphy, paintings, and bronze-and-stone antiquities, and served as a venue for scholarly gatherings and the connoisseurship of art. The architectural style continues the garden''s signature plainness — unpainted beams, whitewashed walls, square-tile floors — relying on the natural grain of the wood and the purity of line for its quiet authority. As the final stop on the visitor''s route, Boya Hall serves as the coda to a well-crafted book: looking back along the path just walked, the pond, pavilions, rockeries, and flora rise in sequence, leaving a lingering aftertaste and a deepened reverence for this "ultimate expression of the small garden."</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_museum_sa_01', 'suzhou_museum', 'Entrance Hall', '入口大厅', '<p>Description： 入口大厅是苏州博物馆新馆的迎宾空间，由世界著名建筑大师贝聿铭精心设计。大厅以简洁的几何线条与大面积玻璃幕墙营造出明亮通透的空间感，自然光线透过顶部天窗洒落，在白墙灰檐之间形成丰富的光影变幻。大厅内设有导览台与多媒体展示屏，为游客提供全方位的参观指引。从大厅望去，已可窥见主庭院的片石假山，一段跨越古今的美学对话由此展开。 The Entrance Hall serves as the welcoming space of Suzhou Museum''s new wing, masterfully designed by the world-renowned architect I.M. Pei. Clean geometric lines and expansive glass walls create a luminous, airy atmosphere, while natural light streaming through skylights casts shifting shadows across white walls and gray eaves. A guide desk and multimedia displays provide comprehensive visitor information. From the hall, glimpses of the rockery in the main courtyard already reveal a dialogue between ancient and modern aesthetics.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_museum_sa_02', 'suzhou_museum', 'Wu Region Heritage Gallery', '吴地遗珍展厅', '<p>Description： 吴地遗珍展厅汇集了苏州地区历年考古发掘的重要文物，从商周青铜器到春秋玉器，从汉代陶俑到六朝青瓷，系统呈现了吴地文明的演进脉络。展厅以"吴地之源""吴地之器""吴地之韵"三大主题串联叙事，让观众在一件件器物中感受苏州自远古以来的人文积淀。其中，青铜剑与原始瓷罐等藏品尤为珍贵，印证了吴地先民在冶炼与制瓷领域的卓越技艺，是理解江南文化根基的必赏之地。 The Wu Region Heritage Gallery brings together important archaeological finds from Suzhou, ranging from Shang-Zhou bronze wares to Spring-and-Autumn jade pieces, from Han dynasty pottery figurines to Six Dynasties celadon. Three thematic sections — "Origins of Wu," "Artifacts of Wu," and "Spirit of Wu" — weave a continuous narrative, allowing visitors to experience Suzhou''s deep cultural accumulation through individual objects. Bronze swords and primitive porcelain jars are especially prized, testifying to the extraordinary metallurgical and ceramic skills of Wu''s early inhabitants. This gallery is essential for understanding the roots of Jiangnan culture.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_museum_sa_03', 'suzhou_museum', 'Wu Pagoda National Treasures Gallery', '吴塔国宝展厅', '<p>Description： 吴塔国宝展厅是苏州博物馆最引人瞩目的展厅之一，集中展示了从虎丘云岩寺塔和瑞光塔中发现的国宝级文物。虎丘塔出土的越窑秘色瓷莲花碗，釉色青翠如湖水，被公认为晚唐五代秘色瓷的巅峰之作；瑞光塔发现的真珠舍利宝幢，以珍珠、宝石、檀木精雕而成，工艺之精巧令世人惊叹。这些文物不仅展现了吴地佛教文化的深厚底蕴，更代表了宋代以前苏州手工艺的极致水准，是来苏州博物馆不可错过的核心看点。 The Wu Pagoda National Treasures Gallery is one of the museum''s most compelling spaces, concentrating national-treasure-grade artifacts discovered inside Huqiu Yunyan Temple Pagoda and Ruiguang Pagoda. The Yue kiln mise (secret-color) porcelain lotus bowl from Huqiu, its glaze as green as lake water, is widely acknowledged as the pinnacle of late Tang–Five Dynasties secret-color porcelain. The Pearl Relic Stupa from Ruiguang Pagoda, intricately carved from pearls, gems, and sandalwood, astonishes the world with its craftsmanship. These relics not only reveal the depth of Wu''s Buddhist culture but also represent the zenith of Suzhou craftsmanship before the Song dynasty — an unmissable highlight of any visit.</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_museum_sa_04', 'suzhou_museum', 'Wu Elegance Gallery', '吴中风雅展厅', '<p>Description： 吴中风雅展厅以宋代至明清为时间轴，通过文房用品、茶器、香具、古琴等实物，生动再现了苏州文人阶层"雅"的生活方式。展厅从"书斋清供""茶禅一味""琴棋书画"等角度切入，让观众窥见古代苏州士大夫如何在日常起居中追求精神的超脱与审美的极致。一件件精巧的砚台、温润的茶盏、素雅的香炉，诉说着吴地文人以器载道的文化理想。这里不仅展示了器物之美，更传递了一种延续千年的江南生活哲学。 The Wu Elegance Gallery follows a timeline from the Song dynasty to the Ming-Qing era, using studio implements, tea ware, incense sets, and guqin to vividly recreate the "ya" (refined) lifestyle of Suzhou''s literati class. Sections such as "Study Treasures," "Tea and Zen," and "Qin, Qi, Shu, Hua" allow visitors to glimpse how ancient Suzhou scholars pursued spiritual transcendence and aesthetic perfection in daily life. Each exquisite inkstone, warm tea cup, and understated incense burner speaks to the Wu literati''s ideal of embodying philosophy through objects. The gallery displays not only the beauty of artifacts but also a Jiangnan philosophy of life spanning a millennium.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_museum_sa_05', 'suzhou_museum', 'Wu School Calligraphy & Painting Gallery', '吴门书画展厅', '<p>Description： 吴门书画展厅是苏州博物馆最具艺术代表性的展厅之一，系统收藏与展示明代吴门画派的核心作品。沈周的浑厚苍润、文徵明的清雅工致、唐寅的潇洒灵动、仇英的精丽婉约——四大吴门名家风格各异而各臻其妙，共同构筑了明代文人画的巅峰格局。展厅还展出吴门书派的法书名帖，从祝允明的狂草到文徵明的小楷，笔锋之间尽显吴地文人的才情与风骨。定期轮换的专题展览使每次参观都有新的发现，是书画爱好者在苏州不可错过的殿堂。 The Wu School Calligraphy &amp; Painting Gallery is one of the museum''s most artistically significant spaces, systematically collecting and displaying core works of the Ming-dynasty Wu School. Shen Zhou''s robust and moist brushwork, Wen Zhengming''s refined precision, Tang Yin''s spirited fluidity, and Qiu Ying''s exquisite grace — the four Wu masters each achieved brilliance in their own style, collectively shaping the pinnacle of Ming literati painting. The gallery also features Wu School calligraphy, from Zhu Yunming''s wild cursive script to Wen Zhengming''s small regular script, revealing Wu literati''s talent and character in every stroke. Rotating thematic exhibitions ensure new discoveries on each visit — an essential destination for lovers of calligraphy and painting in Suzhou.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_museum_sa_06', 'suzhou_museum', 'Neolithic Jade Gallery', '新石器时代玉器展厅', '<p>Description： 新石器时代玉器展厅聚焦于太湖流域新石器时代尤其是良渚文化的玉器精品。玉璧、玉琮、玉钺、玉璜——这些器型承载着远古先民对天地的敬畏与对权力的象征，其表面精细的纹饰与打磨工艺令人叹服。展厅通过考古语境还原玉器的使用场景，让观众理解这些器物并非单纯的装饰品，而是沟通人神、标识等级的礼制重器。良渚玉琮上的神人兽面纹，更被认为是中华文明最早的神徽之一，对探索东亚文明起源具有不可替代的学术价值。 The Neolithic Jade Gallery focuses on jade treasures from the Neolithic period in the Lake Tai region, especially the Liangzhu culture. Jade bi discs, cong tubes, axe heads, and huang pendants — these forms carried ancient reverence for heaven and earth and symbolized authority; their finely incised patterns and polished surfaces are awe-inspiring. The gallery restores the archaeological context of these jades, helping visitors understand that they were not mere ornaments but ritual implements for communicating with deities and marking social rank. The god-and-animal mask motif on Liangzhu cong is considered one of the earliest divine emblems of Chinese civilization, holding irreplaceable academic value for exploring East Asian civilizational origins.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_museum_sa_07', 'suzhou_museum', 'Main Courtyard (Slice Rockery)', '主庭院（片石假山）', '<p>Description： 主庭院是苏州博物馆新馆最具标志性的空间，由贝聿铭先生亲自构思设计。庭院以白墙为画纸，以片石为笔墨，将米芾笔下"米氏云山"的水墨意境化为三维立体的山水画卷。灰色片石高低错落、层层叠置于白墙之前，宛如远山近峦在雾中隐现，打破了传统假山的堆叠手法，创造出前所未有的"以壁为纸、以石为绘"的现代园林美学。庭院中水面如镜，竹林疏影，与拙政园隔墙相望，新旧对话浑然天成，堪称贝聿铭留给苏州的永恒礼物。 The Main Courtyard is the most iconic space in Suzhou Museum''s new wing, conceived and designed by I.M. Pei himself. Using white walls as canvas and sliced rocks as brushstrokes, he transforms Mi Fu''s "Mi-style cloud mountains" from ink painting into a three-dimensional landscape. Gray rock slices, staggered and layered against white walls, appear like distant peaks emerging through mist, breaking from traditional rockery stacking to create an unprecedented "wall-as-canvas, stone-as-painting" modern garden aesthetic. The courtyard''s mirror-like water, sparse bamboo shadows, and views across the wall to the Humble Administrator''s Garden form a natural dialogue between old and new — I.M. Pei''s enduring gift to Suzhou.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_museum_sa_08', 'suzhou_museum', 'Wisteria Garden', '紫藤园', '<p>Description： 紫藤园位于新馆与忠王府之间的过渡地带，是苏州博物馆最富诗意的小型园林空间。园中紫藤的枝蔓源自忠王府内数百年古藤，贝聿铭先生亲手将忠王府的紫藤嫁接于此，让这株跨越时空的生命在新馆延续绽放。每年四月，紫藤花如瀑布倾泻而下，紫色花瓣在微风中摇曳生姿，与白墙灰瓦的建筑背景形成绝美的色彩对照。树下石径蜿蜒，光影斑驳，游客在此驻足片刻，便能感受到贝聿铭以植物为纽带的深层设计哲学——新与旧并非割裂，而是根脉相连。 The Wisteria Garden occupies the transitional zone between the new wing and the忠王府 (Loyal King''s Mansion), the museum''s most poetic small garden space. The wisteria vines originate from centuries-old stock inside the忠王府; I.M. Pei personally grafted them here, enabling this time-spanning life to continue blossoming in the new wing. Each April, wisteria cascades like a waterfall, purple petals swaying in the breeze against white walls and gray tiles in stunning color contrast. Stone paths wind beneath the canopy, light dappling through leaves — a moment''s pause here reveals Pei''s deeper design philosophy using plants as living links: new and old are not severed but share the same roots.</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_museum_sa_09', 'suzhou_museum', 'Tea Room', '茶室', '<p>Description： 苏州博物馆茶室位于新馆西侧，大面积落地玻璃窗直接面向主庭院的片石假山与水景，是馆内最令人心旷神怡的休憩之所。茶室以苏州碧螺春为主打茶品，辅以本地特色茶点，让游客在观展之余以一杯清茶放慢节奏。空间设计延续贝聿铭的极简美学，灰白色调搭配木质家具，窗外山水如画，窗内茶香氤氲，内外交融形成独特的禅意氛围。无论是午后小坐还是观展间隙的短暂歇息，茶室都提供了一种将博物馆体验延伸为感官享受的可能。 The Tea Room sits on the west side of the new wing, with expansive floor-to-ceiling glass directly facing the Main Courtyard''s slice-rock rockery and water feature — the museum''s most restorative retreat. Suzhou Biluochun is the signature brew, accompanied by local tea snacks, inviting visitors to slow their pace with a cup of clear tea after viewing exhibitions. The design extends Pei''s minimalist aesthetic: gray-white tones with wooden furniture, landscape paintings beyond the glass, tea mist within, merging into a distinctive Zen atmosphere. Whether for a leisurely afternoon sit or a brief inter-exhibition pause, the Tea Room transforms the museum visit into a sensory pleasure.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_museum_sa_10', 'suzhou_museum', 'Taiping Heavenly Kingdom忠王 (Loyal King) Mansion', '太平天国忠王府', '<p>Description： 忠王府是苏州博物馆的重要组成部分，原为太平天国忠王李秀成在苏州的府邸，建于1860年前后。这是国内保存最完整的太平天国历史建筑之一，苏式古典殿宇格局与太平天国时期特有的装饰风格并存，龙纹雕饰、彩绘壁画与太平天国铭刻共同构成独特的历史信息层。府内古典戏台为江南罕见的大型室内戏台，藻井雕花精美绝伦。忠王府与贝聿铭新馆相连，从古典殿宇步入现代空间，一步跨越百年，历史与当代的张力在此得到最生动的体现。 The忠王 Mansion is a core component of Suzhou Museum, originally the Suzhou residence of the Taiping Heavenly Kingdom''s Loyal King Li Xiucheng, built around 1860. It is one of the best-preserved Taiping historical buildings in China, where classical Suzhou palace layout coexists with distinctive Taiping decorative elements — dragon carvings, painted murals, and Taiping inscriptions forming unique layers of historical information. The indoor classical stage inside is a rare large-scale theater in Jiangnan, its caisson ceiling carved with breathtaking finesse. Connected to Pei''s new wing, stepping from the classical halls into the modern space crosses a century in a single stride, giving the tension between history and contemporary its most vivid expression.</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_huanxiu_mountain_villa_sa_01', 'suzhou_huanxiu_mountain_villa', 'Yougu Hall', '有穀堂', '<p>Description： 有穀堂位于环秀山庄入口轴线前端，是入园后的第一座厅堂建筑，承担着迎客与礼仪功能。堂名"有穀"出自《论语》，"穀"有善与禄二义，寓"多善多福"之吉意。建筑面阔三间，硬山顶，前后通透，南对入口庭院，北临园内主水面，是连接前后景区的过渡空间。堂内梁架用材考究，陈设简洁，正中悬有匾额。此堂虽体量不大，但轴线关系明确，与主假山遥相呼应，自堂内北望，戈裕良所叠假山赫然入目，形成"厅堂对山"的经典园林对景格局，奠定了全园的空间骨架。</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_huanxiu_mountain_villa_sa_02', 'suzhou_huanxiu_mountain_villa', 'Huanxiu Mountain Villa (Four-Side Hall)', '环秀山庄（四面厅）', '<p>Description： 四面厅位于环秀山庄主水面北侧，是全园的核心观景建筑。建筑面阔五间，四面环廊，各面均设长窗，可四面观景，故名"四面厅"。厅前临大水面，隔水正对戈裕良所叠主假山，是观赏假山全貌的最佳位置。四面厅体量在园内各建筑中最大，但比例匀称，尺度亲切，不显压抑。厅内原有"环秀山庄"匾额，园林即以此命名。此厅是全园视觉焦点与空间枢纽，北望假山主峰巍峨、洞壑幽深，东望边楼连廊，西望涵云阁高耸，南望水面倒影，四方景色尽收眼底，体现了苏州园林"厅堂为眼、四面皆景"的空间组织智慧。</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_huanxiu_mountain_villa_sa_03', 'suzhou_huanxiu_mountain_villa', 'Ge Yuliang Rockery', '戈裕良假山', '<p>Description： 戈裕良假山是环秀山庄的灵魂所在，由清代嘉庆年间叠山大师戈裕良所筑。假山占地不足半亩，主峰高逾七米，却营造出峰峦起伏、洞壑幽深、涧谷纵横的磅礴气象，被陈从周等园林学者推崇为"中国古典园林假山之冠"。戈裕良创造性地运用"大斧劈皴"叠石技法，以湖石叠出悬崖峭壁、石桥飞梁、深涧幽洞，山中有洞，洞中有桥，桥下有水，水绕山行，形成完整的山水循环。假山可游可居，沿石径盘旋而上可至主峰之巅俯瞰全园，入洞穿行可体验幽深莫测的空间变幻，是中国古典园林"可游可居"理念的最高体现，具有无与伦比的艺术与历史价值。</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_huanxiu_mountain_villa_sa_04', 'suzhou_huanxiu_mountain_villa', 'Hanyun Pavilion', '涵云阁', '<p>Description： 涵云阁位于环秀山庄西侧，是一座紧贴园墙而建的两层楼阁式建筑。阁名"涵云"，取"涵容云气"之意，暗喻其高耸入云的气势。建筑体量小巧而比例精到，下层以砖石为基，上层为木构，设槛窗可四面观景。涵云阁是全园的制高点，登临二层可从高处俯瞰戈裕良假山全貌，以"鸟瞰"视角欣赏假山的峰峦起伏与整体走势，与四面厅的"平视"视角形成互补。阁内空间虽小，但凭窗远眺，近观假山如真山在望，远借园外城市轮廓，收放之间尽显造园之巧。此阁亦是从侧面观察假山层次与叠石技法的最佳位置。</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_huanxiu_mountain_villa_sa_05', 'suzhou_huanxiu_mountain_villa', 'Side Building and Corridor', '边楼与边廊', '<p>Description： 边楼与边廊位于环秀山庄东侧，沿园墙纵向延伸，是连接园内各景区的交通纽带与景观廊道。边楼为两层，下层为廊，上层为楼，与边廊高低错落衔接，形成起伏有致的建筑组合。廊道曲折迂回，时而贴墙而行，时而转折开敞，随地形与景观变化而调整走向，体现了苏州园林"廊引人随、步移景异"的动线设计精髓。廊间设有漏窗与月洞门，框景取画，将假山、水面、花木等景观有节奏地呈现给游人，如同展开一幅山水长卷。边楼上层亦可居高俯瞰假山东侧面，是观察戈裕良叠石技法层次的重要视角，兼具交通与观景双重功能。</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_huanxiu_mountain_villa_sa_06', 'suzhou_huanxiu_mountain_villa', 'Wenquan Pavilion', '问泉亭', '<p>Description： 问泉亭位于环秀山庄内飞雪泉遗址附近，是一座临泉而筑的小型方亭，为观赏飞雪泉与周边山石水景的专属观景建筑。亭名"问泉"极富文人雅趣，"问"字将泉水拟人化，既含寻访之意，又带探究之心，寄寓园林主人对自然泉源的珍视与亲近之情。亭为四角攒尖顶，体量轻巧，四柱支撑，通透开敞，与周边假山石径浑然一体。立于亭中可近观飞雪泉出水口及泉池水石关系，听泉声潺潺，感受"问泉哪得清如许"的意境。亭周围湖石点缀，古木掩映，是园内最清幽的休憩观景处之一，也是理解环秀山庄"以泉引景、以水活园"造园手法的关键节点。</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_huanxiu_mountain_villa_sa_07', 'suzhou_huanxiu_mountain_villa', 'Buqiu Studio', '补秋舫', '<p>Description： 补秋舫位于环秀山庄假山东侧，是一座仿船形而建的旱船建筑，是苏州园林中常见的"旱船"式样的代表。建筑前部似船头，后部连廊如船尾，中部为舫舱，设槛窗可两面观景，整体造型如一艘停泊于山石之间的画舫。名"补秋"寓意在此可弥补秋日赏景之不足，寄寓园主对秋色之钟爱。舫前对假山东麓，秋日红枫与黄石假山相映成趣，色彩斑斓，正是"补秋"之意境所在。旱船建筑既满足了观景功能，又以"船"的意象增添了水意与遐想，使无水之处亦生舟行之趣，体现了苏州园林"以意代景、虚实相生"的高超造园手法，是山庄中最富浪漫意趣的建筑。</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_huanxiu_mountain_villa_sa_08', 'suzhou_huanxiu_mountain_villa', 'Bantan Qiushui Yifangshan Pavilion', '半潭秋水一房山亭', '<p>Description： 半潭秋水一房山亭位于环秀山庄主假山之巅，是全园海拔最高的观景小亭。亭名极富诗意，出自宋人诗句，"半潭秋水"指亭下所见半池碧水，"一房山"指亭周环立如房之假山，将亭所处位置与所对景致融为一体，意趣高妙。亭为六角小亭，体量极小，仅容数人，立于假山主峰之上，飞檐如翼，凌空欲飞。登亭须沿假山石径盘旋而上，路径陡峭幽深，至顶豁然开朗。立于亭中俯瞰，园内水面、假山、建筑尽收眼底，亭下潭水半湾，山石满目，恰如其名，是体验戈裕良假山"咫尺山林"意境的最高点，也是全园最具诗画意蕴的景点。</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_huanxiu_mountain_villa_sa_09', 'suzhou_huanxiu_mountain_villa', 'Feixue Spring Ruins', '飞雪泉遗址', '<p>Description： 飞雪泉遗址位于环秀山庄假山西南麓，是山庄历史上最重要的水景源头遗迹。飞雪泉曾以泉水喷涌如飞雪而得名，水质清冽，为园内假山涧水的主要水源，也是山庄得名的渊源之一。清代戈裕良叠山时充分利用此泉水源，引泉水入山涧，从假山顶部飞流而下，形成"山中有水、水中有山"的动态水景，使假山灵气十足。后世泉水枯竭，飞雪之势不再，但泉口周围叠石、泉池石壁及引水石槽等遗迹仍保存完好，游人可据此想象当年泉水飞溅、涧水潺潺的动人景象。遗址周边湖石嶙峋，古藤攀附，苍苔斑驳，别具一种荒凉古寂之美，是感受环秀山庄历史变迁与岁月沧桑的深沉之处。</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tuisi_garden_sa_01', 'suzhou_tuisi_garden', 'Entrance Gate', '入口宅门', '<p>Description： 入口宅门面向同里古镇街巷，为传统石库门样式，门楣上方有砖雕门额，题"退思园"三字。门楼采用水磨青砖砌筑，细缝密实，工艺精湛。与江南富商宅第的华丽门楼不同，退思园的宅门刻意追求朴素——这既与主人任兰生被革职回乡的身份相称，也暗合"退思补过"的谦逊意境。推门而入，迎面是一道屏风式院墙，将园内景致暂时遮掩，形成"欲扬先抑"的空间序列，引导访客从喧嚣街市渐入静谧的园林世界。 The entrance gate faces the lanes of Tongli Ancient Town in the traditional stone-arch style, with a brick-carved lintel inscribed "Tuisi Garden." The gatehouse is constructed of finely ground grey bricks with tight mortar joints, showcasing exceptional craftsmanship. Unlike the ornate gatehouses of wealthy merchants, Tuisi Garden''s entrance deliberately pursues simplicity—befitting Ren Lansheng''s status as a demoted official returning home, and echoing the humility inherent in the garden''s name. Upon entering, a screen wall temporarily conceals the garden''s scenery, creating a spatial sequence of "suppression before revelation" that guides visitors from the bustling streets into a tranquil world.</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tuisi_garden_sa_02', 'suzhou_tuisi_garden', 'Sedan Chair Hall', '轿厅', '<p>Description： 轿厅位于宅门与正厅之间，是传统江南宅第中不可或缺的礼仪性过渡空间。其名称源于此处最初用于停放轿子，客人到访后在此落轿、整衣、稍事休息，再由主人迎入正厅。厅堂面阔三间，梁架简洁，装饰朴素，地面铺设方砖。两侧原有木凳供随行人员歇息。轿厅虽不华丽，却承担着调节空间节奏的重要功能——从街市的喧闹到正厅的庄重，轿厅如同一道缓冲带，让访客在心理和视觉上做好准备，也体现了主宾之间的礼数与分寸。 The Sedan Chair Hall sits between the entrance gate and the main hall, an essential ceremonial transitional space in traditional Jiangnan residences. Its name derives from its original function of parking sedan chairs: arriving guests would dismount, tidy their attire, and rest briefly before being received into the main hall. The hall spans three bays with simple timber framing, modest decoration, and square-tile flooring. Wooden benches once lined both sides for attendants. Though unadorned, the Sedan Chair Hall plays a crucial role in modulating spatial rhythm—from the noise of the street to the formality of the main hall, it acts as a buffer, allowing visitors to prepare visually and psychologically, while embodying the etiquette governing host-guest relations.</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tuisi_garden_sa_03', 'suzhou_tuisi_garden', 'Main Hall (Yinyu Tang)', '正厅（荫余堂）', '<p>Description： 荫余堂为退思园正厅，是住宅部分最重要的礼仪空间。"荫余"二字取"荫庇子孙、余泽后世"之意，寄托了主人任兰生对家族绵延昌盛的期望。厅堂面阔三间，高敞明亮，梁柱用材考究，柱础为青石鼓镜式。正中悬挂"荫余堂"匾额，两侧有楹联。厅内陈设按传统格式布置——居中为长条案桌，两侧陈设太师椅与茶几，墙面悬挂书画。这里是主人接待重要宾客、举行家族议事、操办婚丧嫁娶的场所。厅前有院落，植有桂树与玉兰，取"金玉满堂"之意。 Yinyu Tang is the main hall of Tuisi Garden and the most important ceremonial space in the residential quarter. The name "Yinyu" means "to shelter descendants and leave a lasting legacy," expressing Ren Lansheng''s aspirations for his family''s enduring prosperity. The hall spans three bays with a high, bright interior, fine timber construction, and drum-shaped blue-stine plinths. A plaque inscribed "Yinyu Tang" hangs at the center, flanked by couplets. The interior follows traditional arrangement—a long narrow table at the center, armchairs and side tables on either side, with calligraphy and paintings on the walls. This was the venue for receiving distinguished guests, conducting family councils, and hosting weddings and funerals. The courtyard before the hall features osmanthus and magnolia, symbolizing "abundance of gold and jade."</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tuisi_garden_sa_04', 'suzhou_tuisi_garden', 'Inner Residence (Wanxiang Lou)', '内宅（畹芗楼）', '<p>Description： 畹芗楼位于正厅之后，是退思园住宅区的内宅部分，为主人及家眷的日常起居之所。"畹芗"二字意为"兰蕙之香"，取屈原《离骚》"余既滋兰之九畹兮"之意，暗喻主人品性高洁如兰。楼为两层建筑，楼下为日常起居与用餐之所，楼上为卧室。室内原有红木家具、雕花床榻及精美陈设。楼前有小天井，植兰草与芭蕉，环境清幽。内宅与外部厅堂之间以弄道和院墙分隔，形成了"前厅后堂、内外有别"的传统格局，既保证了家族生活的私密性，也体现了封建礼教下的空间秩序。 Wanxiang Lou is situated behind the main hall, serving as the inner residence where the owner and family conducted daily life. The name "Wanxiang" means "fragrance of orchids," alluding to Qu Yuan''s Li Sao: "I have nurtured orchids in nine fields," symbolizing the owner''s noble character. The two-story building has a ground floor for daily living and dining, with bedrooms upstairs. The interior once featured rosewood furniture, carved beds, and refined ornaments. A small courtyard before the building holds orchids and banana plants, creating a serene atmosphere. Narrow passageways and courtyard walls separate the inner residence from the public halls, forming the traditional layout of "front hall, rear quarters, inner and outer distinct," ensuring family privacy while reflecting the spatial hierarchy of Confucian propriety.</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tuisi_garden_sa_05', 'suzhou_tuisi_garden', 'Tuisi Thatched Hall', '退思草堂', '<p>Description： 退思草堂坐落于园林区中心位置，北面背靠院墙，南面临水，是全园的核心建筑。堂名直点园旨——"退思"二字既是园名，也是主人任兰生被革职后自省自勉的心境写照。草堂面阔三间，单檐歇山式屋顶，外观朴素，不施彩绘，以"草堂"名之更显隐逸意趣。堂前有宽敞平台，探出水面，是赏景的最佳位置。站于此处，园中水池、水香榭、闹红一舸、天桥等景致尽收眼底。室内陈设简洁，有书案、琴桌、太师椅，墙上悬挂书画。主人曾在此读书抚琴、会友品茗、静观四季变化。 Tuisi Thatched Hall occupies the central position of the garden section, backing against the compound wall to the north and facing the water to the south—the heart of the entire garden. The hall''s name directly expresses the garden''s theme: "Tuisi" (Retreat and Reflection) reflects both the garden''s name and the inner state of Ren Lansheng, who sought self-examination and self-improvement after his demotion. The hall spans three bays with a single-eave gable-and-hip roof and an unadorned exterior without painted decoration; calling it a "thatched hall" heightens the sense of reclusion. A spacious terrace before the hall projects over the water, offering the finest vantage point. From here, the pond, Shuixiang Pavilion, Red Boat, Sky Bridge, and other scenes unfold in a single panorama. The interior is simply furnished with a writing desk, zither table, and armchairs, with calligraphy and paintings on the walls. The owner once read, played the zither, entertained friends, savored tea, and observed the changing seasons here.</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tuisi_garden_sa_06', 'suzhou_tuisi_garden', 'Shuixiang Pavilion (Water Fragrance Pavilion)', '水香榭', '<p>Description： 水香榭位于退思园中心水池东南角，是一座半挑于水面之上的方形小筑。"水香"二字取意于夏日荷花盛开时水面飘来的清香。榭体轻盈，三面通透，仅一面设墙，上开六角形花窗。地面与水面几乎齐平，坐在榭中，仿佛凌波水上。此处是夏日赏荷的最佳位置——池中遍植荷花，盛夏时节碧叶连天、粉花映日，微风过处，荷香沁人。榭下水中锦鱼游弋，倒影如画。退思园以"贴水"著称，水香榭正是这一特色的集中体现：建筑与水的距离被压缩到极致，人与自然在此融为一体。 Shuixiang Pavilion stands at the southeast corner of Tuisi Garden''s central pond, a square structure half-cantilevered over the water. The name "Shuixiang" (Water Fragrance) evokes the scent of lotus blossoms drifting across the water in summer. The pavilion is light and airy, open on three sides with only one walled side featuring hexagonal latticed windows. The floor sits nearly flush with the water surface—seated inside, one feels suspended above the ripples. This is the finest spot for summer lotus viewing: the pond is planted with lotus, and in midsummer green leaves stretch to the horizon and pink blooms catch the sun, while a breeze carries the fragrance inward. Golden koi dart beneath, their reflections forming living pictures. Tuisi Garden is renowned for "hugging the water," and Shuixiang Pavilion embodies this feature at its purest—the distance between architecture and water reduced to a minimum, merging human and nature into one.</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tuisi_garden_sa_07', 'suzhou_tuisi_garden', 'Qin Room and Mianyun Pavilion', '琴房与眠云亭', '<p>Description： 琴房与眠云亭位于退思园西北角，是一组巧妙利用地形高差的建筑组合。琴房位于下层，是一间面水的小室，为主人抚琴品茗之所。室内幽静，隔水与退思草堂相对，琴声可借水面远传，余韵悠长。眠云亭则位于上层石台之上，需拾级而上。"眠云"二字取自古诗"卧看云起时"，意为在此小憩，如卧云端。亭体小巧，三面有墙，一面开窗，登亭可俯瞰全园。两座建筑一低一高、一临水一依山，形成了丰富的空间层次。从琴房仰望眠云亭，如云中楼阁；从眠云亭俯视琴房，则如水边茅庐，动静相宜，妙趣横生。 The Qin Room and Mianyun Pavilion are located in the northwest corner of Tuisi Garden, a pair of structures that ingeniously exploit the terrain''s height difference. The Qin Room sits at the lower level—a small chamber facing the water where the owner played the zither and savored tea. The interior is secluded; across the water from Tuisi Thatched Hall, zither music could travel across the pond surface, lingering in the air. Mianyun Pavilion crowns a stone terrace above, reached by stone steps. "Mianyun" (Cloud-Resting) derives from the classical line "lying down to watch clouds rise," suggesting a restful spot as if reclining among clouds. The diminutive pavilion has walls on three sides and a window on the fourth; from here one can overlook the entire garden. The two structures—one low and one high, one at the water''s edge and one against the hill—create rich spatial layering. Gazing up from the Qin Room, Mianyun Pavilion appears as a pavilion in the clouds; looking down from the pavilion, the Qin Room seems a waterside thatched hut—motion and stillness in perfect harmony.</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tuisi_garden_sa_08', 'suzhou_tuisi_garden', 'Guyu Shengliang (Coolness from Rain on Water Bamboo)', '菰雨生凉', '<p>Description： 菰雨生凉位于水池西岸，是一座贴水而建的小轩。"菰"即菰蒲，是水边常见的植物；"雨生凉"则描绘了雨打菰叶、清风拂水时带来的丝丝凉意。轩体三面临水，一面依墙，屋顶低矮，檐口贴近水面。夏日坐在轩中，水面凉风穿堂而过，池中菰蒲摇曳，荷叶滴翠，暑气顿消。若遇细雨，雨点敲击菰叶与水面，发出清脆之声，如天然乐章，更添凉意。轩内有匾额"菰雨生凉"，书法秀逸。此景将视觉、听觉、触觉融为一体——看菰蒲摇绿、听雨打清波、感凉风拂面，是退思园"意境造园"的极致表达，也是中国园林中"以景生情、以情入境"的典范。 Guyu Shengliang stands on the western shore of the pond, a small waterside chamber built flush with the surface. "Gu" refers to water bamboo (Zizania caduciflora), a common waterside plant; "yu sheng liang" depicts the coolness that comes when rain strikes the broad leaves and a breeze ripples across the pond. The chamber opens to the water on three sides with one wall behind, its low roof and eaves nearly touching the surface. On summer days, cool breezes sweep through off the water while water bamboo sways and lotus leaves glisten, instantly dispelling the heat. In gentle rain, droplets striking the leaves and water create a crystalline murmur—a natural symphony that deepens the sense of coolness. A calligraphic plaque inscribed "Gu Yu Sheng Liang" hangs within. This scene fuses sight, sound, and touch—watching green bamboo sway, hearing rain on rippling water, feeling cool wind on the skin—representing the ultimate expression of Tuisi Garden''s art of atmosphere and a paradigm of the Chinese garden principle of "scene evoking emotion, emotion entering realm."</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tuisi_garden_sa_09', 'suzhou_tuisi_garden', 'Sky Bridge and Xintai', '天桥与辛台', '<p>Description： 天桥与辛台位于退思园东北部，是一组极具巧思的立体建筑组合。天桥是一座贴墙而建的廊桥，横跨于水池之上，连接退思草堂与辛台。桥身轻巧，栏杆低矮，行走其上如凌波微步，俯瞰池中游鱼与莲花，别有意趣。辛台位于桥的北端，是一座高出台面的小方亭，为主人读书静思之所。"辛"字取"辛苦""辛劳"之意，与园名"退思补过"相呼应，提醒主人在退隐中仍不忘自勉自励。天桥与辛台一横一竖、一动一静，使原本有限的园林空间产生了丰富的层次感。从桥上望辛台，如高山上的亭阁；从辛台俯视天桥，则如水上飞虹，为小园增添了咫尺山林的意趣。 Sky Bridge and Xintai are located in the northeast of Tuisi Garden, an ingenious three-dimensional architectural composition. Sky Bridge is a covered corridor built against the wall, spanning above the pond to connect Tuisi Thatched Hall with Xintai. The bridge is slender with low railings; walking across it feels like skimming over the water, offering views of koi and lotus below. Xintai stands at the bridge''s northern end—a small square pavilion raised above the surrounding level, where the owner read and reflected. The character "Xin" connotes "hardship" and "diligence," echoing the garden''s theme of "retreating to reflect on one''s faults," reminding the owner to persevere even in reclusion. The bridge and pavilion—one horizontal and one vertical, one in motion and one still—generate rich spatial layering within the compact garden. From the bridge, Xintai appears as a pavilion atop a mountain; from Xintai, the bridge resembles a rainbow skimming the water, lending the small garden the feel of vast mountains and forests within a limited space.</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'suzhou_tuisi_garden_sa_10', 'suzhou_tuisi_garden', 'Naohong Yige (Red Boat) and Nine-Turn Winding Corridor', '闹红一舸与九曲回廊', '<p>Description： 闹红一舸与九曲回廊位于退思园中心水池周边，是全园最具画面感的景观组合。"闹红一舸"是一座船形石舫建筑，船头朝向池心，仿佛一叶扁舟正欲驶入荷花丛中。"闹红"二字取意于"万绿丛中一点红"，描绘夏日荷塘中红莲盛放的热闹景象。舫身以石砌成，舫上有小轩，可坐赏水景。九曲回廊沿水池东岸蜿蜒而行，连接退思草堂与各处景点。廊随地形与水岸曲折变化，共九个弯折，故名"九曲"。廊壁上嵌有书法碑刻与花窗，步移景异。行走于回廊中，时而临水观鱼，时而隔窗望景，空间体验丰富多变。船舫的"动"与回廊的"曲"相映成趣，使有限空间产生了无限的游赏意趣。 Naohong Yige and the Nine-Turn Corridor are situated around Tuisi Garden''s central pond, forming the garden''s most picturesque composition. "Naohong Yige" is a stone boat-shaped pavilion with its bow pointing toward the center of the pond, as if a skiff were about to glide into a lotus thicket. "Naohong" (Bustling Red) derives from the image of "a touch of red among ten thousand greens," depicting the lively scene of red lotus blooming in a summer pond. The boat is built of stone with a small cabin above where one can sit and enjoy the water views. The Nine-Turn Corridor winds along the eastern shore of the pond, connecting Tuisi Thatched Hall with various scenic spots. The corridor follows the terrain and shoreline through nine bends, hence its name. Its walls are embedded with calligraphic stone tablets and latticed windows, offering ever-changing views at every step. Walking through the corridor, one moment you lean over the water to watch fish, the next you peer through a window at a framed vista—a richly varied spatial experience. The "movement" of the boat and the "winding" of the corridor complement each other, generating boundless pleasure of exploration within a finite space.</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jiujie_sa_01', 'chongqing_jiujie', 'chongqing jiujie sub area 01', '九街标志牌坊', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jiujie_sa_02', 'chongqing_jiujie', 'chongqing jiujie sub area 02', '九街高屋', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jiujie_sa_03', 'chongqing_jiujie', 'chongqing jiujie sub area 03', '鲤鱼池42号文创园', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jiujie_sa_04', 'chongqing_jiujie', 'chongqing jiujie sub area 04', '九街后街', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_shibati_sa_01', 'chongqing_shibati', 'chongqing shibati sub area 01', '十八梯大牌坊', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_shibati_sa_02', 'chongqing_shibati', 'chongqing shibati sub area 02', '善果巷与山城记忆馆', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_shibati_sa_03', 'chongqing_shibati', 'chongqing shibati sub area 03', '月台坝（山地院落）', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_shibati_sa_04', 'chongqing_shibati', 'chongqing shibati sub area 04', '大隧道遗址', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_dazu_rock_carvings_sa_01', 'chongqing_dazu_rock_carvings', 'chongqing dazu rock carvings sub area 01', '宝顶山', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_dazu_rock_carvings_sa_02', 'chongqing_dazu_rock_carvings', 'chongqing dazu rock carvings sub area 02', '北山景区', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_dazu_rock_carvings_sa_03', 'chongqing_dazu_rock_carvings', 'chongqing dazu rock carvings sub area 03', '大足石刻博物馆', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_dazu_rock_carvings_sa_04', 'chongqing_dazu_rock_carvings', 'chongqing dazu rock carvings sub area 04', '南山景区', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_dazu_rock_carvings_sa_05', 'chongqing_dazu_rock_carvings', 'chongqing dazu rock carvings sub area 05', '石门山景区', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_dazu_rock_carvings_sa_06', 'chongqing_dazu_rock_carvings', 'chongqing dazu rock carvings sub area 06', '石篆山', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_mountain_trails_sa_01', 'chongqing_mountain_trails', 'chongqing mountain trails sub area 01', '步道入口牌坊', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_mountain_trails_sa_02', 'chongqing_mountain_trails', 'chongqing mountain trails sub area 02', '厚庐', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_mountain_trails_sa_03', 'chongqing_mountain_trails', 'chongqing mountain trails sub area 03', '悬空栈道', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_mountain_trails_sa_04', 'chongqing_mountain_trails', 'chongqing mountain trails sub area 04', '仁爱荒野剧场', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_liziba_monorail_sa_01', 'chongqing_liziba_monorail', 'chongqing liziba monorail sub area 01', '轨道李子坝站1号出口', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_liziba_monorail_sa_02', 'chongqing_liziba_monorail', 'chongqing liziba monorail sub area 02', '李子坝观景平台', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_liziba_monorail_sa_03', 'chongqing_liziba_monorail', 'chongqing liziba monorail sub area 03', '岩之魂浮雕文化墙', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_liziba_monorail_sa_04', 'chongqing_liziba_monorail', 'chongqing liziba monorail sub area 04', '文旅服务中心', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_liziba_monorail_sa_05', 'chongqing_liziba_monorail', 'chongqing liziba monorail sub area 05', '巴渝旧闻馆', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_liziba_monorail_sa_06', 'chongqing_liziba_monorail', 'chongqing liziba monorail sub area 06', '轨道穿楼主体建筑', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_raffles_city_sa_01', 'chongqing_raffles_city', 'chongqing raffles city sub area 01', '朝天门广场与两江交汇', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_raffles_city_sa_02', 'chongqing_raffles_city', 'chongqing raffles city sub area 02', '购物中心中庭与山城花园', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_raffles_city_sa_03', 'chongqing_raffles_city', 'chongqing raffles city sub area 03', '水晶连廊（探索舱·观景台）', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_raffles_city_sa_04', 'chongqing_raffles_city', 'chongqing raffles city sub area 04', '探索舱·云端乐园', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_01', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 01', '天龙桥', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_02', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 02', '仙女山国家公园-木梯子站', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_03', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 03', '仙女山国家公园-大草原站', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_04', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 04', '天官赐福', '<p>Description</p>', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_05', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 05', '青龙桥', '<p>Description</p>', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_06', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 06', '神鹰天坑', '<p>Description</p>', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_07', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 07', '黑龙桥', '<p>Description</p>', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_08', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 08', '龙泉洞', '<p>Description</p>', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_09', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 09', '龙水峡地缝', '<p>Description</p>', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_10', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 10', '银河飞瀑', '<p>Description</p>', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_wulong_karst_sa_11', 'chongqing_wulong_karst', 'chongqing wulong karst sub area 11', '蛟龙寒窟', '<p>Description</p>', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_01', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 01', '重庆洪崖洞民俗风貌区', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_02', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 02', '六楼：光影互动艺术空间', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_03', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 03', '五楼：重逢1980·八十年代生活情境街区', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_04', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 04', '四楼：盛宴美食街', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_05', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 05', '三楼：天成巷巴渝风情街', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_06', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 06', '二楼：纸盐河动感酒吧街', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_07', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 07', '一楼：滴翠广场', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_08', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 08', '城市阳台', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_09', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 09', '辛亥丰碑', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_10', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 10', '记忆山城雕塑', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_11', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 11', '江隘炮台铜雕', '', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_12', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 12', '十楼：巴文化柱', '', 11, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_13', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 13', '九楼：异域风情街', '', 12, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_14', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 14', '八楼：78区潮玩世界', '', 13, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_hongya_cave_sa_15', 'chongqing_hongya_cave', 'chongqing hongya cave sub area 15', '七楼：78区潮玩世界', '', 14, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_baixiangju_sa_01', 'chongqing_baixiangju', 'chongqing baixiangju sub area 01', '层临江入口（起点）', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_baixiangju_sa_02', 'chongqing_baixiangju', 'chongqing baixiangju sub area 02', '层空中公共连廊', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_baixiangju_sa_03', 'chongqing_baixiangju', 'chongqing baixiangju sub area 03', '长江索道同框观景窗', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_baixiangju_sa_04', 'chongqing_baixiangju', 'chongqing baixiangju sub area 04', '层解放东路出口（终点）', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_ciqikou_old_town_sa_01', 'chongqing_ciqikou_old_town', 'chongqing ciqikou old town sub area 01', '黄桷坪牌坊', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_ciqikou_old_town_sa_02', 'chongqing_ciqikou_old_town', 'chongqing ciqikou old town sub area 02', '磁器长歌体验馆', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_ciqikou_old_town_sa_03', 'chongqing_ciqikou_old_town', 'chongqing ciqikou old town sub area 03', '钟家院', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_ciqikou_old_town_sa_04', 'chongqing_ciqikou_old_town', 'chongqing ciqikou old town sub area 04', '宝善宫', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_ciqikou_old_town_sa_05', 'chongqing_ciqikou_old_town', 'chongqing ciqikou old town sub area 05', '鑫记杂货铺', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_ciqikou_old_town_sa_06', 'chongqing_ciqikou_old_town', 'chongqing ciqikou old town sub area 06', '聚森茂酱园旧址', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_ciqikou_old_town_sa_07', 'chongqing_ciqikou_old_town', 'chongqing ciqikou old town sub area 07', '磁横街', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_ciqikou_old_town_sa_08', 'chongqing_ciqikou_old_town', 'chongqing ciqikou old town sub area 08', '宝轮寺', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_ciqikou_old_town_sa_09', 'chongqing_ciqikou_old_town', 'chongqing ciqikou old town sub area 09', '迎龙门码头', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_ciqikou_old_town_sa_10', 'chongqing_ciqikou_old_town', 'chongqing ciqikou old town sub area 10', '九石缸河滩', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_guanyinqiao_sa_01', 'chongqing_guanyinqiao', 'chongqing guanyinqiao sub area 01', '观音桥步行街广场', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_guanyinqiao_sa_02', 'chongqing_guanyinqiao', 'D”大屏', '茂业天地“裸眼3D”大屏', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_guanyinqiao_sa_03', 'chongqing_guanyinqiao', 'chongqing guanyinqiao sub area 03', '观音桥雕塑（城市标志）', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_guanyinqiao_sa_04', 'chongqing_guanyinqiao', 'chongqing guanyinqiao sub area 04', '北城天街', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_guanyinqiao_sa_05', 'chongqing_guanyinqiao', 'chongqing guanyinqiao sub area 05', '观音桥九街（不夜九街 - 终点）', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jiefangbei_sa_01', 'chongqing_jiefangbei', 'chongqing jiefangbei sub area 01', '解放碑广场', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jiefangbei_sa_02', 'chongqing_jiefangbei', 'chongqing jiefangbei sub area 02', '解放碑纪念碑', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jiefangbei_sa_03', 'chongqing_jiefangbei', 'chongqing jiefangbei sub area 03', '解放碑步行街雕塑群', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jiefangbei_sa_04', 'chongqing_jiefangbei', 'chongqing jiefangbei sub area 04', '邹容路步行街', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jiefangbei_sa_05', 'chongqing_jiefangbei', 'chongqing jiefangbei sub area 05', '八一路好吃街', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jiefangbei_sa_06', 'chongqing_jiefangbei', 'chongqing jiefangbei sub area 06', '环球金融中心会仙楼观景台', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_zoo_sa_01', 'chongqing_zoo', 'chongqing zoo sub area 01', '大门广场（起点）', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_zoo_sa_02', 'chongqing_zoo', 'chongqing zoo sub area 02', '熊猫馆', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_zoo_sa_03', 'chongqing_zoo', 'chongqing zoo sub area 03', '金鱼馆', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_zoo_sa_04', 'chongqing_zoo', 'chongqing zoo sub area 04', '两栖爬行动物馆', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_zoo_sa_05', 'chongqing_zoo', 'chongqing zoo sub area 05', '鸟类区', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_01', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 01', '大门', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_02', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 02', '药池坝', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_03', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 03', '古佛洞', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_04', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 04', '金佛顶', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_05', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 05', '生态石林', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_06', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 06', '西门索道下站', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_07', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 07', '西门游客中心', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_08', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 08', '碧潭幽谷', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_09', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 09', '索道下站', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_10', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 10', '牵牛坪天街', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_11', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 11', '箭竹林海', '', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_12', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 12', '金龟朝阳', '', 11, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_13', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 13', '云端步道', '', 12, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_14', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 14', '燕子洞和灵观洞', '', 13, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_jinfo_mountain_sa_15', 'chongqing_jinfo_mountain', 'chongqing jinfo mountain sub area 15', '杜鹃王子', '', 14, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_yangtze_cableway_sa_01', 'chongqing_yangtze_cableway', 'chongqing yangtze cableway sub area 01', '北站（渝中区新华路站）', '<p>Description</p>', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_yangtze_cableway_sa_02', 'chongqing_yangtze_cableway', 'chongqing yangtze cableway sub area 02', '索道轿厢', '<p>Description</p>', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_yangtze_cableway_sa_03', 'chongqing_yangtze_cableway', 'chongqing yangtze cableway sub area 03', '南站（南岸区龙门浩站）', '<p>Description</p>', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_01', 'chongqing_eling_2nd_factory', 'chongqing eling 2nd factory sub area 01', '大门', '', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_02', 'chongqing_eling_2nd_factory', 'chongqing eling 2nd factory sub area 02', '螺旋楼梯和涂鸦巷', '', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_03', 'chongqing_eling_2nd_factory', 'chongqing eling 2nd factory sub area 03', '巨型拉链雕塑', '', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_04', 'chongqing_eling_2nd_factory', 'chongqing eling 2nd factory sub area 04', '下沉广场', '', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_05', 'chongqing_eling_2nd_factory', 'chongqing eling 2nd factory sub area 05', '重庆书局', '', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_06', 'chongqing_eling_2nd_factory', 'chongqing eling 2nd factory sub area 06', '你好童年怀旧馆', '', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_07', 'chongqing_eling_2nd_factory', 'chongqing eling 2nd factory sub area 07', '二厂记忆博物馆', '', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_08', 'chongqing_eling_2nd_factory', 'chongqing eling 2nd factory sub area 08', '民国中央银行印钞厂旧址（9号楼）', '', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_09', 'chongqing_eling_2nd_factory', 'Test Design街巷', 'Test Design街巷', '', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_10', 'chongqing_eling_2nd_factory', 'Test Joy街巷', 'Test Joy街巷', '', 9, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_11', 'chongqing_eling_2nd_factory', 'Test Spirit街巷', 'Test Spirit街巷', '', 10, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_12', 'chongqing_eling_2nd_factory', 'T²国际当代艺术中心', 'T²国际当代艺术中心', '', 11, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_13', 'chongqing_eling_2nd_factory', 'CITY-RADIO电台墙）', '爱情天台（CITY-RADIO电台墙）', '', 12, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'chongqing_eling_2nd_factory_sa_14', 'chongqing_eling_2nd_factory', 'chongqing eling 2nd factory sub area 14', '云上天台', '', 13, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  updated_at=NOW();
