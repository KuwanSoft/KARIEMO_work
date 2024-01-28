#==============================================================================
# ■ Cache
#------------------------------------------------------------------------------
# 各種グラフィックを読み込み、Bitmap オブジェクトを作成、保持するモジュール
# です。読み込みの高速化とメモリ節約のため、作成した Bitmap オブジェクトを内部
# のハッシュに保存し、同じビットマップが再度要求されたときに既存のオブジェクト
# を返すようになっています。
#==============================================================================

module Cache
  #--------------------------------------------------------------------------
  # ● アニメーション グラフィックの取得
  #     filename : ファイル名
  #     hue      : 色相変化値
  #--------------------------------------------------------------------------
  def self.animation(filename, hue)
    load_bitmap("Graphics/Animations/", filename, hue)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘グラフィックの取得
  #     filename : ファイル名
  #     hue      : 色相変化値
  #--------------------------------------------------------------------------
  def self.battler(filename, hue)
    load_bitmap("Graphics/Battlers/", filename, hue)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘グラフィックの取得(不確定状態)
  #     filename : ファイル名
  #     hue      : 色相変化値
  #--------------------------------------------------------------------------
  def self.blind_battler(filename, hue)
    load_bitmap("Graphics/Battlers/Blind/", filename, hue)
  end
  #--------------------------------------------------------------------------
  # ● 歩行グラフィックの取得
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.character(filename)
    load_bitmap("Graphics/Characters/", filename)
  end
  #--------------------------------------------------------------------------
  # ● 顔グラフィックの取得
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.face(filename)
    load_bitmap("Graphics/Portraits/", filename)
  end
  #--------------------------------------------------------------------------
  # ● 遠景グラフィックの取得
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.parallax(filename)
    load_bitmap("Graphics/Parallaxes/", filename)
  end
  #--------------------------------------------------------------------------
  # ● ピクチャ グラフィックの取得
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.picture(filename)
    load_bitmap("Graphics/Pictures/", filename)
  end
  #--------------------------------------------------------------------------
  # ● システム グラフィックの取得
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.system(filename)
    load_bitmap("Graphics/System/", filename)
  end
  #--------------------------------------------------------------------------
  # ● アイコングラフィックの取得
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.icon(filename)
    load_bitmap("Graphics/System/icon/", filename)
  end
  #--------------------------------------------------------------------------
  # ● システム グラフィックの取得(反転必要なし)
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.icon_sub(filename)
    load_bitmap("Graphics/System/icon/sub/", filename)
  end
  #--------------------------------------------------------------------------
  # ● ステータスアイコングラフィックの取得
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.state(filename)
    load_bitmap("Graphics/System/State_icon/", filename)
  end
  #--------------------------------------------------------------------------
  # ● マップタイルグラフィックの取得
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.map_tile(filename)
    load_bitmap("Graphics/Pictures/maptiles2/", filename)
  end
  #--------------------------------------------------------------------------
  # ● システムグラフィックの取得
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.system_icon(filename)
    load_bitmap("Graphics/System/icon/", filename)
  end
  #--------------------------------------------------------------------------
  # ● ダンジョングラフィックの取得
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def self.dungeon(filename)
    load_bitmap("Graphics/System/Dungeon/", filename)
  end
  #--------------------------------------------------------------------------
  # ● キャッシュのクリア
  #--------------------------------------------------------------------------
  def self.clear
    @cache = {} if @cache == nil
    @cache.clear
    GC.start
  end
  #--------------------------------------------------------------------------
  # ● ビットマップの読み込み
  #--------------------------------------------------------------------------
  def self.load_bitmap(folder_name, filename, hue = 0)
    @cache = {} if @cache == nil
    path = folder_name + filename
    if not @cache.include?(path) or @cache[path].disposed?
      if filename.empty?
        @cache[path] = Bitmap.new(32, 32)
      else
        @cache[path] = Bitmap.new(path)
      end
    end
    if hue == 0
      return @cache[path]
    else
      key = [path, hue]
      if not @cache.include?(key) or @cache[key].disposed?
        @cache[key] = @cache[path].clone
        @cache[key].hue_change(hue)
      end
      return @cache[key]
    end
  end
end