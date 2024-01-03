class View_Map < WindowBase
  #--------------------------------------------------------------------------
  # ● 初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 0, 0, 512, 448-12)
    self.visible = false
    self.z = 240
    @prepared = false   # 準備済みフラグ
  end
  #--------------------------------------------------------------------------
  # ● 準備
  #--------------------------------------------------------------------------
  def prepare
    return if @prepared
    # 座標軸の描画
    @wall = []  # 描画する壁にSpriteを定義
    @door = []  # 描画するドアにSpriteを定義
    @door2 = []  # 描画するドアにSpriteを定義
    @floor = [] # 描画する床にSpriteを定義
    adjx = self.x + 20 # 描画位置x軸のアジャスト
    adjy = self.y + 20 # 描画位置y軸アジャスト
    pix = 16
    for i in 0..49
      @wall[i] = [0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6]
      for j in 0..49
        @wall[i][j] = Sprite.new
        @wall[i][j].x = i * pix + adjx +0 # 1タイル12ピクセル
        @wall[i][j].y = j * pix + adjy +0 # 1タイル12ピクセル
        @wall[i][j].z = 253
      end
    end
    for i in 0..49
      @door[i] = [0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6]
      @door2[i] = [0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6]
      for j in 0..49
        @door[i][j] = Sprite.new
        @door[i][j].x = i * pix + adjx +0 # 1タイル12ピクセル
        @door[i][j].y = j * pix + adjy +0 # 1タイル12ピクセル
        @door[i][j].z = 255
        @door2[i][j] = Sprite.new
        @door2[i][j].x = i * pix + adjx +0 # 1タイル12ピクセル
        @door2[i][j].y = j * pix + adjy +0 # 1タイル12ピクセル
        @door2[i][j].z = 255
      end
    end
    for i in 0..49
      @floor[i] = [0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6]
      for j in 0..49
        @floor[i][j] = Sprite.new
        @floor[i][j].x = i * pix + adjx +0 # 1タイル12ピクセル
        @floor[i][j].y = j * pix + adjy +0 # 1タイル12ピクセル
        @floor[i][j].z = 254
      end
    end
    ## 中心マークの定義
    @center = Sprite.new
    @center.x = 11 * pix + adjx
    @center.y = 11 * pix + adjy
    @center.z = 255
    @prepared = true
  end
  #--------------------------------------------------------------------------
  # ● 描画
  #--------------------------------------------------------------------------
  def prepare_back
    bitmap = Cache.map_tile("map_back")
    self.contents.blt(0, 0, bitmap, bitmap.rect)
  end
  #--------------------------------------------------------------------------
  # ● 下地の描画
  #--------------------------------------------------------------------------
  def draw_floor(mapid, x, y)
    self.contents.clear
    prepare_back
    self.contents.draw_text(0,0,self.width-32,WLH,"げん     ", 2)
    self.contents.draw_text(0,WLH*1,self.width-32,WLH,"ざいち", 2)
    self.contents.draw_text(0,WLH*2,self.width-32,WLH,"← B#{mapid}F →", 2)
    self.contents.draw_text(0,WLH*3,self.width-32,WLH,"L        R", 2)
    self.contents.draw_text(0,448-12-WLH-32, self.width-32, WLH, "x:#{x} y:#{y}")
  end
  #--------------------------------------------------------------------------
  # ● 描画
  #   point_x, point_y: プレイヤー座標
  #--------------------------------------------------------------------------
  def start_drawing(point_x, point_y, mapid, mapdata_id, ndp)
    # Debug::write(c_m, "MAPID:フロアB#{mapid}Fの描画開始 x:#{point_x} y:#{point_y}")
    draw_floor(mapid, point_x, point_y)
    prepare # 準備開始
    ##> アクターIDが合致するマップオブジェクトを取得
    use_map = $game_mapkits[mapdata_id] # マップデータの選択
    use_map.merge_map_data(true)        # マップデータのマージ
    reset   # 一度消してから描画しなおす
    @center.bitmap = Cache.map_tile("CENTER")
    self.visible = true
    i = 0
    j = 0
    map_range = 11
    x_map_range_minus = point_x - map_range
    x_map_range_plus = point_x + map_range
    y_map_range_minus = point_y - map_range
    y_map_range_plus = point_y + map_range
    for x in (x_map_range_minus)..(x_map_range_plus)
      for y in (y_map_range_minus)..(y_map_range_plus)
        ##> 到達したことがある場合は壁情報
        now_info = $game_player.visit[x, y, mapid]
        ##> 座標が無い場合はブランク
        now_info = nil if x < 0 or y < 0
        ##> マップデータにある場合のみ描画
        now_info = nil unless use_map.map_table[x, y, mapid] == 1
        ##> 指定した座標の壁情報を記憶からとってくる
        if now_info

          n = now_info / (2 ** 10) % 2
          e = now_info / (2 **  9) % 2
          s = now_info / (2 **  8) % 2
          w = now_info / (2 **  7) % 2
          wall = now_info / (2**7)
          nd = now_info / (2 **  6) % 2
          ed = now_info / (2 **  5) % 2
          sd = now_info / (2 **  4) % 2
          wd = now_info / (2 **  3) % 2
          door = now_info / (2**3) % (2**4)
          floor = now_info % (2**3)

          case wall # 壁を描画
          when 0b0000; @wall[i][j].bitmap = Cache.map_tile("W0000")
          when 0b1000; @wall[i][j].bitmap = Cache.map_tile("W1000")
          when 0b0100; @wall[i][j].bitmap = Cache.map_tile("W0100")
          when 0b0010; @wall[i][j].bitmap = Cache.map_tile("W0010")
          when 0b0001; @wall[i][j].bitmap = Cache.map_tile("W0001")
          when 0b0111; @wall[i][j].bitmap = Cache.map_tile("W0111")
          when 0b1011; @wall[i][j].bitmap = Cache.map_tile("W1011")
          when 0b1101; @wall[i][j].bitmap = Cache.map_tile("W1101")
          when 0b1110; @wall[i][j].bitmap = Cache.map_tile("W1110")
          when 0b1100; @wall[i][j].bitmap = Cache.map_tile("W1100")
          when 0b0110; @wall[i][j].bitmap = Cache.map_tile("W0110")
          when 0b0011; @wall[i][j].bitmap = Cache.map_tile("W0011")
          when 0b1001; @wall[i][j].bitmap = Cache.map_tile("W1001")
          when 0b1010; @wall[i][j].bitmap = Cache.map_tile("W1010")
          when 0b0101; @wall[i][j].bitmap = Cache.map_tile("W0101")
          when 0b1111; @wall[i][j].bitmap = Cache.map_tile("W1111")
          end
          case door # ドアを描画
          when 0b1000; @door[i][j].bitmap = Cache.map_tile("D1000")
          when 0b0100; @door[i][j].bitmap = Cache.map_tile("D0100")
          when 0b0010; @door[i][j].bitmap = Cache.map_tile("D0010")
          when 0b0001; @door[i][j].bitmap = Cache.map_tile("D0001")
          when 0b0111; @door[i][j].bitmap = Cache.map_tile("D0111")
          when 0b1011; @door[i][j].bitmap = Cache.map_tile("D1011")
          when 0b1101; @door[i][j].bitmap = Cache.map_tile("D1101")
          when 0b1110; @door[i][j].bitmap = Cache.map_tile("D1110")
          when 0b1100; @door[i][j].bitmap = Cache.map_tile("D1100")
          when 0b0110; @door[i][j].bitmap = Cache.map_tile("D0110")
          when 0b0011; @door[i][j].bitmap = Cache.map_tile("D0011")
          when 0b1001; @door[i][j].bitmap = Cache.map_tile("D1001")
          when 0b1010; @door[i][j].bitmap = Cache.map_tile("D1010")
          when 0b0101; @door[i][j].bitmap = Cache.map_tile("D0101")
          when 0b1111; @door[i][j].bitmap = Cache.map_tile("D1111")
          end

          ## 隠し扉の描画
          if $game_player.kakushi[x, y, mapid] != nil
            case $game_player.kakushi[x, y, mapid]
            when 8; @door2[i][j].bitmap = Cache.map_tile("D2000")
            when 6; @door2[i][j].bitmap = Cache.map_tile("D0200")
            when 2; @door2[i][j].bitmap = Cache.map_tile("D0020")
            when 4; @door2[i][j].bitmap = Cache.map_tile("D0002")
            end
          end

          ## 0=nothing,2=階段,(1=event),3=dz,(4=玄室),5=elv,6=water,7=magic,8=randomは使用済み
          ## 2(0b010),5(b101),7(0b111)を階段2種に使う
          case floor # 床を描画
          when 0b000; @floor[i][j].bitmap = Cache.map_tile("DUMMY")     # 0呪文禁止
          when 0b010; @floor[i][j].bitmap = Cache.map_tile("STAIRup")   # 2階段上
          when 0b101; @floor[i][j].bitmap = Cache.map_tile("STAIRdown") # 5階段下
          when 0b011; @floor[i][j].bitmap = Cache.map_tile("FFFF")      # 3ダークゾーン
          when 0b111; @floor[i][j].bitmap = Cache.map_tile("ELEVATOR")  # 7エレベーター
          when 0b110; @floor[i][j].bitmap = Cache.map_tile("WATER")     # 6水たまり
          end
          # パーティの場所を表示
          unless ndp
            case $game_player.direction
            when 6; bitmap = Cache.map_tile("PARTY_E")
            when 2; bitmap = Cache.map_tile("PARTY_S")
            when 4; bitmap = Cache.map_tile("PARTY_W")
            when 8; bitmap = Cache.map_tile("PARTY_N")
            end
            if $game_player.x == x and $game_player.y == y
              @floor[i][j].bitmap = bitmap
            end
          end
        else
        end
        j += 1
      end
      i += 1
      j = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● リセット
  #--------------------------------------------------------------------------
  def reset
    self.visible = false
    for i in 0..49
      for j in 0..49
        @wall[i][j].bitmap = nil if @wall[i][j].bitmap
        @door[i][j].bitmap = nil if @door[i][j].bitmap
        @door2[i][j].bitmap = nil if @door2[i][j].bitmap
        @floor[i][j].bitmap = nil if @floor[i][j].bitmap
      end
    end
    @center.bitmap = nil if @center.bitmap
  end
  #--------------------------------------------------------------------------
  # ● DISPOSE
  #--------------------------------------------------------------------------
  def dispose
    super
    for i in 0..49
      for j in 0..49
        @wall[i][j].dispose
        @door[i][j].dispose
        @door2[i][j].dispose
        @floor[i][j].dispose
      end
    end
    @center.bitmap.dispose if @center.bitmap
    @center.dispose
  end
end
