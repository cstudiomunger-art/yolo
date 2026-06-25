-- 行前准备清单 v1.0 种子（通用 + 成都）
-- 来源：01_通用行前准备清单_v1.0.md / 02_成都行前准备清单_v1.0.md（2026-06-25）
-- 约定（与产品确认）：
--   * priority：文档 critical → 'required'，并对这些条目打 display_tags=['key']（预留 App Key 角标）。
--   * why_important / how_to_complete：先存中文草稿（HTML，App 用 HTMLContentView 渲染），后续翻译覆盖。
--   * 不使用 per-item reminder：App 提醒走全局 checklist_settings.reminder_days。
--   * 入境类 target_nationalities 留空 = 对所有外国人显示；分组：entry→Entry Requirements，universal→Essential Prep，city→Chengdu。
--   * App 排序仅看 sort_order（priority 不影响顺序）。

-- 1) 停用旧演示清单（008 种子），避免与 v1 新条目重复/口径冲突（如 cl_vpn）
UPDATE checklist_items
SET is_active = FALSE, updated_at = NOW()
WHERE id IN ('cl_alipay','cl_amap','cl_didi','cl_esim','cl_forbidden_tickets','cl_great_wall','cl_pleco','cl_vpn');

-- 2) 写入 v1 清单（幂等：ON CONFLICT 覆盖内容）
INSERT INTO checklist_items
  (id, type, phase, group_title, title_en, priority,
   why_important, how_to_complete, external_links,
   target_nationalities, target_cities, city_id, display_tags, sort_order, is_active)
VALUES
-- ───────── A. 入境与签证（entry，对所有外国人显示）─────────
('cl_entry_visa_eligibility', 'entry', 'before_departure', 'Entry Requirements',
 'Check your visa or visa-free eligibility', 'required',
 $h$<p>中国对不同国籍、不同停留时长、不同口岸的免签政策差别很大（互免 / 单方面免签 / 240 小时过境免签 / 海南免签等）。搞错可能直接被拒登机。</p>$h$,
 $h$<ol><li>在 App 内打开"签证检测器"，输入护照国籍 + 行程城市 + 停留天数。</li><li>系统判定：够用（免签 / 过境免签）或需要办签证。</li><li>若需办签证 → 提前向中国驻当地使领馆 / 签证中心申请 L 旅游签（通常 4–7 个工作日，旺季更久）。</li></ol>$h$,
 '[{"label":"Open Visa Checker","url":"app://visa-checker"}]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, ARRAY['key']::text[], 10, TRUE),

('cl_entry_passport_validity', 'entry', 'before_departure', 'Entry Requirements',
 'Make sure your passport is valid for 6+ months', 'required',
 $h$<p>中国入境通常要求护照在停留期结束后仍有至少 6 个月有效期，且有空白签证页。这是免签 / 过境免签的硬门槛（GATE 0）。</p>$h$,
 $h$<ol><li>翻到护照信息页，确认到期日距你<strong>回国日期</strong>还有 ≥ 6 个月。</li><li>不足 6 个月 → 立即在本国预约换发新护照（耗时数周）。</li><li>确认至少有 1–2 页空白页。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, ARRAY['key']::text[], 20, TRUE),

('cl_entry_arrival_docs', 'entry', 'before_departure', 'Entry Requirements',
 'Prepare your arrival documents', 'recommended',
 $h$<p>入境时可能需填写外国人入境卡、健康申报，部分免签政策要求出示订妥的离境机票和酒店订单。备齐可避免在口岸手忙脚乱。</p>$h$,
 $h$<ol><li>准备好<strong>离境机票</strong>（往返或续程）订单截图——过境免签必查。</li><li>准备<strong>酒店订单</strong>确认单（含地址）。</li><li>落地前在飞机上填好入境卡（如有发放）。</li><li>截图保存使馆 / 紧急联系电话，离线可看。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, '{}'::text[], 30, TRUE),

-- ───────── B. 支付（universal）─────────
('cl_pay_alipay', 'universal', 'before_departure', 'Essential Prep',
 'Download Alipay and link your card', 'required',
 $h$<p>支付宝是在中国通行度最高的支付方式，打车、坐地铁、买票、扫码点餐几乎都靠它。提前绑卡，到了就能用。</p>$h$,
 $h$<ol><li>App Store / Google Play 搜 <strong>Alipay</strong> 下载。</li><li>用境外手机号注册。</li><li>实名认证：上传<strong>护照</strong>。</li><li>绑卡：支持 Visa、Mastercard、American Express、JCB、Diners Club、Discover、RuPay。</li><li>在"出行 / 扫一扫"里点开，确认能用。</li></ol>$h$,
 '[{"label":"Get Alipay","url":"https://apps.apple.com/app/alipay"}]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, ARRAY['key']::text[], 10, TRUE),

('cl_pay_wechat', 'universal', 'before_departure', 'Essential Prep',
 'Download WeChat and set up WeChat Pay', 'required',
 $h$<p>很多本地小商家、小程序（美团 / 购票）只方便用微信。微信支付是支付宝之外的第二张底牌。</p>$h$,
 $h$<ol><li>下载 <strong>WeChat</strong>，用境外手机号注册（建议找个中国朋友帮你"辅助验证"，新号常需要）。</li><li>开通微信支付，实名证件支持：护照、永久居住证、回乡证、台胞证等。</li><li>绑卡：Visa、Mastercard、Diners Club、Discover、JCB、American Express。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, ARRAY['key']::text[], 20, TRUE),

('cl_pay_bank_whitelist', 'universal', 'before_departure', 'Essential Prep',
 'Call your bank to whitelist China transactions', 'recommended',
 $h$<p>外卡在中国被拒，约 90% 是银行风控拦截"中国商户"交易，而不是 App 的问题。提前打招呼能避免到了刷不出来。</p>$h$,
 $h$<ol><li>打你银行卡背面的国际客服电话。</li><li>告知："我将前往中国旅行，会在支付宝 / 微信 / Trip.com 消费，请将中国商户加入白名单、不要拦截。"</li><li>顺便问清海外交易手续费。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, '{}'::text[], 30, TRUE),

('cl_pay_rmb_cash', 'universal', 'before_departure', 'Essential Prep',
 'Bring some RMB cash as backup', 'recommended',
 $h$<p>极少数场景（老旧出租、偏远小店、App 临时抽风）仍需现金。带一点最稳妥；中国法律规定商家不得拒收现金。</p>$h$,
 $h$<ol><li>在本国或机场换 ¥500–1000 现金（含小面额）。</li><li>备一点零钱给打车 / 小摊。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, '{}'::text[], 40, TRUE),

-- ───────── C. 网络与通讯（universal）─────────
('cl_conn_esim', 'universal', 'before_departure', 'Essential Prep',
 'Buy an eSIM or international data plan before you land', 'required',
 $h$<p>落地即可上网，且走境外运营商路由时<strong>一般无需 VPN 即可访问 Google、WhatsApp、Instagram</strong>，体验最无缝、最合规。</p>$h$,
 $h$<ol><li>出发前在本国买好支持中国的 eSIM（如主流 eSIM 平台的"China / Asia"套餐）。</li><li>落地前<strong>先激活</strong>，确认能联网。</li><li>关于 VPN：仅供个人通信使用的短期游客执法风险极低，但<strong>我们不推荐任何具体 VPN 品牌</strong>；eSIM 已能满足绝大多数访问需求。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, ARRAY['key']::text[], 50, TRUE),

('cl_conn_offline_maps', 'universal', 'before_departure', 'Essential Prep',
 'Set up offline maps and translation before arrival', 'recommended',
 $h$<p>到了之后第一时间要导航、要和司机 / 店家沟通，提前装好、下好离线包，不至于一落地两眼一抹黑。</p>$h$,
 $h$<ol><li>装一个翻译 App（支持中英、可拍照 / 语音）。</li><li>装地图（高德可在支付宝内打开；境外地图在华定位偏移需注意）。</li><li>在 App 内保存常用目的地的<strong>精准中文地址</strong>（可直接复制给打车软件）。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, '{}'::text[], 60, TRUE),

-- ───────── D. 必装 App（universal）─────────
('cl_apps_essentials', 'universal', 'before_departure', 'Essential Prep',
 'Download the essential apps for China', 'recommended',
 $h$<p>出发前一口气装好，落地直接用，省得到了再一个个下载、注册、绑卡。</p>$h$,
 $h$<p>核对清单：</p><ul><li><strong>Alipay 支付宝</strong>（支付 / 打车 / 坐车 / 扫码）</li><li><strong>WeChat 微信</strong>（支付 / 沟通 / 小程序）</li><li><strong>DiDi 滴滴</strong>（打车，英文界面最友好）</li><li><strong>Trip.com</strong>（机票 / 火车票 / 景区门票，英文 + 外卡最稳）</li><li>翻译 App</li></ul>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, '{}'::text[], 70, TRUE),

-- ───────── E. 预订：酒店 / 交通 / 门票（universal）─────────
('cl_book_foreigner_hotel', 'universal', 'before_departure', 'Essential Prep',
 'Book a hotel that accepts foreign guests', 'required',
 $h$<p>中国部分酒店不接待外国护照旅客，到店被拒会很被动。提前订"涉外"酒店并确认能登记护照最稳。</p>$h$,
 $h$<ol><li>在 Trip.com / Booking / Agoda 上预订，订前确认该店接待外宾。</li><li>保存订单确认单（含中文地址，便于打车 / 入境出示）。</li><li>App 内"Book Your Trip"有各城市涉外酒店推荐可参考。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, ARRAY['key']::text[], 80, TRUE),

('cl_book_train_tickets', 'universal', 'before_departure', 'Essential Prep',
 'Book train tickets in advance (if traveling between cities)', 'recommended',
 $h$<p>高铁票提前约 15 天开售，热门线路会售罄。提前订好不耽误行程。</p>$h$,
 $h$<ol><li><strong>首选 Trip.com</strong>：全英文界面、收国际卡、英文客服（有服务费但省心）。</li><li>或用 <strong>12306 官方 App</strong>：可用护照注册 + Visa / Mastercard 付款，但实名核验需 30 分钟到 1 周，请提前 1–2 周完成。</li><li>进站持护照刷闸（全程电子票）。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, '{}'::text[], 90, TRUE),

('cl_book_attractions', 'universal', 'before_departure', 'Essential Prep',
 'Pre-book attractions that sell out', 'required',
 $h$<p>部分顶级景点（如故宫）<strong>没有现场票，必须提前 7–10 天在线预约</strong>，到门口无票不设例外。</p>$h$,
 $h$<ol><li>行程确认后<strong>立即</strong>在 Trip.com / Klook 锁定热门景点票。</li><li>实名预约时填护照信息。</li><li>各城市具体"必抢"景点见对应<strong>城市清单</strong>（如成都熊猫基地）。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, ARRAY['key']::text[], 100, TRUE),

('cl_book_didi', 'universal', 'before_departure', 'Essential Prep',
 'Set up DiDi for getting around', 'recommended',
 $h$<p>滴滴覆盖 400+ 城市，有完整英文界面、支持外卡、司乘对话实时双语翻译，是对外国人最友好的打车工具。</p>$h$,
 $h$<ol><li>装"滴滴出行 / DiDi"，或在微信 / 支付宝内直接搜"滴滴"。</li><li>绑外卡（Visa / Mastercard / Amex / JCB），或行程结束扫码用支付宝 / 微信付。</li><li>目的地可直接填中文（从 App 内复制精准中文地址最稳）。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, '{}'::text[], 110, TRUE),

-- ───────── F. 健康与证件（universal）─────────
('cl_health_meds', 'universal', 'before_departure', 'Essential Prep',
 'Pack prescription medications with a doctor''s note', 'recommended',
 $h$<p>部分药品在中国买不到或名称不同；带英文处方 / 医生说明可应对海关查验与紧急就医。</p>$h$,
 $h$<ol><li>带足全程用量的处方药，保留原包装。</li><li>带一份英文处方或医生说明（含药品通用名）。</li><li>备少量常用 OTC：肠胃药、止痛药、感冒药。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, '{}'::text[], 120, TRUE),

('cl_health_insurance', 'universal', 'before_departure', 'Essential Prep',
 'Get travel insurance with 24-hour assistance', 'recommended',
 $h$<p>中国公立医院常需先付费后看病、多不收外卡；保险垫付 + 事后理赔能省一大笔，且 24h 救援电话在紧急时是救命线。</p>$h$,
 $h$<ol><li>买一份覆盖中国的旅行医疗险。</li><li>把保单上的 <strong>24h assistance 电话</strong>存进手机，并截图离线保存。</li><li>就医务必<strong>留好发票 + 病历</strong>用于理赔。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, '{}'::text[], 130, TRUE),

('cl_health_passport_copies', 'universal', 'before_departure', 'Essential Prep',
 'Make copies of your passport and emergency contacts', 'recommended',
 $h$<p>护照丢失补办流程长（报案 → 出入境报失证明 → 使馆 ETD → 补签证），有副本能大幅加速；紧急号码离线可看很关键。</p>$h$,
 $h$<ol><li>护照信息页拍照存手机 + 打印一份纸质，分开放。</li><li>存好：本国驻华使领馆电话、移民局外国人热线 <strong>12367</strong>（有英语坐席）、报警 110、急救 120。</li><li>这些信息在 App 的 Emergency 板块离线也能查。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], '{}'::text[], NULL, '{}'::text[], 140, TRUE),

-- ───────── 成都（city，target_cities = chengdu）─────────
('cl_cd_prebook_attractions', 'city', 'before_departure', 'Chengdu',
 'Pre-book tickets for popular attractions', 'required',
 $h$<p>成都热门景点（熊猫基地最抢手、旺季常售罄，武侯祠、杜甫草堂、都江堰等）在旺季易满，部分需实名预约，提前订才不白跑。</p>$h$,
 $h$<ol><li>行程定好后，通过官方小程序 / Trip.com 预约，实名填<strong>护照</strong>。</li><li>熊猫基地旺季至少提前 <strong>7 天</strong>，并尽量订上午场（熊猫上午最活跃）。</li><li>截图保存预约凭证。</li></ol>$h$,
 '[]'::jsonb,
 '{}'::text[], ARRAY['chengdu']::text[], 'chengdu', ARRAY['key']::text[], 10, TRUE),

('cl_cd_stomach_meds', 'city', 'before_departure', 'Chengdu',
 'Pack stomach medication', 'recommended',
 $h$<p>四川菜以麻辣著称，第一次大量吃火锅 / 串串，肠胃可能不适。带点常用 OTC 肠胃药有备无患。</p>$h$,
 $h$<p>行李备好肠胃药 / 止泻药；头一两顿别一上来就最辣。</p>$h$,
 '[]'::jsonb,
 '{}'::text[], ARRAY['chengdu']::text[], 'chengdu', '{}'::text[], 20, TRUE),

('cl_cd_understand_spicy', 'city', 'before_departure', 'Chengdu',
 'Know what Sichuan "spicy" really means', 'recommended',
 $h$<p>四川的"麻"（花椒带来的酥麻感）和"辣"是两回事。哪怕你平时能吃辣，四川的"麻辣"也是全新体验——心里先有数，吃起来更从容。</p>$h$,
 $h$<p>知道招牌菜（火锅、串串、麻辣烫、冒菜）默认偏辣偏麻；点菜时主动说辣度（见下一条）。</p>$h$,
 '[]'::jsonb,
 '{}'::text[], ARRAY['chengdu']::text[], 'chengdu', '{}'::text[], 30, TRUE),

('cl_cd_order_spice_level', 'city', 'before_departure', 'Chengdu',
 'Learn how to order your spice level', 'recommended',
 $h$<p>普通"微辣"对初来者可能仍然很冲。会说辣度能救你的舌头。</p>$h$,
 $h$<p>记住几句（点餐直接说 / 出示）：</p><ul><li>不辣 — <strong>bù là</strong></li><li>微辣 — <strong>wēi là</strong></li><li>中辣 — <strong>zhōng là</strong></li><li>"我不太能吃辣" — <strong>wǒ bù tài néng chī là</strong></li></ul>$h$,
 '[]'::jsonb,
 '{}'::text[], ARRAY['chengdu']::text[], 'chengdu', '{}'::text[], 40, TRUE),

('cl_cd_temple_etiquette', 'city', 'before_departure', 'Chengdu',
 'Know the etiquette for Chengdu''s temples', 'recommended',
 $h$<p>青羊宫（道教）、文殊院（佛教）是仍在使用的宗教场所，不是单纯景点。懂点礼仪既尊重当地、也看得更有门道。</p>$h$,
 $h$<p>可拍照但<strong>别开闪光灯</strong>、别拍正在礼拜的人；别打扰上香 / 打坐的信众；着装得体。</p>$h$,
 '[]'::jsonb,
 '{}'::text[], ARRAY['chengdu']::text[], 'chengdu', '{}'::text[], 50, TRUE)

ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  phase = EXCLUDED.phase,
  group_title = EXCLUDED.group_title,
  title_en = EXCLUDED.title_en,
  priority = EXCLUDED.priority,
  why_important = EXCLUDED.why_important,
  how_to_complete = EXCLUDED.how_to_complete,
  external_links = EXCLUDED.external_links,
  target_nationalities = EXCLUDED.target_nationalities,
  target_cities = EXCLUDED.target_cities,
  city_id = EXCLUDED.city_id,
  display_tags = EXCLUDED.display_tags,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();
