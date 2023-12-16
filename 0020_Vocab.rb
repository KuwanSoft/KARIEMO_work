#==============================================================================
# ■ Vocab
#------------------------------------------------------------------------------
# 用語とメッセージを定義するモジュールです。定数でメッセージなどを直接定義す
# るほか、グローバル変数 $data_system から用語データを取得します。
#==============================================================================

module Vocab

  HP = "ヒットポイント"  # 使用しているので消さない

  # 戦闘基本メッセージ
  Preemptive      = "てきはまだこちらにきづいていない"
  Surprise        = "うしろに まわりこまれた!"
  EscapeStart     = "パーティは にげだした。"
  EscapeFailure   = "しかし、 にげきれなかった。"

  # 戦闘終了メッセージ
  Victory         = "パーティは たたかいに しょうりした。"
  Defeat          = "パーティは ぜんめつした。"
  ObtainExp       = "いきのこったメンバーは %s の けいけんちを えた。"
  ObtainItem      = "%sをてにいれた"

  # 戦闘行動
  DosupAttack_1     = "%sは %sに "
  DosupAttack_2     = "ふいうちをしかけた。"
  DoHide_s        = "%sは ものかげに かくれた。"
  DoHide_f        = "%sは かくれることに しっぱいした。"
  UseItem         = "%sは %s をつかった。"
  UseSummon       = "%sは せいれいを よびだした。"
  Doturnundead    = "%sは ししゃたちを じょうかしようとした。"
  Doshieldblock   = "%sは たてで みをまもった。"
  Spellbreak      = "%sの えいしょうが ちゅうだんされた。"
  Domeditation    = "%sは めいそうを はじめた。"
  Domultishot     = "%sは みだれうった。"
  Counter         = "%sの カウンターアタック!"
  Shingan1        = "%sの こうげきを"
  Shingan2        = "%sは しんがんで みきった。"
  Doencourage_s   = "%sは なかまを こぶした!"
  Doencourage_f   = "%sは エンカレッジにしっぱい。"
  Domultisupatk   = "%sは はいごから みだれうった。"
  Cancel          = "%sは つかれて うまくうごけなかった。"
  Fear            = "%sは きょうふのため みうごきできない。"
  Shock           = "%sは しびれて みうごきできない。"
  Nausea          = "%sは はきけで みうごきできない。"

  # アクター対象の行動結果
  ActorDamage     = "そして %d かいヒットし %d のダメージ。"
  ActorDamage_mag = "%sに %d のダメージ。"
  ActorDrain      = "%sは%sを %s うばわれた。"
  NoDamage        = "%sは ダメージを うけていない。"
  ActorNoHit      = "ミス　%sはダメージをうけていない"
  ActorEvasion    = "%sは攻撃をかわした"
  ActorRecovery   = "%sの %sが %s かいふくした"

  # 敵キャラ対象の行動結果
  EnemyDamage     = "そして %d かいヒットし %d のダメージ。"
  Enemy2Damage    = "さらに %d かいヒットし %d のダメージ。"
  EnemyDamage_mag = "%sに %d のダメージ。"
  EnemyDrain      = "%sの%sを %s うばった。"
  EnemyNoDamage   = "%sは ダメージをうけていない。"
  EnemyNoHit      = "ミス　%sにダメージをあたえられない"
  EnemyEvasion    = "%sは攻撃をかわした"
  EnemyRecovery   = "%sの%sが %s かいふくした"
  DoEscape        = "%sは そのばから にげさった。"

  NoDamageSkill   = "%s はダメージをうけていない。"
  ActionResist    = "%s はじゅもんを むこうかした。"
  ActionBResist   = "%s はブレスを むこうかした。"
  NoDamageByProtection = "%sは ダメージから まもられている!"

  Fascinate       = "%sは せっとくされた!"
  Disturbance     = "%sの まわりのくうきが よどみだした!"
  Mitigate        = "%sの ブレスていこうがじょうしょう!"
  ResistUp        = "%sの ていこうりょくが じょうしょう!"
  ResistDown      = "%sの ていこうりょくが ていかした。"
  Barrierup       = "%sは じゅもんしょうへきに まもられた。"
  Barrierdown     = "%sの じゅもんしょうへきが よわめられた。"
  Armorup         = "%sの よろいに まほうが かかった。"
  DRup            = "%sの ダメージたいせいが あがった。"
  Veil_fire       = "%sは ほのおのベールにおおわれた。"
  Veil_ice        = "%sは こおりのベールにおおわれた。"
  Veil_thunder    = "%sは かみなりのベールにおおわれた。"
  Veil_air        = "%sは かぜのベールにおおわれた。"
  Veil_poison     = "%sは どくのベールにおおわれた。"
  StatusUp        = "%sの ステータスがじょうしょう!"
  Armordown       = "%sの よろいは よわくなった。"
  Powerup         = "%sの ちからが あがった。"
  Initiativeup    = "%sの はやさが あがった。"
  Clearedplus     = "%sの じゅもんこうかが きえさった"
  Convert         = "%sの ちからが いれかわる!"
  Regene          = "%sの きずぐちが しだいに とじてゆく!"
  Sacrifice       = "%sの みがわりを つくりだした!"
  Mindpower       = "%sは まりょくの やいばを つくりだした!"
  Enchant         = "%sの ぶきに じゅもんのちからが やどった!"
  Provoke         = "%sは てきの ちゅうもくを あつめた!"
  Summon1         = "そして、ドリュアスが あらわれた!"
  Summon2         = "そして、ノームが あらわれた!"
  Summon3         = "そして、シルフィードが あらわれた!"
  Summon4         = "そして、ウンディーネが あらわれた!"
  Summon5         = "そして、ウィル・オ・ウィスプが あらわれた!"
  Summon6         = "そして、フェニックスが あらわれた!"
  Summon7         = "そして、フェンリルが あらわれた!"
  Weak            = "%sの じゃくてんを こうげき!"
  Resist_element  = "%sは ぞくせいに ていこうりょくをもつ!"
  Protection      = "%sは ふしぎなちからに まもられた!"
  Saint           = "%sは せいなるちからに まもられた!"
  Lucky           = "%sの のうりょくが あがった!"
  PreventDrain    = "%sは ドレインこうげきを ふせいだ!"
  Stop            = "%sの じかんが ていしした!"
  Encouraged      = "%sの きりょくが じょうしょうした!"
  Identified      = "%sが まものの しょうたいを あばきだす!"
  Smoke           = "こい けむりが あたりにたちこめた!"
  CallHome        = "あたりを まぶしい ひかりが つつむ!"
  Miracle         = "* なんじの ほっする きせきのなを さけべ! *"

  # 物理攻撃以外のスキル、アイテムの効果がなかった
  CastMiss        = "じゅもんのえいしょうに しっぱいした。"
  Fizzle          = "じゅもんえいしょうが ぼうがいされた!"
  BreathFizzle    = "ブレスが ぼうがいされた!"
  ActionFailure   = "しかし、なにも おきなかった。"

  ## アクター側の武器種類ごと攻撃メッセージ
  Dosword1_1      = "%sは %sを"
  Dosword1_2      = "まっすぐに つきさした。"
  Dosword2_1      = "%sは %sを"
  Dosword2_2      = "きりきざんだ。"
  Dosword3_1      = "%sは %sを"
  Dosword3_2      = "すばやく きりつけた。"
  Doaxe1_1        = "%sは %sに"
  Doaxe1_2        = "むかって ふりかぶった。"
  Doaxe2_1        = "%sは %sに"
  Doaxe2_2        = "とびかかった。"
  Doaxe3_1        = "%sは %sに"
  Doaxe3_2        = "オノをふりおろした。"
  Dospear1_1      = "%sは %sを"
  Dospear1_2      = "なぎはらった。"
  Dospear2_1      = "%sは %sを"
  Dospear2_2      = "するどくつきさした。"
  Dospear3_1      = "%sは %sを"
  Dospear3_2      = "ねらいすました。"
  Dodagger1_1        = "%sは %sを"
  Dodagger1_2        = "なんども つきさした。"
  Dodagger2_1        = "%sは %sを"
  Dodagger2_2        = "きりきざんだ。"
  Dodagger3_1        = "%sは %sを"
  Dodagger3_2        = "すばやく きりつけた。"
  Doclub1_1        = "%sは %sに"
  Doclub1_2        = "はげしく なぐりかかった。"
  Doclub2_1        = "%sは %sを"
  Doclub2_2        = "つよく たたいた。"
  Doclub3_1        = "%sは %sを"
  Doclub3_2        = "のうてんから くだこうとした。"
  Dothrow1_1       = "%sは %sに"
  Dothrow1_2       = "ねらいを さだめた。"
  Dothrow2_1       = "%sは %sを"
  Dothrow2_2       = "うちぬこうとした。"
  Dothrow3_1       = "%sは %sに"
  Dothrow3_2       = "むかって なげた。"
  Dostaff1_1        = "%sは %sを"
  Dostaff1_2        = "つよくたたいた。"
  Dostaff2_1        = "%sは %sを"
  Dostaff2_2        = "つよくたたいた。"
  Dostaff3_1        = "%sは %sを"
  Dostaff3_2        = "つよくたたいた。"
  Dobow1_1          = "%sは %sを"
  Dobow1_2          = "ねらいうった。"
  Dobow2_1          = "%sは %sを"
  Dobow2_2          = "うちぬいた。"
  Dobow3_1          = "%sは %sにむかって"
  Dobow3_2          = "つよくつるを ひきしぼった。"
  Dospecial1_1    = "%sは %sに"
  Dospecial1_2    = "おもいきって とびかかった。"
  Dospecial2_1    = "%sは %sに"
  Dospecial2_2    = "とっしんをしかけた。"
  Dospecial3_1    = "%sは %sに"
  Dospecial3_2    = "はげしくあたっていった。"
  Dokatana1_1       = "%sは %sを"
  Dokatana1_2       = "いっしゅんで きった。"
  Dokatana2_1       = "%sは %sと"
  Dokatana2_2       = "すばやくまあいを つめた。"
  Dokatana3_1       = "%sは %sを"
  Dokatana3_2       = "きりはらった。"

  # キャラクターのコマンドリスト
  Command01   = "こうげき"
  Command02   = "みをまもる"
  Command03   = "アイテムをつかう"
  Command04   = "じゅもんのしょ"
  Command05   = "すがたをかくす"
  Command06   = "ふいをつく"
  Command07   = "ターンU.D."
  Command08   = "エンカレッジ"
  Command09   = "チャネリング"
  Command10   = "*"
  Command11   = "*"
  Command12   = "せいしんとういつ"
  Command13   = "*"
  Command14   = "*"
end
