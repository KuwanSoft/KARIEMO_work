#==============================================================================
# ■ MUSIC
#------------------------------------------------------------------------------
# 　BGMを一括管理
#==============================================================================
class MUSIC
  def play(scene)
    vol = $master_volume
    case scene
    when "タイトル"
      case rand(2)
      when 0;
        RPG::BGM.new("cursed-house_loop",vol,100).play
      when 1;
        RPG::BGM.new("Wingless Seraph_main-theme04_loop",vol,100).play
      end
    when "タイトル中断あり"
      RPG::BGM.new("061-Slow04",vol+10,100).play
    when "オープニング"
      RPG::BGM.new("Voyage_loop",vol,100).play
    when "へんきょうのむら"
      RPG::BGM.new("baroque04-cem",vol,100).play
    when "やどや"
      RPG::BGM.new("baroque13-cem",vol,100).play
    when "どうぐや"
      RPG::BGM.new("baroque08-cem",vol,100).play
    when "さかば"
      RPG::BGM.new("baroque16-cem",vol,100).play
    when "きょうかい"
      RPG::BGM.new("baroque23-cem",vol,100).play
    when "やくば"
      RPG::BGM.new("baroque20-cem",vol,100).play
    when "やかた"
      RPG::BGM.new("baroque14-cem",vol,100).play
    when "さるのしろ"
      RPG::BGM.new("baroque07-cem",vol,100).play
    when "地下迷宮前"
      RPG::BGM.new("018-Field01",vol+10,100).play
    when "たからばこ"
      RPG::BGM.new("xp_tower1",vol,100).play
    when "パーティ"
      RPG::BGM.new("Dungeon-Cave_loop",vol,100).play
    when "ぜんめつ"
      RPG::BGM.new("014-Theme03",vol+10,100).play
    when "はっけん"
      RPG::BGM.new("baroque22-cem",vol,100).play
    when "ぼち"
      RPG::BGM.new("baroque12-cem",vol,100).play
    when "あやしげな場所"
      case rand(2)
      when 0; RPG::BGM.new("evilcastle",vol,100).play
      when 1; RPG::BGM.new("054-Negative03",vol+10,100).play
      end
    when "あやしげな場所2"
      RPG::BGM.new("041-Dungeon07",vol+10,100).play
    when "地下回廊"
      RPG::BGM.new("ruins1",vol,100).play
    when "行商人"
      RPG::BGM.new("baroque22-cem",vol,100).play
    when "ミュージアム"
      RPG::BGM.new("baroque19-cem",vol,100).play
    when "通常戦闘"
      RPG::BGM.new("003-Battle03",vol+10,100).play
    when "中ボス戦"
      RPG::BGM.new("005-Boss01",vol+10,100).play
    when "イベント戦"
      RPG::BGM.new("struggle",vol,100).play
    when "ボス戦2"
      RPG::BGM.new("052-Negative01",vol+10,100).play
    when "ラストバトル"
      RPG::BGM.new("010-LastBoss02",vol+10,100).play
    when "リドル"
      RPG::BGM.new("041-Dungeon07",vol+10,100).play
    when "NPC1"
      RPG::BGM.new("xp_forest",vol,100).play
    when "NPC2"
      RPG::BGM.new("xp_forest",vol,100).play
    when "NPC3"
      RPG::BGM.new("xp_forest",vol,100).play
    when "NPC4"
      RPG::BGM.new("xp_forest",vol,100).play
    when "NPC5"
      RPG::BGM.new("baroque15-cem",vol,100).play
    when "NPC7"
      RPG::BGM.new("xp_forest",vol,100).play
    when "NPC8"
      RPG::BGM.new("xp_forest",vol,100).play
    when "NPC9"
      RPG::BGM.new("xp_forest",vol,100).play
    when "洞窟家族"
      RPG::BGM.new("056-Negative05",vol+10,100).play
    when "エンディング"
      RPG::BGM.new("positive02",vol,100).play
    when "満月亭"
      RPG::BGM.new("028-Town06",vol+10,100).play
    when "四大元素アイテム"
      RPG::BGM.new("032-Church01",vol+10,100).play

    when "B1F"; RPG::BGM.new("New-Paradise_loop",vol,100).play
    when "B2F"; RPG::BGM.new("040-Dungeon06",vol+10,100).play
    when "B3F"; RPG::BGM.new("039-Dungeon05",vol+10,100).play
    when "B4F"; RPG::BGM.new("055-Negative04",vol+10,100).play
    when "B5F"; RPG::BGM.new("baroque10-cem",vol,100).play
    when "B6F"; RPG::BGM.new("baroque17-cem",vol,100).play
    when "B7F"; RPG::BGM.new("Mysty-Valley_loop",vol,100).play
    when "B8F"; RPG::BGM.new("042-Dungeon08",vol+10,100).play
    when "B9F"; RPG::BGM.new("022-Field05",vol+10,100).play
      # Tower-of-despair => B9F,B8F
    when "泉";  RPG::BGM.new("020-Field03",vol+10,100).play
    when "静かなる泉";  RPG::BGM.new("062-Slow05",vol+10,100).play
    when "休息中";  RPG::BGM.new("baroque14-cem",vol,100).play
    when "邪神像";  RPG::BGM.new("006-Boss02",vol+10,100).play
    when "墓石";  RPG::BGM.new("xp_mission",vol, 50).play
    when "悪意の冒険者";  RPG::BGM.new("006-Boss02",vol+10,100).play
    when ""
      RPG::BGM.stop
      RPG::BGS.stop
    end
  end

  def me_play(scene)
    vol = $master_me_volume
    adjust = Constant_Table::SE_VOL_ADJUST
    case scene
    when "レベルアップ";    RPG::ME.new("baroque29-cem",vol,100).play
    when "きょうかい";      RPG::ME.new("xp_inn1",vol,100).play
    when "エンカウント";    RPG::ME.new("jingle-surprise03-wav",vol,100).play
    when "戦闘終了";        RPG::ME.new("baroque28-cem",vol,100).play
    when "泉";              RPG::ME.new("Dive",vol,100).play
    when "邪神像：パーティマジックの付与"; RPG::ME.new("Heal4",vol,100).play
    when "邪神像：ダメージ";      RPG::ME.new("魔王魂-レトロ12",vol-adjust,100).play
    when "邪神像：経験値の取得";  RPG::ME.new("Barrier",vol,100).play
    when "logo";            RPG::ME.new("jingle-logo01-wav",vol,100).play
    when "罠を見破れ";      RPG::ME.new("confuse",vol,100).play
    when "転職";            RPG::ME.new("baroque25-cem",vol,100).play
    end
  end

  def se_play(scene)
    vol = $master_se_volume
    adjust = Constant_Table::SE_VOL_ADJUST
    case scene
    when "カーソル"; RPG::SE.new("Cursor",vol-10,150).play
    when "決定"; RPG::SE.new("Decision1",vol-10,100).play
    when "キャンセル"; RPG::SE.new("Cancel",vol-10,100).play
    when "階段";          RPG::SE.new("move",vol-adjust,90).play
    when "逃走";          RPG::SE.new("move",vol-adjust,100).play
    when "戦闘開始";          RPG::SE.new("Absorb1",vol,100).play
    when "たからばこ";    RPG::SE.new("Key",vol,100).play
    when "罠調査";    RPG::SE.new("Key",vol,50).play
    when "解錠";          RPG::SE.new("Chest",vol,100).play
    when "うまくいかない"; RPG::SE.new("Chest",vol,100).play
    when "宝箱：開"; RPG::SE.new("se_maoudamashii_se_door01",vol,100).play
    when "仕掛け弓";      RPG::SE.new("Bow1",vol,100).play
    when "甘い香り";      RPG::SE.new("Fog1",vol,100).play
    when "毒霧";          RPG::SE.new("Breath",vol,100).play
    when "マルチショット"; RPG::SE.new("魔王魂-レトロ03",vol-adjust,100).play
    when "ダメージ無し"; RPG::SE.new("魔王魂-レトロ11",vol-adjust,100).play
    when "敵ダメージ"; RPG::SE.new("魔王魂-レトロ22",vol-adjust,100).play
    when "首はね"; RPG::SE.new("魔王魂-レトロ28",vol-adjust,100).play
    when "フィニッシュブロー"; RPG::SE.new("Blow4",vol,100).play
    when "敵消滅"; RPG::SE.new("Collapse1",vol,100).play
    when "敵攻撃"; RPG::SE.new("Attack1",vol,100).play
    when "味方ダメージ"; RPG::SE.new("魔王魂-レトロ12",vol-adjust,100).play
    when "味方戦闘不能male"; RPG::SE.new("yan_06_male_uaa",vol,100).play
    when "味方戦闘不能female"; RPG::SE.new("se_maoudamashii_voice_human02",vol,100).play
    when "呪文詠唱"; RPG::SE.new("魔王魂-レトロ13",vol-adjust,100).play
    when "呪文詠唱RC"; RPG::SE.new("魔王魂-レトロ14",vol-adjust,100).play
    when "回復"; RPG::SE.new("魔王魂-レトロ08",vol-adjust,100).play
    when "足音1"; RPG::SE.new("魔王魂-se-足音01",vol-adjust,50).play
    when "足音2"; RPG::SE.new("魔王魂-se-足音02",vol-adjust,50).play
    when "ひらかない"; RPG::SE.new("Close2",vol,100).play
    when "扉を進む"; RPG::SE.new("Switch3",vol,100).play
    when "レバー"; RPG::SE.new("Switch3",vol,60).play
    when "いたい"; RPG::SE.new("Earth6",vol,100).play
    when "鉄の扉"; RPG::SE.new("Open3",vol,100).play
    when "鍵"; RPG::SE.new("Key",vol,100).play
    when "ワープ"; RPG::SE.new("Fog1",vol,100).play
    when "回転床"; RPG::SE.new("魔王魂-レトロ09",vol-adjust,100).play
    when "ピット"; RPG::SE.new("魔王魂-レトロ22",vol-adjust,100).play
    when "落盤"; RPG::SE.new("魔王魂-レトロ20",vol-adjust,100).play
    when "毒の矢"; RPG::SE.new("Bow1",vol,100).play
    when "閂"; RPG::SE.new("Open1",vol,100).play
    when "開錠"; RPG::SE.new("Open1",vol,100).play
    when "シュート"; RPG::SE.new("Fall",vol,100).play
    when "シュート着地"; RPG::SE.new("魔王魂-レトロ12",vol-adjust,100).play
    when "スイッチ"; RPG::SE.new("Switch1",vol,100).play
    when "アイテム"; RPG::SE.new("魔王魂-レトロ03",vol-adjust,100).play
    when "用水路"; RPG::SE.new("Water1",vol,100).play
    when "ブラスター"; RPG::SE.new("Fire7",vol,100).play
    when "爆弾"; RPG::SE.new("Explosion4",vol,100).play
    when "呪文成長"; RPG::SE.new("Magic",vol,100).play
    when "シークレットドア"; RPG::SE.new("Fog1",vol,100).play
    when "動作音"; RPG::SE.new("Heal4",vol,100).play
    when "Fizzle"; RPG::SE.new("Darkness1",vol,100).play
    when "SS"; RPG::SE.new("Load",vol,100).play
    when "発見"; RPG::SE.new("Raise2",vol,100).play
    when "金ダイス"; RPG::SE.new("Chicken",vol,100).play
    when "セーブ"; RPG::SE.new("Magic",vol,100).play
    when "合成成功"; RPG::SE.new("Key",vol,100).play
    when "合成"; RPG::SE.new("Saint8",vol,100).play
    when "合成失敗"; RPG::SE.new("Paralyze2",vol,100).play
    when "購入"; RPG::SE.new("Shop",vol,100).play
    when "フォーリーブス"; RPG::SE.new("Flash2",vol,100).play
    when "金切り声"; RPG::SE.new("Sound3",vol,100).play
    when "肥し爆弾"; RPG::SE.new("Explosion5",vol,100).play
    when "記憶の霧"; RPG::SE.new("Fog1",vol,100).play
    when "アラーム"; RPG::SE.new("魔王魂-レトロ15",vol-adjust,100).play
    when "大電流"; RPG::SE.new("Thunder10",vol,100).play
    when "幽霊"; RPG::SE.new("Darkness5",vol,100).play
    when "突風"; RPG::SE.new("Wind8",vol,100).play
    when "神の瞬き"; RPG::SE.new("Silence",vol,100).play
    when "謎の瘴気"; RPG::SE.new("Darkness3",vol,100).play
    when "蟲の大群"; RPG::SE.new("Darkness1",vol,100).play
    when "玉手箱"; RPG::SE.new("Fog1",vol,100).play
    when "サフォケーション"; RPG::SE.new("魔王魂-レトロ24",vol-adjust,100).play
    when "PM_Expire"; RPG::SE.new("Collapse1",vol,100).play
    when "ベアトラップ"; RPG::SE.new("Bite",vol,100).play
    when "盾発動"; RPG::SE.new("Shot2",vol,100).play
    when "ミス"; RPG::SE.new("Miss",vol,100).play
    when "召喚倒れる"; RPG::SE.new("魔王魂-レトロ17",vol-adjust,100).play
    when "心眼"; RPG::SE.new("Saint9",vol,100).play
    when "パワーヒット"; RPG::SE.new("Thunder2",vol,100).play
    when "インパクト"; RPG::SE.new("Blow7",vol,100).play
    when "毒ダメージ"; RPG::SE.new("Poison",vol,100).play
    when "出血ダメージ"; RPG::SE.new("Paralyze2",vol,100).play
    when "ヒーリング"; RPG::SE.new("Raise3",vol,100).play
    when "毒霧"; RPG::SE.new("Sand",vol,50).play
    when "呪文禁止床"; RPG::SE.new("Confuse",vol,100).play
    when "可燃性ガス爆発大"; RPG::SE.new("Explosion2",vol,100).play
    when "可燃性ガス爆発小"; RPG::SE.new("Explosion2",vol-20,100).play
    when "壁破壊"; RPG::SE.new("Earth9",vol,100).play
    end
  end
end

