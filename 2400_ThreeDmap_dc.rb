class ThreeDmap < Scene_Map
  attr_reader   :kakushi               # 隠し扉
  ADJ_SCREEN_Y = 40
  #--------------------------------------------------------------------------
  # ● 初期化：すべての壁を定義
  #--------------------------------------------------------------------------
	def initialize
    define_all_wall
    @prev_tone = Tone.new(0,0,0)
  end
  #--------------------------------------------------------------------------
  # ● すべての壁を不可視
  #--------------------------------------------------------------------------
  def no_visible_all_wall
    for key in @wall.keys
      @wall[key].visible = false
    end
    for key in @door.keys
      @door[key].visible = false
    end
    for key in @iron_door.keys
      @iron_door[key].visible = false
    end
    for key in @up_stairs.keys
      @up_stairs[key].visible = false
    end
    for key in @down_stairs.keys
      @down_stairs[key].visible = false
    end
    # for key in @t_wall.keys
    #   @t_wall[key].visible = false
    # end
    for key in @floor.keys
      @floor[key].visible = false
    end
    @field.visible = false
    # @kakushi.visible = false
    @switch_wall.visible = false
    @chest_wall.visible = false
    @darkzone.visible = false
    @drawing_fountain.visible = false
    # @frame.visible = false
    # @frame_b.visible = false
  end
  #--------------------------------------------------------------------------
  # ● メインルーチン
  #   基本的には1歩ごとにこれを呼び出す
  #--------------------------------------------------------------------------
  def start_drawing(no_step = false)
    no_visible_all_wall
    # define_all_wall($game_map.map_id)
    check_wall_info
    draw_walls(no_step) unless $game_party.light < 1
    # draw_kakushi unless $game_party.light < 1
    draw_darkzone unless $game_party.light < 1
    draw_frame
    check_drawing_fountain
    change_wall_tone(@prev_tone)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘用バックスプライト
  #--------------------------------------------------------------------------
  def start_drawing_for_battle
    no_visible_all_wall
    draw_field(true)
  end
  #--------------------------------------------------------------------------
  # ● 枠の描画
  #--------------------------------------------------------------------------
  def draw_frame
    # @frame.visible = true
    # @frame_b.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 壁の描画
  #--------------------------------------------------------------------------
	def draw_wall(loc)
		@wall["#{loc}"].visible = true
    # DEBUG.write(c_m, "壁(#{loc})描画開始")
  end
  #--------------------------------------------------------------------------
  # ● 扉の描画
  #--------------------------------------------------------------------------
  def draw_door(loc)
    @wall["#{loc}"].visible = false # 扉と壁が重なるので、壁を消す
#~     case $game_map.map_id
#~     when 1 ; @door["#{loc}"].tone = Constant_Table::TONE_B1F
#~     when 2 ; @door["#{loc}"].tone = Constant_Table::TONE_B2F
#~     end
		@door["#{loc}"].visible = true
  end
  #--------------------------------------------------------------------------
  # ● 発見済み石壁シークレットは消す
  #--------------------------------------------------------------------------
  def erase_wall(loc)
    @wall["#{loc}"].visible = false # シークレットは消す
    @door["#{loc}"].visible = false
  end
  #--------------------------------------------------------------------------
  # ● スイッチ壁の描画
  #--------------------------------------------------------------------------
  def draw_switch_wall
    @switch_wall.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 宝箱壁の描画
  #--------------------------------------------------------------------------
  def draw_chest_wall
    @chest_wall.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 水汲み壁の描画
  #--------------------------------------------------------------------------
  def draw_drawing_fountain
    $game_temp.drawing_fountain = true
    @drawing_fountain.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 水汲み壁がREADYか？
  #--------------------------------------------------------------------------
  def check_drawing_fountain
    if $game_temp.drawing_fountain
      @drawing_fountain.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 扉をあけるアニメーション
  #--------------------------------------------------------------------------
  def door_open(page)
    case $game_map.map_id
    when 1,2,5,6,8
      case page
      when 1; @door["1"].bitmap = Cache.dungeon("1D_open1")
      when 2; @door["1"].bitmap = Cache.dungeon("1D_open2")
      when 0; @door["1"].bitmap = Cache.dungeon("1D")
      end
    else
      case page
      when 1; @door["1"].bitmap = Cache.dungeon("1D_b_open1")
      when 2; @door["1"].bitmap = Cache.dungeon("1D_b_open2")
      when 0; @door["1"].bitmap = Cache.dungeon("1D_b")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 鉄格子をあけるアニメーション
  #--------------------------------------------------------------------------
  def iron_door_open(page)
    case page
    when 1; @iron_door["1"].bitmap = Cache.dungeon("1D+_open1")
    when 2; @iron_door["1"].bitmap = Cache.dungeon("1D+_open2")
    when 3; @iron_door["1"].bitmap = Cache.dungeon("1D+_open3")
    when 0; @iron_door["1"].bitmap = Cache.dungeon("1D+")
    end
  end
  #--------------------------------------------------------------------------
  # ● 鉄格子をあけるアニメーション
  #--------------------------------------------------------------------------
  def collapse_wall(page)
    case page
    when 1; @wall["1"].bitmap = Cache.dungeon("1_b_col1")
    when 2; @wall["1"].bitmap = Cache.dungeon("1_b_col2")
    when 3; @wall["1"].bitmap = Cache.dungeon("1_b_col3")
    when 4; @wall["1"].bitmap = Cache.dungeon("1_b_col4")
    when 5; @wall["1"].bitmap = Cache.dungeon("1_b_col5")
    when 6; @wall["1"].visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 上り階段の描画
  #--------------------------------------------------------------------------
  def draw_up_stairs(loc)
    @wall["#{loc}"].visible = false # 扉と壁が重なるので、壁を消す
		@door["#{loc}"].visible = false # 通常扉も消す
		@up_stairs["#{loc}"].visible = true
  end
  #--------------------------------------------------------------------------
  # ● 下り階段の描画
  #--------------------------------------------------------------------------
  def draw_down_stairs(loc)
    @wall["#{loc}"].visible = false # 扉と壁が重なるので、壁を消す
		@door["#{loc}"].visible = false # 通常扉も消す
#~     case $game_map.map_id
#~     when 1 ; @down_stairs["#{loc}"].tone = Constant_Table::TONE_B1F
#~     when 2 ; @down_stairs["#{loc}"].tone = Constant_Table::TONE_B2F
#~     end
		@down_stairs["#{loc}"].visible = true
  end
  #--------------------------------------------------------------------------
  # ● 鉄格子の描画
  #--------------------------------------------------------------------------
  def draw_iron_door(loc)
    @wall["#{loc}"].visible = false # 扉と壁が重なるので、壁を消す
		@door["#{loc}"].visible = false # 通常扉も消す
#~     case $game_map.map_id
#~     when 1 ; @iron_door["#{loc}"].tone = Constant_Table::TONE_B1F
#~     when 2 ; @iron_door["#{loc}"].tone = Constant_Table::TONE_B2F
#~     end
		@iron_door["#{loc}"].visible = true
  end
  #--------------------------------------------------------------------------
  # ● 宝箱壁の描画
  #   表示させない in0.91
  #--------------------------------------------------------------------------
  def draw_t_wall(loc)
    ## 表示させない
#~     @wall["#{loc}"].visible = false # 扉と壁が重なるので、壁を消す
#~ 		@door["#{loc}"].visible = false # 通常扉も消す
#~ 		@t_wall["#{loc}"].visible = true
  end
  #--------------------------------------------------------------------------
  # ● 一歩先のダークゾーンの描画
  #--------------------------------------------------------------------------
  def draw_darkzone
    return unless check_darkzone  # 一歩先がダークゾーンでなければリターン
    @wall["#{6}"].visible = false # 扉と壁が重なるので、壁を消す
		@door["#{6}"].visible = false # 通常扉も消す
		@darkzone.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 床の描画
  #--------------------------------------------------------------------------
  def draw_floor(loc)
    if ["A-","B-","C-","D-","E-","F-","I-","J-","K-","L-","M-","N-","O-","P-","Q-","R-"].include?(loc)
      @floor["#{loc}"].visible = true
    end
#~     if ["+","-"].include?(loc.scan(/(.$)/)[0][0])
#~       before_loc = loc.scan(/(^.)/)[0][0].to_s
#~       @floor["#{before_loc}"].visible = false
#~     end
#~     @floor["#{loc}"].visible = true
  end
  #--------------------------------------------------------------------------
  # ● 床の描画2
  #--------------------------------------------------------------------------
  def draw_field(no_step = false)
    if (@prev_x == $game_player.x) and
    (@prev_y == $game_player.y) and
    (@prev_direction == $game_player.direction) then

    else
      @step = !@step unless no_step
    end
    case @step
    when true;
      case $game_map.map_id
      when 1,2,5,6,8
        @field.bitmap = Cache.dungeon("field")
      when 3,4
        @field.bitmap = Cache.dungeon("field2")
      when 7
        @field.bitmap = Cache.dungeon("field3")
      when 9
        @field.bitmap = Cache.dungeon("field4")
      end
    when false;
      case $game_map.map_id
      when 1,2,5,6,8
        @field.bitmap = Cache.dungeon("field_b")
      when 3,4
        @field.bitmap = Cache.dungeon("field2_b")
      when 7
        @field.bitmap = Cache.dungeon("field3_b")
      when 9
        @field.bitmap = Cache.dungeon("field4_b")
      end
    end
    @prev_x = $game_player.x
    @prev_y = $game_player.y
    @prev_direction = $game_player.direction
    @field.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 発見済みシークレットドアの描画
  #--------------------------------------------------------------------------
  def draw_secret_door(wall)
    x = $game_player.x
    y = $game_player.y
    id = $game_map.map_id
    case $game_player.direction
    when 8  # 北
      up = 8
      right = 6
      left = 4
      down = 2
      case wall
      when 1,2,3;     adj_x = 0; adj_y = 0;
      when 6,7,8;     adj_x = 0; adj_y = -1;
      when 19,15,16;  adj_x = 0; adj_y = -2;
      when 24,27,28;  adj_x = 0; adj_y = -3;
      when 4;         adj_x = -1; adj_y = 0;
      when 9,13;      adj_x = -1; adj_y = -1;
      when 20,17;     adj_x = -1; adj_y = -2;
      when 25,29;     adj_x = -1; adj_y = -3;
      when 5;         adj_x = 1; adj_y = 0;
      when 10,14;     adj_x = 1; adj_y = -1;
      when 21,18;     adj_x = 1; adj_y = -2;
      when 26,30;     adj_x = 1; adj_y = -3;
      when 11;        adj_x = -2; adj_y = -1;
      when 22;        adj_x = -2; adj_y = -2;
      when 12;        adj_x = 2; adj_y = -1;
      when 23;        adj_x = 2; adj_y = -2;
      end
      case wall
      when 1,6,19,24,4,9,20,25,5,10,21,26,11,22,12,23
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == up)
      when 2,7,15,27,13,17,29
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == left)
      when 3,8,16,28,14,18,30
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == right)
      end
    when 6  # 東
      up = 6
      right = 2
      left = 8
      down = 4
      case wall
      when 1,2,3;     adj_x = 0; adj_y = 0;
      when 6,7,8;     adj_x = 1; adj_y = 0;
      when 19,15,16;  adj_x = 2; adj_y = 0;
      when 24,27,28;  adj_x = 3; adj_y = 0;
      when 4;         adj_x = 0; adj_y = -1;
      when 9,13;      adj_x = 1; adj_y = -1;
      when 20,17;     adj_x = 2; adj_y = -1;
      when 25,29;     adj_x = 3; adj_y = -1;
      when 5;         adj_x = 0; adj_y = 1;
      when 10,14;     adj_x = 1; adj_y = 1;
      when 21,18;     adj_x = 2; adj_y = 1;
      when 26,30;     adj_x = 3; adj_y = 1;
      when 11;        adj_x = 1; adj_y = -2;
      when 22;        adj_x = 2; adj_y = -2;
      when 12;        adj_x = 1; adj_y = 2;
      when 23;        adj_x = 2; adj_y = 2;
      end
      case wall
      when 1,6,19,24,4,9,20,25,5,10,21,26,11,22,12,23
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == up)
      when 2,7,15,27,13,17,29
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == left)
      when 3,8,16,28,14,18,30
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == right)
      end
    when 2  # 南
      up = 2
      right = 4
      left = 6
      down = 8
      case wall
      when 1,2,3;     adj_x = 0; adj_y = 0;
      when 6,7,8;     adj_x = 0; adj_y = 1;
      when 19,15,16;  adj_x = 0; adj_y = 2;
      when 24,27,28;  adj_x = 0; adj_y = 3;
      when 4;         adj_x = 1; adj_y = 0;
      when 9,13;      adj_x = 1; adj_y = 1;
      when 20,17;     adj_x = 1; adj_y = 2;
      when 25,29;     adj_x = 1; adj_y = 3;
      when 5;         adj_x = -1; adj_y = 0;
      when 10,14;     adj_x = -1; adj_y = 1;
      when 21,18;     adj_x = -1; adj_y = 2;
      when 26,30;     adj_x = -1; adj_y = 3;
      when 11;        adj_x = 2; adj_y = 1;
      when 22;        adj_x = 2; adj_y = 2;
      when 12;        adj_x = -2; adj_y = 1;
      when 23;        adj_x = -2; adj_y = 2;
      end
      case wall
      when 1,6,19,24,4,9,20,25,5,10,21,26,11,22,12,23
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == up)
      when 2,7,15,27,13,17,29
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == left)
      when 3,8,16,28,14,18,30
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == right)
      end
    when 4  # 西
      up = 4
      right = 8
      left = 2
      down = 6
      case wall
      when 1,2,3;     adj_x = 0; adj_y = 0;
      when 6,7,8;     adj_x = -1; adj_y = 0;
      when 19,15,16;  adj_x = -2; adj_y = 0;
      when 24,27,28;  adj_x = -3; adj_y = 0;
      when 4;         adj_x = 0; adj_y = 1;
      when 9,13;      adj_x = -1; adj_y = 1;
      when 20,17;     adj_x = -2; adj_y = 1;
      when 25,29;     adj_x = -3; adj_y = 1;
      when 5;         adj_x = 0; adj_y = -1;
      when 10,14;     adj_x = -1; adj_y = -1;
      when 21,18;     adj_x = -2; adj_y = -1;
      when 26,30;     adj_x = -3; adj_y = -1;
      when 11;        adj_x = -1; adj_y = 2;
      when 22;        adj_x = -2; adj_y = 2;
      when 12;        adj_x = -1; adj_y = -2;
      when 23;        adj_x = -2; adj_y = -2;
      end
      case wall
      when 1,6,19,24,4,9,20,25,5,10,21,26,11,22,12,23
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == up)
      when 2,7,15,27,13,17,29
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == left)
      when 3,8,16,28,14,18,30
        return ($game_player.kakushi[x+adj_x, y+adj_y, id] == right)
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 隠し扉を描画
  #--------------------------------------------------------------------------
  # def draw_kakushi # @kakushiの座標の情報が存在したら表示
  #   x = $game_player.x
  #   y = $game_player.y
  #   id = $game_map.map_id
  #   direction = $game_player.direction
  #   if direction == $game_player.kakushi[x, y, id] # 隠し扉のdirectionとあったら
  #     @kakushi.visible = true
  #     @wall["1"].visible = false  # 目の前の壁表示は消す
  #     $music.se_play("シークレットドア") unless $scene.is_a?(Scene_CAMP)
  #   end
  # end
  #--------------------------------------------------------------------------
  # ● すべての壁の色をグレーに
  #--------------------------------------------------------------------------
  def change_gray_all_wall(value)
  	for i in 1..30
  		@wall["#{i}"].color.alpha = value
  		@door["#{i}"].color.alpha = value
  		@iron_door["#{i}"].color.alpha = value
  		@up_stairs["#{i}"].color.alpha = value
  		@down_stairs["#{i}"].color.alpha = value
  	end
#~     for i in [1,2,3,6]
#~       @t_wall["#{i}"].color.alpha = value
#~     end
#~     array = ["A","B","C","D","E","F","G","H","I","J","K","L","M"]
#~     array += ["A+","B+","C+","D+","E+","F+","G+","H+","I+","J+","K+","L+","M+"]
    array = ["A-","B-","C-","D-","E-","F-","I-","J-","K-","L-","M-","N-","O-","P-","Q-","R-"]
  	for i in array
  		@floor["#{i}"].color.alpha = value
    end
    @field.color.alpha = value
    # @kakushi.color.alpha = value
    @switch_wall.color.alpha = value
    @chest_wall.color.alpha = value
    @drawing_fountain.color.alpha = value
  end
  #--------------------------------------------------------------------------
  # ● 壁のトーンの変調
  #--------------------------------------------------------------------------
  def change_wall_tone(tone)
    for i in 1..30
  		@wall["#{i}"].tone = tone
  		@door["#{i}"].tone = tone
  		@iron_door["#{i}"].tone = tone
  		@up_stairs["#{i}"].tone = tone
  		@down_stairs["#{i}"].tone = tone
  	end
    array = ["A-","B-","C-","D-","E-","F-","I-","J-","K-","L-","M-","N-","O-","P-","Q-","R-"]
  	for i in array
  		@floor["#{i}"].tone = tone
    end
    @field.tone = tone
    # @kakushi.tone = tone
    @switch_wall.tone = tone
    @drawing_fountain.tone = tone
    @chest_wall.tone = tone
    @prev_tone = tone
  end
  #--------------------------------------------------------------------------
  # ● 壁の種類を返す
  # B1F 城壁、城床  1
  # B2F 城壁、城床  1
  # B3F 岩壁、緑床  2
  # B4F 岩壁、緑床  2
  # B5F 城壁、城床
  # B6F 城壁、城床
  # B7F 岩壁、土床
  # B8F 城壁、城床
  # B9F 岩壁、マグマ床
  #--------------------------------------------------------------------------
  def check_wall_kind(map_id = $game_map.map_id)
    case map_id
    when 1,2,5,6,8; return 1
    when 3,4,7,9; return 2
    end
  end
  #--------------------------------------------------------------------------
  # すべての壁をdispose
  #--------------------------------------------------------------------------
  def dispose_all
    if @wall != nil
      for i in @wall.keys
        @wall["#{i}"].bitmap.dispose
      end
    end
    if @door != nil
      for i in @door.keys
        @door["#{i}"].bitmap.dispose
      end
    end
    if @iron_door != nil
      for i in @iron_door.keys
        @iron_door["#{i}"].bitmap.dispose
      end
    end
    if @up_stairs != nil
      for i in @up_stairs.keys
        @up_stairs["#{i}"].bitmap.dispose
      end
    end
    if @down_stairs != nil
      for i in @down_stairs.keys
        @down_stairs["#{i}"].bitmap.dispose
      end
    end
    if @floor != nil
      for i in @floor.keys
        @floor["#{i}"].bitmap.dispose
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● すべての壁を定義
  # B1F 城壁、城床
  # B2F 城壁、城床
  # B3F 岩壁、緑床
  # B4F 岩壁、緑床
  # B5F 城壁、城床
  # B6F 城壁、城床
  # B7F 岩壁、土床
  # B8F 城壁、城床
  # B9F 岩壁、マグマ床
  #--------------------------------------------------------------------------
  def define_all_wall(map_id = 1)
    dispose_all
  	@wall = {}
  	@door = {}
  	@iron_door = {}
    @up_stairs = {}
    @down_stairs = {}
    # @t_wall = {}
  	@floor = {}
    @lower = {}
    @upper = {}
    @step = true      # 床の描画の画像１，２切り替え用
  	## wallの初期定義
  	for i in 1..30
  		@wall["#{i}"] = Sprite.new
      @wall["#{i}"].visible = false # 最初は表示させない
      case map_id
      when 1,2,5,6,8
        @wall["#{i}"].bitmap = Cache.dungeon("#{i}")
      when 3,4,7,9
        @wall["#{i}"].bitmap = Cache.dungeon("#{i}_b")
      end
  		@wall["#{i}"].ox = @wall["#{i}"].bitmap.width / 2
  		@wall["#{i}"].oy = @wall["#{i}"].bitmap.height / 2
      @wall["#{i}"].x = Constant_Table::SCREEN_WIDTH / 2
      @wall["#{i}"].y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
  		case i
      when 1,2,3;         @wall["#{i}"].z = 29
  		when 4,5,6,7,8;       @wall["#{i}"].z = 27
  		when 9,10,15,16,13,14,19; @wall["#{i}"].z = 25
  		when 11,12,17,18,20,27,24,28,21;   @wall["#{i}"].z = 23
  		when 22,29,25,26,30,23;   @wall["#{i}"].z = 21
  		end
  	end
  	## doorの初期定義
  	for i in 1..30
  		@door["#{i}"] = Sprite.new
      @door["#{i}"].visible = false # 最初は表示させない
      case map_id
      when 1,2,5,6,8
        @door["#{i}"].bitmap = Cache.dungeon("#{i}D")
      when 3,4,7,9
        @door["#{i}"].bitmap = Cache.dungeon("#{i}D_b")
      end
      @door["#{i}"].ox = @door["#{i}"].bitmap.width / 2
  		@door["#{i}"].oy = @door["#{i}"].bitmap.height / 2
      @door["#{i}"].x = Constant_Table::SCREEN_WIDTH / 2
      @door["#{i}"].y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
  		case i
      when 1,2,3;         @door["#{i}"].z = 29
  		when 4,5,6,7,8;       @door["#{i}"].z = 27
  		when 9,10,15,16,13,14,19; @door["#{i}"].z = 25
  		when 11,12,17,18,20,27,24,28,21;   @door["#{i}"].z = 23
      when 22,29,25,26,30,23;   @door["#{i}"].z = 21
  		end
  	end
    ## 鉄格子の初期定義(土壁に鉄格子は存在しない)
  	for i in 1..30
  		@iron_door["#{i}"] = Sprite.new
      @iron_door["#{i}"].visible = false # 最初は表示させない
      case map_id
      when 1,2,5,6,8
        @iron_door["#{i}"].bitmap = Cache.dungeon("#{i}D+")
      when 3,4,7,9
        @iron_door["#{i}"].bitmap = Cache.dungeon("#{i}D+")
      end
      @iron_door["#{i}"].ox = @iron_door["#{i}"].bitmap.width / 2
  		@iron_door["#{i}"].oy = @iron_door["#{i}"].bitmap.height / 2
      @iron_door["#{i}"].x = Constant_Table::SCREEN_WIDTH / 2
      @iron_door["#{i}"].y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
  		case i
      when 1,2,3;         @iron_door["#{i}"].z = 29
  		when 4,5,6,7,8;       @iron_door["#{i}"].z = 27
  		when 9,10,15,16,13,14,19; @iron_door["#{i}"].z = 25
  		when 11,12,17,18,20,27,24,28,21;   @iron_door["#{i}"].z = 23
      when 22,29,25,26,30,23;   @iron_door["#{i}"].z = 21
  		end
  	end
    ## 上り階段の初期定義
  	for i in 1..30
  		@up_stairs["#{i}"] = Sprite.new
      @up_stairs["#{i}"].visible = false # 最初は表示させない
      case map_id
      when 1,2,5,6,8
        @up_stairs["#{i}"].bitmap = Cache.dungeon("#{i}up")
      when 3,4,7,9
        @up_stairs["#{i}"].bitmap = Cache.dungeon("#{i}up_b")
      end
      @up_stairs["#{i}"].ox = @up_stairs["#{i}"].bitmap.width / 2
  		@up_stairs["#{i}"].oy = @up_stairs["#{i}"].bitmap.height / 2
      @up_stairs["#{i}"].x = Constant_Table::SCREEN_WIDTH / 2
      @up_stairs["#{i}"].y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
  		case i
      when 1,2,3;         @up_stairs["#{i}"].z = 29
  		when 4,5,6,7,8;       @up_stairs["#{i}"].z = 27
  		when 9,10,15,16,13,14,19; @up_stairs["#{i}"].z = 25
  		when 11,12,17,18,20,27,24,28,21;   @up_stairs["#{i}"].z = 23
      when 22,29,25,26,30,23;   @up_stairs["#{i}"].z = 21
  		end
  	end
    ## 下り階段の初期定義
  	for i in 1..30
  		@down_stairs["#{i}"] = Sprite.new
      @down_stairs["#{i}"].visible = false # 最初は表示させない
      case map_id
      when 1,2,5,6,8
        @down_stairs["#{i}"].bitmap = Cache.dungeon("#{i}down")
      when 3,4,7,9
        @down_stairs["#{i}"].bitmap = Cache.dungeon("#{i}down_b")
      end
      @down_stairs["#{i}"].ox = @down_stairs["#{i}"].bitmap.width / 2
  		@down_stairs["#{i}"].oy = @down_stairs["#{i}"].bitmap.height / 2
      @down_stairs["#{i}"].x = Constant_Table::SCREEN_WIDTH / 2
      @down_stairs["#{i}"].y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
  		case i
      when 1,2,3;         @down_stairs["#{i}"].z = 29
  		when 4,5,6,7,8;       @down_stairs["#{i}"].z = 27
  		when 9,10,15,16,13,14,19; @down_stairs["#{i}"].z = 25
  		when 11,12,17,18,20,27,24,28,21;   @down_stairs["#{i}"].z = 23
      when 22,29,25,26,30,23;   @down_stairs["#{i}"].z = 21
  		end
  	end
    ## 宝箱壁の初期定義
#~   	for i in [1,2,3,6,19]
#~   		@t_wall["#{i}"] = Sprite.new
#~       @t_wall["#{i}"].visible = false # 最初は表示させない
#~   		@t_wall["#{i}"].bitmap = Cache.dungeon("#{i}t")
#~       @t_wall["#{i}"].ox = @t_wall["#{i}"].bitmap.width / 2
#~   		@t_wall["#{i}"].oy = @t_wall["#{i}"].bitmap.height / 2
#~       @t_wall["#{i}"].x = Constant_Table::SCREEN_WIDTH / 2
#~       @t_wall["#{i}"].y = Constant_Table::SCREEN_HEIGHT / 2
#~   		case i
#~       when 1,2,3;         @t_wall["#{i}"].z = 29
#~   		when 4,5,6,7,8;       @t_wall["#{i}"].z = 27
#~   		when 9,10,15,16,13,14,19; @t_wall["#{i}"].z = 25
#~   		when 11,12,17,18,20,27,24,28,21;   @t_wall["#{i}"].z = 23
#~       when 22,29,25,26,30,23;   @t_wall["#{i}"].z = 21
#~   		end
#~   	end
  	## floorについてはアルファベットにする。A~M範囲
#~   	array = ["A","B","C","D","E","F","G","H","I","J","K","L","M"]
#~   	for i in array
#~   		@floor["#{i}"] = Sprite.new
#~       @floor["#{i}"].visible = false # 最初は表示させない
#~   		@floor["#{i}"].bitmap = Cache.dungeon("#{i}")
#~       @floor["#{i}"].ox = @floor["#{i}"].bitmap.width / 2
#~   		@floor["#{i}"].oy = @floor["#{i}"].bitmap.height / 2
#~       @floor["#{i}"].x = 256 / 2
#~       @floor["#{i}"].y = 224 / 2
#~       case i
#~       when "A"; @floor["#{i}"].z = 30
#~       when "B","C","D"; @floor["#{i}"].z = 28
#~       when "I","E","F"; @floor["#{i}"].z = 26
#~       when "J","K","G","H"; @floor["#{i}"].z = 24
#~       when "L","M"; @floor["#{i}"].z = 22
#~       end
#~   	end
    ## イベント付きフロアの定義
#~   	array = ["A+","B+","C+","D+","E+","F+","G+","H+","I+","J+","K+","L+","M+"]
#~   	for i in array
#~   		@floor["#{i}"] = Sprite.new
#~       @floor["#{i}"].visible = false # 最初は表示させない
#~   		@floor["#{i}"].bitmap = Cache.dungeon("#{i}")
#~       @floor["#{i}"].ox = @floor["#{i}"].bitmap.width / 2
#~   		@floor["#{i}"].oy = @floor["#{i}"].bitmap.height / 2
#~       @floor["#{i}"].x = 256 / 2
#~       @floor["#{i}"].y = 224 / 2
#~       case i
#~       when "A+"; @floor["#{i}"].z = 30
#~       when "B+","C+","D+"; @floor["#{i}"].z = 28
#~       when "I+","E+","F+"; @floor["#{i}"].z = 26
#~       when "J+","K+","G+","H+"; @floor["#{i}"].z = 24
#~       when "L+","M+"; @floor["#{i}"].z = 22
#~       end
#~   	end
    ## 水たまりフロアの定義
  	array = ["A-","B-","C-","D-","E-","F-","I-","J-","K-","L-","M-","N-","O-","P-","Q-","R-"]
  	for i in array
  		@floor["#{i}"] = Sprite.new
      @floor["#{i}"].visible = false # 最初は表示させない
  		@floor["#{i}"].bitmap = Cache.dungeon("#{i}")
      @floor["#{i}"].ox = @floor["#{i}"].bitmap.width / 2
  		@floor["#{i}"].oy = @floor["#{i}"].bitmap.height / 2
      @floor["#{i}"].x = Constant_Table::SCREEN_WIDTH / 2
      @floor["#{i}"].y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
      case i
      when "A-"; @floor["#{i}"].z = 30
      when "B-","C-","D-"; @floor["#{i}"].z = 28
      when "I-","E-","F-"; @floor["#{i}"].z = 26
      when "J-","K-","G-","H-","N-"; @floor["#{i}"].z = 24
      when "L-","M-","O-","P-"; @floor["#{i}"].z = 22
      when "Q-","R-"; @floor["#{i}"].z = 20
      end
  	end
    # 床の表示
    @field = Sprite.new
    @field.visible = false
    case map_id
    when 1,2,5,6,8
      @field.bitmap = Cache.dungeon("field")
    when 3,4
      @field.bitmap = Cache.dungeon("field2")
    when 7
      @field.bitmap = Cache.dungeon("field3")
    when 9
      @field.bitmap = Cache.dungeon("field4")
    end
    @field.ox = @field.bitmap.width / 2
    @field.oy = @field.bitmap.height / 2
    @field.x = Constant_Table::SCREEN_WIDTH / 2
    @field.y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
    @field.z = 1
    # 隠し扉の表示
    # @kakushi = Sprite.new
    # @kakushi.visible = false
    # @kakushi.bitmap = Cache.dungeon("1D_kakushi")
    # @kakushi.ox = @kakushi.bitmap.width / 2
    # @kakushi.oy = @kakushi.bitmap.height / 2
    # @kakushi.x = Constant_Table::SCREEN_WIDTH / 2
    # @kakushi.y = Constant_Table::SCREEN_HEIGHT / 2
    # @kakushi.z = 29
    # スイッチ壁の表示
    @switch_wall = Sprite.new
    @switch_wall.visible = false
    case map_id
    when 1,2,5,6,8
      @switch_wall.bitmap = Cache.dungeon("1switch")
    when 3,4,7,9
      @switch_wall.bitmap = Cache.dungeon("1switch_b")
    end
    @switch_wall.ox = @switch_wall.bitmap.width / 2
    @switch_wall.oy = @switch_wall.bitmap.height / 2
    @switch_wall.x = Constant_Table::SCREEN_WIDTH / 2
    @switch_wall.y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
    @switch_wall.z = 29
    # 宝壁の表示
    @chest_wall = Sprite.new
    @chest_wall.visible = false
    case map_id
    when 1,2,5,6,8
      @chest_wall.bitmap = Cache.dungeon("1t")
    when 3,4,7,9
      @chest_wall.bitmap = Cache.dungeon("1t_b")
    end
    @chest_wall.ox = @chest_wall.bitmap.width / 2
    @chest_wall.oy = @chest_wall.bitmap.height / 2
    @chest_wall.x = Constant_Table::SCREEN_WIDTH / 2
    @chest_wall.y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
    @chest_wall.z = 29
    # 水汲み場の表示
    @drawing_fountain = Sprite.new
    @drawing_fountain.visible = false
    @drawing_fountain.bitmap = Cache.dungeon("drawing_fountain")
    @drawing_fountain.ox = @drawing_fountain.bitmap.width / 2
    @drawing_fountain.oy = @drawing_fountain.bitmap.height / 2
    @drawing_fountain.x = Constant_Table::SCREEN_WIDTH / 2
    @drawing_fountain.y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
    @drawing_fountain.z = 29
    # 一歩先のダークゾーンの表示
    @darkzone = Sprite.new
    @darkzone.visible = false
    @darkzone.bitmap = Cache.dungeon("darkzone")
    @darkzone.ox = @darkzone.bitmap.width / 2
    @darkzone.oy = @darkzone.bitmap.height / 2
    @darkzone.x = Constant_Table::SCREEN_WIDTH / 2
    @darkzone.y = Constant_Table::SCREEN_HEIGHT / 2 + ADJ_SCREEN_Y
    @darkzone.z = 27

    # @frame = Window_Base.new(0+8, 0+8, Constant_Table::SCREEN_WIDTH-16, Constant_Table::SCREEN_HEIGHT-16)
    # @frame.back_opacity = 0
    # @frame.visible = false
    # @frame_b = Sprite.new
    # @frame_b.bitmap = Cache.system("black_frame")
    # @frame_b.x = 0
    # @frame_b.y = 0
    # @frame_b.visible = false
    # @frame_b.z = @frame.z - 1
 	end
  #--------------------------------------------------------------------------
  # ● 壁情報
  #--------------------------------------------------------------------------
  def get_wall_info_for_wandering(x, y)
    wall_upper = $game_map.data[x, y, 2]
    wall_lower = $game_map.data[x, y, 0]
    wall_upper = wall_id_to_wall_info_upper(wall_upper)
    wall_lower = wall_id_to_wall_info_lower(wall_lower)
    wn = (wall_lower / 1000) % 10	# 1000の位
    we = (wall_lower / 100) % 10	# 100の位
    ws = (wall_lower / 10) % 10	# 10の位
    ww = (wall_lower / 1) % 10	# 1の位
    dn = (wall_upper / 0x1000) % 16	# 1000の位
    de = (wall_upper / 0x100) % 16	# 100の位
    ds = (wall_upper / 0x10) % 16	# 10の位
    dw = (wall_upper / 0x1) % 16	# 1の位
    return wn,we,ws,ww,dn,de,ds,dw
  end
  #--------------------------------------------------------------------------
  # ● 各タイル情報を取得
  #   現在地から周りのタイルIDを取得しそれを壁要素に分けて保存
  #--------------------------------------------------------------------------
  def check_wall_info
    ## 現在の座標を取得
    now_x = $game_player.x
    now_y = $game_player.y
    ## 壁情報アレイ
    walls_upper = [""]
    walls_lower = [""]
    ## 自分の周りの壁タイル情報を取得(9x9)
    for y_adj in [-4,-3,-2,-1, 0, 1, 2, 3, 4]
      for x_adj in [-4,-3,-2,-1, 0, 1, 2, 3, 4]
        walls_upper.push($game_map.data[ now_x + x_adj, now_y + y_adj, 2])
        walls_lower.push($game_map.data[ now_x + x_adj, now_y + y_adj, 0])
      end
    end

    ## 壁情報アレイを実際の壁情報(1111)に変換
    for i in 1..81
    	walls_upper[i] = wall_id_to_wall_info_upper(walls_upper[i])
    	walls_lower[i] = wall_id_to_wall_info_lower(walls_lower[i])
    end

    ## 壁情報を分解して壁の有無を4方向に分解してhashに保存
    ## タイルのIDから得た壁情報をそれぞれ代入
    ## 各桁は16進数に変換する。
    for i in 1..81
    	@lower["#{i}_N"] = (walls_lower[i] / 1000) % 10	# 1000の位
    	@lower["#{i}_E"] = (walls_lower[i] / 100) % 10	# 100の位
    	@lower["#{i}_S"] = (walls_lower[i] / 10) % 10		# 10の位
    	@lower["#{i}_W"] = (walls_lower[i] / 1) % 10		# 1の位

    	@upper["#{i}_FLOOR"]  = (walls_upper[i] / 0x10000)      # 0x10000以上の位
    	@upper["#{i}_DOOR_N"] = (walls_upper[i] / 0x1000) % 16	# 0x1000の位
    	@upper["#{i}_DOOR_E"] = (walls_upper[i] / 0x100) % 16		# 0x100の位
    	@upper["#{i}_DOOR_S"] = (walls_upper[i] / 0x10) % 16		# 0x10の位
    	@upper["#{i}_DOOR_W"] = (walls_upper[i] / 0x1) % 16			# 0x1の位
    	# @upper["#{i}_FLOOR"] = (walls_upper[i] / 10000) % 10	# 10000の位
    	# @upper["#{i}_DOOR_N"] = (walls_upper[i] / 1000) % 10	# 1000の位
    	# @upper["#{i}_DOOR_E"] = (walls_upper[i] / 100) % 10		# 100の位
    	# @upper["#{i}_DOOR_S"] = (walls_upper[i] / 10) % 10		# 10の位
    	# @upper["#{i}_DOOR_W"] = (walls_upper[i] / 1) % 10			# 1の位
    end
  end
  #--------------------------------------------------------------------------
  # ● タイルIDを壁要素に変換
  #--------------------------------------------------------------------------
  def wall_id_to_wall_info_lower(wall_id_lower)
    case wall_id_lower
    # 普通の壁 ID:0
    when 1536; return 0000

    when 1537; return 1000
    when 1538; return 100
    when 1539; return 10
    when 1540; return 1
    when 1545; return 111
    when 1546; return 1011
    when 1547; return 1101
    when 1548; return 1110
    when 1553; return 1100
    when 1554; return 110
    when 1555; return 11
    when 1556; return 1001
    when 1561; return 1010
    when 1562; return 101
    when 1563; return 1111

    # ここより緑壁 ID:2
    when 1568; return 2000
    when 1569; return 200
    when 1570; return 20
    when 1571; return 2
    when 1576; return 222
    when 1577; return 2022
    when 1578; return 2202
    when 1579; return 2220
    when 1584; return 2200
    when 1585; return 220
    when 1586; return 22
    when 1587; return 2002
    when 1592; return 2020
    when 1593; return 202
    when 1594; return 2222

    # ここより土壁 ID:3
    when 1572; return 3000
    when 1573; return 300
    when 1574; return 30
    when 1575; return 3
    when 1580; return 333
    when 1581; return 3033
    when 1582; return 3303
    when 1583; return 3330
    when 1588; return 3300
    when 1589; return 330
    when 1590; return 33
    when 1591; return 3003
    when 1596; return 3030
    when 1597; return 303
    when 1598; return 3333

    # ここより灰壁 ID:4
    when 1600; return 4000
    when 1601; return 400
    when 1602; return 40
    when 1603; return 4
    when 1608; return 444
    when 1609; return 4044
    when 1610; return 4404
    when 1611; return 4440
    when 1616; return 4400
    when 1617; return 440
    when 1618; return 44
    when 1619; return 4004
    when 1624; return 4040
    when 1625; return 404
    when 1626; return 4444

    # ここより赤壁 ID:5
    when 1604; return 5000
    when 1605; return 500
    when 1606; return 50
    when 1607; return 5
    when 1612; return 555
    when 1613; return 5055
    when 1614; return 5505
    when 1615; return 5550
    when 1620; return 5500
    when 1621; return 550
    when 1622; return 55
    when 1623; return 5005
    when 1628; return 5050
    when 1629; return 505
    when 1630; return 5555

    ## 石の中
    when 1543; return 1111

    else; return 0000
    end
  end
  #--------------------------------------------------------------------------
  # ● タイルIDを壁要素に変換（扉）
  #--------------------------------------------------------------------------
  def wall_id_to_wall_info_upper(wall_id_upper)
    case wall_id_upper
    # 普通の床
    when 1;   return 0x1000
    when 2;   return 0x100
    when 3;   return 0x10
    when 4;   return 0x1
    when 5;   return 0x1010
    when 6;   return 0x101
    when 7;   return 0x1111
    when 8;   return 0x1100
    when 9;   return 0x110
    when 10;  return 0x11
    when 11;  return 0x1001
    when 12;  return 0x111
    when 13;  return 0x1011
    when 14;  return 0x1101
    when 15;  return 0x1110
    # 鍵つき扉
    when 17;  return 0x2000
    when 18;  return 0x200
    when 19;  return 0x20
    when 20;  return 0x2
    # 閂扉(出口)
    when 21;  return 0xA000
    when 22;  return 0xA00
    when 23;  return 0xA0
    when 16;  return 0xA
    # 閂扉(入口)
    when 29;  return 0xB000
    when 30;  return 0xB00
    when 31;  return 0xB0
    when 24;  return 0xB
    # 鉄格子
    when 25;  return 0x3000
    when 26;  return 0x300
    when 27;  return 0x30
    when 28;  return 0x3
    # シークレットドア+イベント床
    when 32;  return 0x14010
    when 33;  return 0x10401
    when 34;  return 0x11040
    when 35;  return 0x10104
    when 36;  return 0x14000  # イベント床 in0.91
    when 37;  return 0x10400  # イベント床
    when 38;  return 0x10040  # イベント床
    when 39;  return 0x10004  # イベント床
    # 上り階段(階段床ID:2)
    when 160; return 0x25010
    when 161; return 0x20501
    when 162; return 0x21050
    when 163; return 0x20105
    when 164; return 0x25000
    when 165; return 0x20500
    when 166; return 0x20050
    when 167; return 0x20005
    # 下り階段
    when 168; return 0x26010
    when 169; return 0x20601
    when 170; return 0x21060
    when 171; return 0x20106
    when 172; return 0x26000
    when 173; return 0x20600
    when 174; return 0x20060
    when 175; return 0x20006
    # スイッチ壁
    when 176; return 0x7010
    when 177; return 0x0701
    when 178; return 0x1070
    when 179; return 0x0107
    when 180; return 0x7000
    when 181; return 0x0700
    when 182; return 0x0070
    when 183; return 0x0007
    # イベント床
    # when 40;  return 0x10000
    # when 41;  return 0x11000
    # when 42;  return 0x10100
    # when 43;  return 0x10010
    # when 44;  return 0x10001
    # when 45;  return 0x11010
    # when 46;  return 0x10101
    # when 47;  return 0x11111
    # when 48;  return 0x11100
    # when 49;  return 0x10110
    # when 50;  return 0x10011
    # when 51;  return 0x11001
    # when 52;  return 0x10111
    # when 53;  return 0x11011
    # when 54;  return 0x11101
    # when 55;  return 0x11110

    # 真っ暗床
    when 64;  return 0x30000
    when 65;  return 0x31000
    when 66;  return 0x30100
    when 67;  return 0x30010
    when 68;  return 0x30001
    when 69;  return 0x31010
    when 70;  return 0x30101
    when 71;  return 0x31111
    when 72;  return 0x31100
    when 73;  return 0x30110
    when 74;  return 0x30011
    when 75;  return 0x31001
    when 76;  return 0x30111
    when 77;  return 0x31011
    when 78;  return 0x31101
    when 79;  return 0x31110

    # 玄室
    when 80;  return 0x40000
    when 81;  return 0x41000
    when 82;  return 0x40100
    when 83;  return 0x40010
    when 84;  return 0x40001
    when 85;  return 0x41010
    when 86;  return 0x40101
    when 87;  return 0x41111
    when 88;  return 0x41100
    when 89;  return 0x40110
    when 90;  return 0x40011
    when 91;  return 0x41001
    when 92;  return 0x40111
    when 93;  return 0x41011
    when 94;  return 0x41101
    when 95;  return 0x41110

    # エレベーター
    when 96;  return 0x0000
    when 97;  return 0x1000
    when 98;  return 0x0100
    when 99;  return 0x0010

    ## メインエレベータ
    when 100;  return 0x50001         # メインエレベータ（0x5）

    ## エレベータは扉ひとつ
    when 101;  return 0x1010
    when 102;  return 0x0101
    when 103;  return 0x1111
    when 104;  return 0x1100
    when 105;  return 0x0110
    when 106;  return 0x0011
    when 107;  return 0x1001
    when 108;  return 0x0111
    when 109;  return 0x1011
    when 110;  return 0x1101
    when 111;  return 0x1110

    ## 固定イベント床
    when 128;  return 0x60000         # 水たまり
    when 129;  return 0x100000        # ワンダリングモンスター初期配置場所# フラグ 0x10 = 16
    when 130;  return 0x110000        # すべる床（北）
    when 131;  return 0x120000        # すべる床（東）
    when 132;  return 0x130000        # すべる床（南）
    when 133;  return 0x140000        # すべる床（西）
    when 134;  return 0x150000        # ダストシュート
    when 135;  return 0x160020        # 魔法の水汲み場 key:0x16
    when 136;  return 0xFF0000        #
    when 137;  return 0xFF0000
    when 138;  return 0xFF0000
    when 139;  return 0xFF0000
    when 140;  return 0xFF0000
    when 141;  return 0xFF0000
    when 142;  return 0xFF0000
    when 143;  return 0xFF0000
    when 112;  return 0xFF0000        # 回転床

    # 呪文禁止床
    when 144;  return 0x70000
    when 145;  return 0x71000
    when 146;  return 0x70100
    when 147;  return 0x70010
    when 148;  return 0x70001
    when 149;  return 0x71010
    when 150;  return 0x70101
    when 151;  return 0x71111
    when 152;  return 0x71100
    when 153;  return 0x70110
    when 154;  return 0x70011
    when 155;  return 0x71001
    when 156;  return 0x70111
    when 157;  return 0x71011
    when 158;  return 0x71101
    when 159;  return 0x71110

    # ランダムイベント床
    when 184;  return 0x80000
    when 185;  return 0x81000
    when 186;  return 0x80100
    when 187;  return 0x80010
    when 188;  return 0x80001
    when 189;  return 0x81010
    when 190;  return 0x80101
    when 191;  return 0x81111
    when 192;  return 0x81100
    when 193;  return 0x80110
    when 194;  return 0x80011
    when 195;  return 0x81001
    when 196;  return 0x80111
    when 197;  return 0x81011
    when 198;  return 0x81101
    when 199;  return 0x81110

    # 毒霧床
    when 200;  return 0x90000
    when 201;  return 0x91000
    when 202;  return 0x90100
    when 203;  return 0x90010
    when 204;  return 0x90001
    when 205;  return 0x91010
    when 206;  return 0x90101
    when 207;  return 0x91111
    when 208;  return 0x91100
    when 209;  return 0x90110
    when 210;  return 0x90011
    when 211;  return 0x91001
    when 212;  return 0x90111
    when 213;  return 0x91011
    when 214;  return 0x91101
    when 215;  return 0x91110

    # イベント床１(ハーブ)
    when 216;  return 0xA0000
    when 217;  return 0xA1000
    when 218;  return 0xA0100
    when 219;  return 0xA0010
    when 220;  return 0xA0001
    when 221;  return 0xA1010
    when 222;  return 0xA0101
    when 223;  return 0xA1111
    when 224;  return 0xA1100
    when 225;  return 0xA0110
    when 226;  return 0xA0011
    when 227;  return 0xA1001
    when 228;  return 0xA0111
    when 229;  return 0xA1011
    when 230;  return 0xA1101
    when 231;  return 0xA1110
    # イベント床２(きのこ)
    when 232;  return 0xB0000
    when 233;  return 0xB1000
    when 234;  return 0xB0100
    when 235;  return 0xB0010
    when 236;  return 0xB0001
    when 237;  return 0xB1010
    when 238;  return 0xB0101
    when 239;  return 0xB1111
    when 240;  return 0xB1100
    when 241;  return 0xB0110
    when 242;  return 0xB0011
    when 243;  return 0xB1001
    when 244;  return 0xB0111
    when 246;  return 0xB1101
    when 247;  return 0xB1110
    # イベント床３(ピット)
    when 113;   return 0xC1000
    when 114;   return 0xC0100
    when 115;   return 0xC0010
    when 116;   return 0xC0001
    when 117;   return 0xC0000  # 扉無し

    ## ガラクタの山
    when 118;   return 0x171000   # key:0x17
    ## 帰還の魔法陣（留守）
    when 119;   return 0x180000   # key:0x18

    when 120;   return 0xC1100
    when 121;   return 0xC0110
    when 122;   return 0xC0011
    when 123;   return 0xC1001
    when 124;   return 0xC0111
    when 125;   return 0xC1011
    when 126;   return 0xC1101
    when 127;   return 0xC1110
    # イベント床４(邪神像)
    when 40;    return 0xD1000
    when 41;    return 0xD0100
    when 42;    return 0xD0010
    when 43;    return 0xD0001

    else ;     return 0x00000
    end
  end
  #--------------------------------------------------------------------------
  # ● 現在ダークゾーンか？
  #--------------------------------------------------------------------------
  def dark_zone?
    return @upper["41_FLOOR"] == 3
  end
  #--------------------------------------------------------------------------
  # ● ブロックか？
  #--------------------------------------------------------------------------
  def block?(x, y)
    return $game_map.data[x, y, 0] == 1543
  end
  #--------------------------------------------------------------------------
  # ● ワンダリング固定配置か？
  #--------------------------------------------------------------------------
  def wandering_set?(x, y)
    return $game_map.data[x, y, 2] == 129
  end
  #--------------------------------------------------------------------------
  # ● 壁の描画
  #--------------------------------------------------------------------------
  ## どの壁を描画させるか判定
  def draw_walls(no_step)
    return if dark_zone?  # 41の床がダークゾーンであった場合SKIP
    draw_field(no_step)  # 床と天井の表示
    case $game_player.direction
    # 北を向いている場合
    when 8
      ## 壁の描画
      if @lower["41_N"] > 0 then draw_wall(1) end
      if @lower["41_W"] > 0 then draw_wall(2) end
      if @lower["41_E"] > 0 then draw_wall(3) end
      if @lower["40_N"] > 0 then draw_wall(4) end
      if @lower["42_N"] > 0 then draw_wall(5) end
      if @lower["32_N"] > 0 then draw_wall(6) end
      if @lower["32_W"] > 0 then draw_wall(7) end
      if @lower["32_E"] > 0 then draw_wall(8) end
      if @lower["31_N"] > 0 then draw_wall(9) end
      if @lower["33_N"] > 0 then draw_wall(10) end
      if @lower["30_N"] > 0 then draw_wall(11) end
      if @lower["34_N"] > 0 then draw_wall(12) end
      if @lower["31_W"] > 0 then draw_wall(13) end
      if @lower["33_E"] > 0 then draw_wall(14) end
      if @lower["23_W"] > 0 then draw_wall(15) end
      if @lower["23_E"] > 0 then draw_wall(16) end
      if @lower["22_W"] > 0 then draw_wall(17) end
      if @lower["24_E"] > 0 then draw_wall(18) end

      if @lower["23_N"] > 0 then draw_wall(19) end
      if @lower["22_N"] > 0 then draw_wall(20) end
      if @lower["24_N"] > 0 then draw_wall(21) end
      if @lower["21_N"] > 0 then draw_wall(22) end
      if @lower["25_N"] > 0 then draw_wall(23) end
      if @lower["14_N"] > 0 then draw_wall(24) end
      if @lower["13_N"] > 0 then draw_wall(25) end
      if @lower["15_N"] > 0 then draw_wall(26) end
      if @lower["14_W"] > 0 then draw_wall(27) end
      if @lower["14_E"] > 0 then draw_wall(28) end
      if @lower["13_W"] > 0 then draw_wall(29) end
      if @lower["15_E"] > 0 then draw_wall(30) end

      ## 扉の描画
      case @upper["41_DOOR_N"]
      when 1,2,0xA,0xB; draw_door(1)
      when 3; draw_iron_door(1)
      when 5; draw_up_stairs(1)
      when 6; draw_down_stairs(1)
      when 4; draw_t_wall(1)
      when 7; draw_switch_wall
      end
      case @upper["41_DOOR_W"]
      when 1,2,0xA,0xB; draw_door(2)
      when 3; draw_iron_door(2)
      when 5; draw_up_stairs(2)
      when 6; draw_down_stairs(2)
      when 4; draw_t_wall(2)
      end
      case @upper["41_DOOR_E"]
      when 1,2,0xA,0xB; draw_door(3)
      when 3; draw_iron_door(3)
      when 5; draw_up_stairs(3)
      when 6; draw_down_stairs(3)
      when 4; draw_t_wall(3)
      end
      case @upper["40_DOOR_N"]
      when 1,2,0xA,0xB; draw_door(4)
      when 3; draw_iron_door(4)
      when 5; draw_up_stairs(4)
      when 6; draw_down_stairs(4)
      end
      case @upper["42_DOOR_N"]
      when 1,2,0xA,0xB; draw_door(5)
      when 3; draw_iron_door(5)
      when 5; draw_up_stairs(5)
      when 6; draw_down_stairs(5)
      end
      case @upper["32_DOOR_N"]
      when 1,2,0xA,0xB; draw_door(6)
      when 3; draw_iron_door(6)
      when 5; draw_up_stairs(6)
      when 6; draw_down_stairs(6)
      when 4; draw_t_wall(6)
      end
      case @upper["32_DOOR_W"]
      when 1,2,0xA,0xB; draw_door(7)
      when 3; draw_iron_door(7)
      when 5; draw_up_stairs(7)
      when 6; draw_down_stairs(7)
      end
      case @upper["32_DOOR_E"]
      when 1,2,0xA,0xB; draw_door(8)
      when 3; draw_iron_door(8)
      when 5; draw_up_stairs(8)
      when 6; draw_down_stairs(8)
      end
      case @upper["31_DOOR_N"]
      when 1,2,0xA,0xB; draw_door(9)
      when 3; draw_iron_door(9)
      when 5; draw_up_stairs(9)
      when 6; draw_down_stairs(9)
      end
      case @upper["33_DOOR_N"]
      when 1,2,0xA,0xB; draw_door(10)
      when 3;           draw_iron_door(10)
      when 5;           draw_up_stairs(10)
      when 6;           draw_down_stairs(10)
      end
      case @upper["30_DOOR_N"]
      when 1,2,0xA,0xB then draw_door(11) end
      if @upper["30_DOOR_N"] == 3 then draw_iron_door(11) end
      if @upper["30_DOOR_N"] == 5 then draw_up_stairs(11) end
      if @upper["30_DOOR_N"] == 6 then draw_down_stairs(11) end
      case @upper["34_DOOR_N"]
      when 1,2,0xA,0xB then draw_door(12) end
      if @upper["34_DOOR_N"] == 3 then draw_iron_door(12) end
      if @upper["34_DOOR_N"] == 5 then draw_up_stairs(12) end
      if @upper["34_DOOR_N"] == 6 then draw_down_stairs(12) end
      case @upper["31_DOOR_W"]
      when 1,2,0xA,0xB then draw_door(13) end
      if @upper["31_DOOR_W"] == 3 then draw_iron_door(13) end
      if @upper["31_DOOR_W"] == 5 then draw_up_stairs(13) end
      if @upper["31_DOOR_W"] == 6 then draw_down_stairs(13) end
      case @upper["33_DOOR_E"]
      when 1,2,0xA,0xB then draw_door(14) end
      if @upper["33_DOOR_E"] == 3 then draw_iron_door(14) end
      if @upper["33_DOOR_E"] == 5 then draw_up_stairs(14) end
      if @upper["33_DOOR_E"] == 6 then draw_down_stairs(14) end
      case @upper["23_DOOR_W"]
      when 1,2,0xA,0xB then draw_door(15) end
      if @upper["23_DOOR_W"] == 3 then draw_iron_door(15) end
      if @upper["23_DOOR_W"] == 5 then draw_up_stairs(15) end
      if @upper["23_DOOR_W"] == 6 then draw_down_stairs(15) end
      case @upper["23_DOOR_E"]
      when 1,2,0xA,0xB then draw_door(16) end
      if @upper["23_DOOR_E"] == 3 then draw_iron_door(16) end
      if @upper["23_DOOR_E"] == 5 then draw_up_stairs(16) end
      if @upper["23_DOOR_E"] == 6 then draw_down_stairs(16) end
      case @upper["22_DOOR_W"]
      when 1,2,0xA,0xB then draw_door(17) end
      if @upper["22_DOOR_W"] == 3 then draw_iron_door(17) end
      if @upper["22_DOOR_W"] == 5 then draw_up_stairs(17) end
      if @upper["22_DOOR_W"] == 6 then draw_down_stairs(17) end
      case @upper["24_DOOR_E"]
      when 1,2,0xA,0xB then draw_door(18) end
      if @upper["24_DOOR_E"] == 3 then draw_iron_door(18) end
      if @upper["24_DOOR_E"] == 5 then draw_up_stairs(18) end
      if @upper["24_DOOR_E"] == 6 then draw_down_stairs(18) end
      case @upper["23_DOOR_N"]
      when 1,2,0xA,0xB then draw_door(19) end
      if @upper["23_DOOR_N"] == 3 then draw_iron_door(19) end
      if @upper["23_DOOR_N"] == 5 then draw_up_stairs(19) end
      if @upper["23_DOOR_N"] == 6 then draw_down_stairs(19) end
      if @upper["23_DOOR_N"] == 4 then draw_t_wall(19) end
      case @upper["22_DOOR_N"]
      when 1,2,0xA,0xB then draw_door(20) end
      if @upper["22_DOOR_N"] == 3 then draw_iron_door(20) end
      if @upper["22_DOOR_N"] == 5 then draw_up_stairs(20) end
      if @upper["22_DOOR_N"] == 6 then draw_down_stairs(20) end
      case @upper["24_DOOR_N"]
      when 1,2,0xA,0xB then draw_door(21) end
      if @upper["24_DOOR_N"] == 3 then draw_iron_door(21) end
      if @upper["24_DOOR_N"] == 5 then draw_up_stairs(21) end
      if @upper["24_DOOR_N"] == 6 then draw_down_stairs(21) end
      case @upper["21_DOOR_N"]
      when 1,2,0xA,0xB then draw_door(22) end
      if @upper["21_DOOR_N"] == 3 then draw_iron_door(22) end
      if @upper["21_DOOR_N"] == 5 then draw_up_stairs(22) end
      if @upper["21_DOOR_N"] == 6 then draw_down_stairs(22) end
      case @upper["25_DOOR_N"]
      when 1,2,0xA,0xB then draw_door(23) end
      if @upper["25_DOOR_N"] == 3 then draw_iron_door(23) end
      if @upper["25_DOOR_N"] == 5 then draw_up_stairs(23) end
      if @upper["25_DOOR_N"] == 6 then draw_down_stairs(23) end
      case @upper["14_DOOR_N"]
      when 1,2,0xA,0xB then draw_door(24) end
      if @upper["14_DOOR_N"] == 3 then draw_iron_door(24) end
      if @upper["14_DOOR_N"] == 5 then draw_up_stairs(24) end
      if @upper["14_DOOR_N"] == 6 then draw_down_stairs(24) end
      case @upper["13_DOOR_N"]
      when 1,2,0xA,0xB then draw_door(25) end
      if @upper["13_DOOR_N"] == 3 then draw_iron_door(25) end
      if @upper["13_DOOR_N"] == 5 then draw_up_stairs(25) end
      if @upper["13_DOOR_N"] == 6 then draw_down_stairs(25) end
      case @upper["15_DOOR_N"]
      when 1,2,0xA,0xB then draw_door(26) end
      if @upper["15_DOOR_N"] == 3 then draw_iron_door(26) end
      if @upper["15_DOOR_N"] == 5 then draw_up_stairs(26) end
      if @upper["15_DOOR_N"] == 6 then draw_down_stairs(26) end
      case @upper["14_DOOR_W"]
      when 1,2,0xA,0xB then draw_door(27) end
      if @upper["14_DOOR_W"] == 3 then draw_iron_door(27) end
      if @upper["14_DOOR_W"] == 5 then draw_up_stairs(27) end
      if @upper["14_DOOR_W"] == 6 then draw_down_stairs(27) end
      case @upper["14_DOOR_E"]
      when 1,2,0xA,0xB then draw_door(28) end
      if @upper["14_DOOR_E"] == 3 then draw_iron_door(28) end
      if @upper["14_DOOR_E"] == 5 then draw_up_stairs(28) end
      if @upper["14_DOOR_E"] == 6 then draw_down_stairs(28) end
      case @upper["13_DOOR_W"]
      when 1,2,0xA,0xB then draw_door(29) end
      if @upper["13_DOOR_W"] == 3 then draw_iron_door(29) end
      if @upper["13_DOOR_W"] == 5 then draw_up_stairs(29) end
      if @upper["13_DOOR_W"] == 6 then draw_down_stairs(29) end
      case @upper["15_DOOR_E"]
      when 1,2,0xA,0xB then draw_door(30) end
      if @upper["15_DOOR_E"] == 3 then draw_iron_door(30) end
      if @upper["15_DOOR_E"] == 5 then draw_up_stairs(30) end
      if @upper["15_DOOR_E"] == 6 then draw_down_stairs(30) end

      ## 床の描画
      if @upper["41_FLOOR"] >= 0 then draw_floor("A") end
      if @upper["41_FLOOR"] == 1 then draw_floor("A+") end
      if @upper["41_FLOOR"] == 2 then draw_floor("A+") end
      if @upper["41_FLOOR"] == 6 then draw_floor("A-") end
      if @upper["40_FLOOR"] >= 0 then draw_floor("B") end
      if @upper["40_FLOOR"] == 1 then draw_floor("B+") end
      if @upper["40_FLOOR"] == 2 then draw_floor("B+") end
      if @upper["40_FLOOR"] == 6 then draw_floor("B-") end
      if @upper["42_FLOOR"] >= 0 then draw_floor("C") end
      if @upper["42_FLOOR"] == 1 then draw_floor("C+") end
      if @upper["42_FLOOR"] == 2 then draw_floor("C+") end
      if @upper["42_FLOOR"] == 6 then draw_floor("C-") end
      if @upper["32_FLOOR"] >= 0 then draw_floor("D") end
      if @upper["32_FLOOR"] == 1 then draw_floor("D+") end
      if @upper["32_FLOOR"] == 2 then draw_floor("D+") end
      if @upper["32_FLOOR"] == 6 then draw_floor("D-") end
      if @upper["31_FLOOR"] >= 0 then draw_floor("E") end
      if @upper["31_FLOOR"] == 1 then draw_floor("E+") end
      if @upper["31_FLOOR"] == 2 then draw_floor("E+") end
      if @upper["31_FLOOR"] == 6 then draw_floor("E-") end
      if @upper["33_FLOOR"] >= 0 then draw_floor("F") end
      if @upper["33_FLOOR"] == 1 then draw_floor("F+") end
      if @upper["33_FLOOR"] == 2 then draw_floor("F+") end
      if @upper["33_FLOOR"] == 6 then draw_floor("F-") end
      if @upper["30_FLOOR"] >= 0 then draw_floor("G") end
      if @upper["30_FLOOR"] == 1 then draw_floor("G+") end
      if @upper["30_FLOOR"] == 2 then draw_floor("G+") end
      if @upper["30_FLOOR"] == 6 then draw_floor("G-") end
      if @upper["34_FLOOR"] >= 0 then draw_floor("H") end
      if @upper["34_FLOOR"] == 1 then draw_floor("H+") end
      if @upper["34_FLOOR"] == 2 then draw_floor("H+") end
      if @upper["34_FLOOR"] == 6 then draw_floor("H-") end
      if @upper["23_FLOOR"] >= 0 then draw_floor("I") end
      if @upper["23_FLOOR"] == 1 then draw_floor("I+") end
      if @upper["23_FLOOR"] == 2 then draw_floor("I+") end
      if @upper["23_FLOOR"] == 6 then draw_floor("I-") end
      if @upper["22_FLOOR"] >= 0 then draw_floor("J") end
      if @upper["22_FLOOR"] == 1 then draw_floor("J+") end
      if @upper["22_FLOOR"] == 2 then draw_floor("J+") end
      if @upper["22_FLOOR"] == 6 then draw_floor("J-") end
      if @upper["24_FLOOR"] >= 0 then draw_floor("K") end
      if @upper["24_FLOOR"] == 1 then draw_floor("K+") end
      if @upper["24_FLOOR"] == 2 then draw_floor("K+") end
      if @upper["24_FLOOR"] == 6 then draw_floor("K-") end
      if @upper["21_FLOOR"] >= 0 then draw_floor("L") end
      if @upper["21_FLOOR"] == 1 then draw_floor("L+") end
      if @upper["21_FLOOR"] == 2 then draw_floor("L+") end
      if @upper["21_FLOOR"] == 6 then draw_floor("L-") end
      if @upper["25_FLOOR"] >= 0 then draw_floor("M") end
      if @upper["25_FLOOR"] == 1 then draw_floor("M+") end
      if @upper["25_FLOOR"] == 2 then draw_floor("M+") end
      if @upper["25_FLOOR"] == 6 then draw_floor("M-") end
      if @upper["14_FLOOR"] == 6 then draw_floor("N-") end
      if @upper["13_FLOOR"] == 6 then draw_floor("O-") end
      if @upper["15_FLOOR"] == 6 then draw_floor("P-") end
      if @upper["12_FLOOR"] == 6 then draw_floor("Q-") end
      if @upper["16_FLOOR"] == 6 then draw_floor("R-") end

    when 6 # 右をむいている
      ## 壁の描画
      if @lower["41_E"] > 0 then draw_wall(1) end
      if @lower["41_N"] > 0 then draw_wall(2) end
      if @lower["41_S"] > 0 then draw_wall(3) end
      if @lower["32_E"] > 0 then draw_wall(4) end
      if @lower["50_E"] > 0 then draw_wall(5) end
      if @lower["42_E"] > 0 then draw_wall(6) end
      if @lower["42_N"] > 0 then draw_wall(7) end
      if @lower["42_S"] > 0 then draw_wall(8) end
      if @lower["33_E"] > 0 then draw_wall(9) end
      if @lower["51_E"] > 0 then draw_wall(10) end
      if @lower["24_E"] > 0 then draw_wall(11) end
      if @lower["60_E"] > 0 then draw_wall(12) end # modified
      if @lower["33_N"] > 0 then draw_wall(13) end
      if @lower["51_S"] > 0 then draw_wall(14) end
      if @lower["43_N"] > 0 then draw_wall(15) end
      if @lower["43_S"] > 0 then draw_wall(16) end
      if @lower["34_N"] > 0 then draw_wall(17) end
      if @lower["52_S"] > 0 then draw_wall(18) end

      if @lower["43_E"] > 0 then draw_wall(19) end
      if @lower["34_E"] > 0 then draw_wall(20) end
      if @lower["52_E"] > 0 then draw_wall(21) end
      if @lower["25_E"] > 0 then draw_wall(22) end
      if @lower["61_E"] > 0 then draw_wall(23) end
      if @lower["44_E"] > 0 then draw_wall(24) end
      if @lower["35_E"] > 0 then draw_wall(25) end
      if @lower["53_E"] > 0 then draw_wall(26) end
      if @lower["44_N"] > 0 then draw_wall(27) end
      if @lower["44_S"] > 0 then draw_wall(28) end
      if @lower["35_N"] > 0 then draw_wall(29) end
      if @lower["53_S"] > 0 then draw_wall(30) end

      ## 扉の描画
      case @upper["41_DOOR_E"] when 1,2,0xA,0xB then draw_door(1) end
      if @upper["41_DOOR_E"] == 3 then draw_iron_door(1) end
      if @upper["41_DOOR_E"] == 5 then draw_up_stairs(1) end
      if @upper["41_DOOR_E"] == 6 then draw_down_stairs(1) end
      if @upper["41_DOOR_E"] == 4 then draw_t_wall(1) end
      if @upper["41_DOOR_E"] == 7 then draw_switch_wall end
      case @upper["41_DOOR_N"] when 1,2,0xA,0xB then draw_door(2) end
      if @upper["41_DOOR_N"] == 3 then draw_iron_door(2) end
      if @upper["41_DOOR_N"] == 5 then draw_up_stairs(2) end
      if @upper["41_DOOR_N"] == 6 then draw_down_stairs(2) end
      if @upper["41_DOOR_N"] == 4 then draw_t_wall(2) end
      case @upper["41_DOOR_S"] when 1,2,0xA,0xB then draw_door(3) end
      if @upper["41_DOOR_S"] == 3 then draw_iron_door(3) end
      if @upper["41_DOOR_S"] == 5 then draw_up_stairs(3) end
      if @upper["41_DOOR_S"] == 6 then draw_down_stairs(3) end
      if @upper["41_DOOR_S"] == 4 then draw_t_wall(3) end
      case @upper["32_DOOR_E"] when 1,2,0xA,0xB then draw_door(4) end
      if @upper["32_DOOR_E"] == 3 then draw_iron_door(4) end
      if @upper["32_DOOR_E"] == 5 then draw_up_stairs(4) end
      if @upper["32_DOOR_E"] == 6 then draw_down_stairs(4) end
      case @upper["50_DOOR_E"] when 1,2,0xA,0xB then draw_door(5) end
      if @upper["50_DOOR_E"] == 3 then draw_iron_door(5) end
      if @upper["50_DOOR_E"] == 5 then draw_up_stairs(5) end
      if @upper["50_DOOR_E"] == 6 then draw_down_stairs(5) end
      case @upper["42_DOOR_E"] when 1,2,0xA,0xB then draw_door(6) end
      if @upper["42_DOOR_E"] == 3 then draw_iron_door(6) end
      if @upper["42_DOOR_E"] == 5 then draw_up_stairs(6) end
      if @upper["42_DOOR_E"] == 6 then draw_down_stairs(6) end
      if @upper["42_DOOR_E"] == 4 then draw_t_wall(6) end
      case @upper["42_DOOR_N"] when 1,2,0xA,0xB then draw_door(7) end
      if @upper["42_DOOR_N"] == 3 then draw_iron_door(7) end
      if @upper["42_DOOR_N"] == 5 then draw_up_stairs(7) end
      if @upper["42_DOOR_N"] == 6 then draw_down_stairs(7) end
      case @upper["42_DOOR_S"] when 1,2,0xA,0xB then draw_door(8) end
      if @upper["42_DOOR_S"] == 3 then draw_iron_door(8) end
      if @upper["42_DOOR_S"] == 5 then draw_up_stairs(8) end
      if @upper["42_DOOR_S"] == 6 then draw_down_stairs(8) end
      case @upper["33_DOOR_E"] when 1,2,0xA,0xB then draw_door(9) end
      if @upper["33_DOOR_E"] == 3 then draw_iron_door(9) end
      if @upper["33_DOOR_E"] == 5 then draw_up_stairs(9) end
      if @upper["33_DOOR_E"] == 6 then draw_down_stairs(9) end
      case @upper["51_DOOR_E"] when 1,2,0xA,0xB then draw_door(10) end
      if @upper["51_DOOR_E"] == 3 then draw_iron_door(10) end
      if @upper["51_DOOR_E"] == 5 then draw_up_stairs(10) end
      if @upper["51_DOOR_E"] == 6 then draw_down_stairs(10) end
      case @upper["24_DOOR_E"] when 1,2,0xA,0xB then draw_door(11) end
      if @upper["24_DOOR_E"] == 3 then draw_iron_door(11) end
      if @upper["24_DOOR_E"] == 5 then draw_up_stairs(11) end
      if @upper["24_DOOR_E"] == 6 then draw_down_stairs(11) end
      case @upper["60_DOOR_N"] when 1,2,0xA,0xB then draw_door(12) end
      if @upper["60_DOOR_N"] == 3 then draw_iron_door(12) end
      if @upper["60_DOOR_N"] == 5 then draw_up_stairs(12) end
      if @upper["60_DOOR_N"] == 6 then draw_down_stairs(12) end
      case @upper["33_DOOR_N"] when 1,2,0xA,0xB then draw_door(13) end
      if @upper["33_DOOR_N"] == 3 then draw_iron_door(13) end
      if @upper["33_DOOR_N"] == 5 then draw_up_stairs(13) end
      if @upper["33_DOOR_N"] == 6 then draw_down_stairs(13) end
      case @upper["51_DOOR_S"] when 1,2,0xA,0xB then draw_door(14) end
      if @upper["51_DOOR_S"] == 3 then draw_iron_door(14) end
      if @upper["51_DOOR_S"] == 5 then draw_up_stairs(14) end
      if @upper["51_DOOR_S"] == 6 then draw_down_stairs(14) end
      case @upper["43_DOOR_N"] when 1,2,0xA,0xB then draw_door(15) end
      if @upper["43_DOOR_N"] == 3 then draw_iron_door(15) end
      if @upper["43_DOOR_N"] == 5 then draw_up_stairs(15) end
      if @upper["43_DOOR_N"] == 6 then draw_down_stairs(15) end
      case @upper["43_DOOR_S"] when 1,2,0xA,0xB then draw_door(16) end
      if @upper["43_DOOR_S"] == 3 then draw_iron_door(16) end
      if @upper["43_DOOR_S"] == 5 then draw_up_stairs(16) end
      if @upper["43_DOOR_S"] == 6 then draw_down_stairs(16) end
      case @upper["34_DOOR_N"] when 1,2,0xA,0xB then draw_door(17) end
      if @upper["34_DOOR_N"] == 3 then draw_iron_door(17) end
      if @upper["34_DOOR_N"] == 5 then draw_up_stairs(17) end
      if @upper["34_DOOR_N"] == 6 then draw_down_stairs(17) end
      case @upper["52_DOOR_S"] when 1,2,0xA,0xB then draw_door(18) end
      if @upper["52_DOOR_S"] == 3 then draw_iron_door(18) end
      if @upper["52_DOOR_S"] == 5 then draw_up_stairs(18) end
      if @upper["52_DOOR_S"] == 6 then draw_down_stairs(18) end
      case @upper["43_DOOR_E"] when 1,2,0xA,0xB then draw_door(19) end
      if @upper["43_DOOR_E"] == 3 then draw_iron_door(19) end
      if @upper["43_DOOR_E"] == 5 then draw_up_stairs(19) end
      if @upper["43_DOOR_E"] == 6 then draw_down_stairs(19) end
      if @upper["43_DOOR_E"] == 4 then draw_t_wall(19) end
      case @upper["34_DOOR_E"] when 1,2,0xA,0xB then draw_door(20) end
      if @upper["34_DOOR_E"] == 3 then draw_iron_door(20) end
      if @upper["34_DOOR_E"] == 5 then draw_up_stairs(20) end
      if @upper["34_DOOR_E"] == 6 then draw_down_stairs(20) end
      case @upper["52_DOOR_E"] when 1,2,0xA,0xB then draw_door(21) end
      if @upper["52_DOOR_E"] == 3 then draw_iron_door(21) end
      if @upper["52_DOOR_E"] == 5 then draw_up_stairs(21) end
      if @upper["52_DOOR_E"] == 6 then draw_down_stairs(21) end
      case @upper["25_DOOR_E"] when 1,2,0xA,0xB then draw_door(22) end
      if @upper["25_DOOR_E"] == 3 then draw_iron_door(22) end
      if @upper["25_DOOR_E"] == 5 then draw_up_stairs(22) end
      if @upper["25_DOOR_E"] == 6 then draw_down_stairs(22) end
      case @upper["61_DOOR_E"] when 1,2,0xA,0xB then draw_door(23) end
      if @upper["61_DOOR_E"] == 3 then draw_iron_door(23) end
      if @upper["61_DOOR_E"] == 5 then draw_up_stairs(23) end
      if @upper["61_DOOR_E"] == 6 then draw_down_stairs(23) end
      case @upper["44_DOOR_E"] when 1,2,0xA,0xB then draw_door(24) end
      if @upper["44_DOOR_E"] == 3 then draw_iron_door(24) end
      if @upper["44_DOOR_E"] == 5 then draw_up_stairs(24) end
      if @upper["44_DOOR_E"] == 6 then draw_down_stairs(24) end
      case @upper["35_DOOR_E"] when 1,2,0xA,0xB then draw_door(25) end
      if @upper["35_DOOR_E"] == 3 then draw_iron_door(25) end
      if @upper["35_DOOR_E"] == 5 then draw_up_stairs(25) end
      if @upper["35_DOOR_E"] == 6 then draw_down_stairs(25) end
      case @upper["53_DOOR_E"] when 1,2,0xA,0xB then draw_door(26) end
      if @upper["53_DOOR_E"] == 3 then draw_iron_door(26) end
      if @upper["53_DOOR_E"] == 5 then draw_up_stairs(26) end
      if @upper["53_DOOR_E"] == 6 then draw_down_stairs(26) end
      case @upper["44_DOOR_N"] when 1,2,0xA,0xB then draw_door(27) end
      if @upper["44_DOOR_N"] == 3 then draw_iron_door(27) end
      if @upper["44_DOOR_N"] == 5 then draw_up_stairs(27) end
      if @upper["44_DOOR_N"] == 6 then draw_down_stairs(27) end
      case @upper["44_DOOR_S"] when 1,2,0xA,0xB then draw_door(28) end
      if @upper["44_DOOR_S"] == 3 then draw_iron_door(28) end
      if @upper["44_DOOR_S"] == 5 then draw_up_stairs(28) end
      if @upper["44_DOOR_S"] == 6 then draw_down_stairs(28) end
      case @upper["35_DOOR_N"] when 1,2,0xA,0xB then draw_door(29) end
      if @upper["35_DOOR_N"] == 3 then draw_iron_door(29) end
      if @upper["35_DOOR_N"] == 5 then draw_up_stairs(29) end
      if @upper["35_DOOR_N"] == 6 then draw_down_stairs(29) end
      case @upper["53_DOOR_S"] when 1,2,0xA,0xB then draw_door(30) end
      if @upper["53_DOOR_S"] == 3 then draw_iron_door(30) end
      if @upper["53_DOOR_S"] == 5 then draw_up_stairs(30) end
      if @upper["53_DOOR_S"] == 6 then draw_down_stairs(30) end

      ## 床の描画
      if @upper["41_FLOOR"] >= 0 then draw_floor("A") end
      if @upper["41_FLOOR"] == 1 then draw_floor("A+") end
      if @upper["41_FLOOR"] == 2 then draw_floor("A+") end
      if @upper["41_FLOOR"] == 6 then draw_floor("A-") end
      if @upper["32_FLOOR"] >= 0 then draw_floor("B") end
      if @upper["32_FLOOR"] == 1 then draw_floor("B+") end
      if @upper["32_FLOOR"] == 2 then draw_floor("B+") end
      if @upper["32_FLOOR"] == 6 then draw_floor("B-") end
      if @upper["50_FLOOR"] >= 0 then draw_floor("C") end
      if @upper["50_FLOOR"] == 1 then draw_floor("C+") end
      if @upper["50_FLOOR"] == 2 then draw_floor("C+") end
      if @upper["50_FLOOR"] == 6 then draw_floor("C-") end
      if @upper["42_FLOOR"] >= 0 then draw_floor("D") end
      if @upper["42_FLOOR"] == 1 then draw_floor("D+") end
      if @upper["42_FLOOR"] == 2 then draw_floor("D+") end
      if @upper["42_FLOOR"] == 6 then draw_floor("D-") end
      if @upper["33_FLOOR"] >= 0 then draw_floor("E") end
      if @upper["33_FLOOR"] == 1 then draw_floor("E+") end
      if @upper["33_FLOOR"] == 2 then draw_floor("E+") end
      if @upper["33_FLOOR"] == 6 then draw_floor("E-") end
      if @upper["51_FLOOR"] >= 0 then draw_floor("F") end
      if @upper["51_FLOOR"] == 1 then draw_floor("F+") end
      if @upper["51_FLOOR"] == 2 then draw_floor("F+") end
      if @upper["51_FLOOR"] == 6 then draw_floor("F-") end
      if @upper["43_FLOOR"] >= 0 then draw_floor("G") end
      if @upper["43_FLOOR"] == 1 then draw_floor("G+") end
      if @upper["43_FLOOR"] == 2 then draw_floor("G+") end
      if @upper["43_FLOOR"] == 6 then draw_floor("G-") end
      if @upper["60_FLOOR"] >= 0 then draw_floor("H") end
      if @upper["60_FLOOR"] == 1 then draw_floor("H+") end
      if @upper["60_FLOOR"] == 2 then draw_floor("H+") end
      if @upper["60_FLOOR"] == 6 then draw_floor("H-") end
      if @upper["43_FLOOR"] >= 0 then draw_floor("I") end
      if @upper["43_FLOOR"] == 1 then draw_floor("I+") end
      if @upper["43_FLOOR"] == 2 then draw_floor("I+") end
      if @upper["43_FLOOR"] == 6 then draw_floor("I-") end
      if @upper["34_FLOOR"] >= 0 then draw_floor("J") end
      if @upper["34_FLOOR"] == 1 then draw_floor("J+") end
      if @upper["34_FLOOR"] == 2 then draw_floor("J+") end
      if @upper["34_FLOOR"] == 6 then draw_floor("J-") end
      if @upper["52_FLOOR"] >= 0 then draw_floor("K") end
      if @upper["52_FLOOR"] == 1 then draw_floor("K+") end
      if @upper["52_FLOOR"] == 2 then draw_floor("K+") end
      if @upper["52_FLOOR"] == 6 then draw_floor("K-") end
      if @upper["25_FLOOR"] >= 0 then draw_floor("L") end
      if @upper["25_FLOOR"] == 1 then draw_floor("L+") end
      if @upper["25_FLOOR"] == 2 then draw_floor("L+") end
      if @upper["25_FLOOR"] == 6 then draw_floor("L-") end
      if @upper["61_FLOOR"] >= 0 then draw_floor("M") end
      if @upper["61_FLOOR"] == 1 then draw_floor("M+") end
      if @upper["61_FLOOR"] == 2 then draw_floor("M+") end
      if @upper["61_FLOOR"] == 6 then draw_floor("M-") end
      if @upper["44_FLOOR"] == 6 then draw_floor("N-") end
      if @upper["35_FLOOR"] == 6 then draw_floor("O-") end
      if @upper["53_FLOOR"] == 6 then draw_floor("P-") end
      if @upper["26_FLOOR"] == 6 then draw_floor("Q-") end
      if @upper["62_FLOOR"] == 6 then draw_floor("R-") end

    when 2 # 下を向いている場合
      ## 壁の描画
      if @lower["41_S"] > 0 then draw_wall(1) end
      if @lower["41_E"] > 0 then draw_wall(2) end
      if @lower["41_W"] > 0 then draw_wall(3) end
      if @lower["42_S"] > 0 then draw_wall(4) end
      if @lower["40_S"] > 0 then draw_wall(5) end
      if @lower["50_S"] > 0 then draw_wall(6) end
      if @lower["50_E"] > 0 then draw_wall(7) end
      if @lower["50_W"] > 0 then draw_wall(8) end
      if @lower["51_S"] > 0 then draw_wall(9) end
      if @lower["49_S"] > 0 then draw_wall(10) end
      if @lower["52_S"] > 0 then draw_wall(11) end
      if @lower["48_S"] > 0 then draw_wall(12) end
      if @lower["51_E"] > 0 then draw_wall(13) end
      if @lower["49_W"] > 0 then draw_wall(14) end
      if @lower["59_E"] > 0 then draw_wall(15) end
      if @lower["59_W"] > 0 then draw_wall(16) end
      if @lower["60_E"] > 0 then draw_wall(17) end
      if @lower["58_W"] > 0 then draw_wall(18) end

      if @lower["59_S"] > 0 then draw_wall(19) end
      if @lower["60_S"] > 0 then draw_wall(20) end
      if @lower["58_S"] > 0 then draw_wall(21) end
      if @lower["61_S"] > 0 then draw_wall(22) end
      if @lower["57_S"] > 0 then draw_wall(23) end
      if @lower["68_S"] > 0 then draw_wall(24) end
      if @lower["69_S"] > 0 then draw_wall(25) end
      if @lower["67_S"] > 0 then draw_wall(26) end
      if @lower["68_E"] > 0 then draw_wall(27) end
      if @lower["68_W"] > 0 then draw_wall(28) end
      if @lower["69_E"] > 0 then draw_wall(29) end
      if @lower["67_W"] > 0 then draw_wall(30) end

      ## 扉の描画
      case @upper["41_DOOR_S"] when 1,2,0xA,0xB then draw_door(1) end
      if @upper["41_DOOR_S"] == 3 then draw_iron_door(1) end
      if @upper["41_DOOR_S"] == 5 then draw_up_stairs(1) end
      if @upper["41_DOOR_S"] == 6 then draw_down_stairs(1) end
      if @upper["41_DOOR_S"] == 4 then draw_t_wall(1) end
      if @upper["41_DOOR_S"] == 7 then draw_switch_wall end
      case @upper["41_DOOR_E"] when 1,2,0xA,0xB then draw_door(2) end
      if @upper["41_DOOR_E"] == 3 then draw_iron_door(2) end
      if @upper["41_DOOR_E"] == 5 then draw_up_stairs(2) end
      if @upper["41_DOOR_E"] == 6 then draw_down_stairs(2) end
      if @upper["41_DOOR_E"] == 4 then draw_t_wall(2) end
      case @upper["41_DOOR_W"] when 1,2,0xA,0xB then draw_door(3) end
      if @upper["41_DOOR_W"] == 3 then draw_iron_door(3) end
      if @upper["41_DOOR_W"] == 5 then draw_up_stairs(3) end
      if @upper["41_DOOR_W"] == 6 then draw_down_stairs(3) end
      if @upper["41_DOOR_W"] == 4 then draw_t_wall(3) end
      case @upper["42_DOOR_S"] when 1,2,0xA,0xB then draw_door(4) end
      if @upper["42_DOOR_S"] == 3 then draw_iron_door(4) end
      if @upper["42_DOOR_S"] == 5 then draw_up_stairs(4) end
      if @upper["42_DOOR_S"] == 6 then draw_down_stairs(4) end
      case @upper["40_DOOR_S"] when 1,2,0xA,0xB then draw_door(5) end
      if @upper["40_DOOR_S"] == 3 then draw_iron_door(5) end
      if @upper["40_DOOR_S"] == 5 then draw_up_stairs(5) end
      if @upper["40_DOOR_S"] == 6 then draw_down_stairs(5) end
      case @upper["50_DOOR_S"] when 1,2,0xA,0xB then draw_door(6) end
      if @upper["50_DOOR_S"] == 3 then draw_iron_door(6) end
      if @upper["50_DOOR_S"] == 5 then draw_up_stairs(6) end
      if @upper["50_DOOR_S"] == 6 then draw_down_stairs(6) end
      if @upper["50_DOOR_S"] == 4 then draw_t_wall(6) end
      case @upper["50_DOOR_E"] when 1,2,0xA,0xB then draw_door(7) end
      if @upper["50_DOOR_E"] == 3 then draw_iron_door(7) end
      if @upper["50_DOOR_E"] == 5 then draw_up_stairs(7) end
      if @upper["50_DOOR_E"] == 6 then draw_down_stairs(7) end
      case @upper["50_DOOR_W"] when 1,2,0xA,0xB then draw_door(8) end
      if @upper["50_DOOR_W"] == 3 then draw_iron_door(8) end
      if @upper["50_DOOR_W"] == 5 then draw_up_stairs(8) end
      if @upper["50_DOOR_W"] == 6 then draw_down_stairs(8) end
      case @upper["51_DOOR_S"] when 1,2,0xA,0xB then draw_door(9) end
      if @upper["51_DOOR_S"] == 3 then draw_iron_door(9) end
      if @upper["51_DOOR_S"] == 5 then draw_up_stairs(9) end
      if @upper["51_DOOR_S"] == 6 then draw_down_stairs(9) end
      case @upper["49_DOOR_S"] when 1,2,0xA,0xB then draw_door(10) end
      if @upper["49_DOOR_S"] == 3 then draw_iron_door(10) end
      if @upper["49_DOOR_S"] == 5 then draw_up_stairs(10) end
      if @upper["49_DOOR_S"] == 6 then draw_down_stairs(10) end
      case @upper["52_DOOR_S"] when 1,2,0xA,0xB then draw_door(11) end
      if @upper["52_DOOR_S"] == 3 then draw_iron_door(11) end
      if @upper["52_DOOR_S"] == 5 then draw_up_stairs(11) end
      if @upper["52_DOOR_S"] == 6 then draw_down_stairs(11) end
      case @upper["48_DOOR_S"] when 1,2,0xA,0xB then draw_door(12) end
      if @upper["48_DOOR_S"] == 3 then draw_iron_door(12) end
      if @upper["48_DOOR_S"] == 5 then draw_up_stairs(12) end
      if @upper["48_DOOR_S"] == 6 then draw_down_stairs(12) end
      case @upper["51_DOOR_E"] when 1,2,0xA,0xB then draw_door(13) end
      if @upper["51_DOOR_E"] == 3 then draw_iron_door(13) end
      if @upper["51_DOOR_E"] == 5 then draw_up_stairs(13) end
      if @upper["51_DOOR_E"] == 6 then draw_down_stairs(13) end
      case @upper["49_DOOR_W"] when 1,2,0xA,0xB then draw_door(14) end
      if @upper["49_DOOR_W"] == 3 then draw_iron_door(14) end
      if @upper["49_DOOR_W"] == 5 then draw_up_stairs(14) end
      if @upper["49_DOOR_W"] == 6 then draw_down_stairs(14) end
      case @upper["59_DOOR_E"] when 1,2,0xA,0xB then draw_door(15) end
      if @upper["59_DOOR_E"] == 3 then draw_iron_door(15) end
      if @upper["59_DOOR_E"] == 5 then draw_up_stairs(15) end
      if @upper["59_DOOR_E"] == 6 then draw_down_stairs(15) end
      case @upper["59_DOOR_W"] when 1,2,0xA,0xB then draw_door(16) end
      if @upper["59_DOOR_W"] == 3 then draw_iron_door(16) end
      if @upper["59_DOOR_W"] == 5 then draw_up_stairs(16) end
      if @upper["59_DOOR_W"] == 6 then draw_down_stairs(16) end
      case @upper["60_DOOR_E"] when 1,2,0xA,0xB then draw_door(17) end
      if @upper["60_DOOR_E"] == 3 then draw_iron_door(17) end
      if @upper["60_DOOR_E"] == 5 then draw_up_stairs(17) end
      if @upper["60_DOOR_E"] == 6 then draw_down_stairs(17) end
      case @upper["58_DOOR_W"] when 1,2,0xA,0xB then draw_door(18) end
      if @upper["58_DOOR_W"] == 3 then draw_iron_door(18) end
      if @upper["58_DOOR_W"] == 5 then draw_up_stairs(18) end
      if @upper["58_DOOR_W"] == 6 then draw_down_stairs(18) end
      case @upper["59_DOOR_S"] when 1,2,0xA,0xB then draw_door(19) end
      if @upper["59_DOOR_S"] == 3 then draw_iron_door(19) end
      if @upper["59_DOOR_S"] == 5 then draw_up_stairs(19) end
      if @upper["59_DOOR_S"] == 6 then draw_down_stairs(19) end
      if @upper["59_DOOR_S"] == 4 then draw_t_wall(19) end
      case @upper["60_DOOR_S"] when 1,2,0xA,0xB then draw_door(20) end
      if @upper["60_DOOR_S"] == 3 then draw_iron_door(20) end
      if @upper["60_DOOR_S"] == 5 then draw_up_stairs(20) end
      if @upper["60_DOOR_S"] == 6 then draw_down_stairs(20) end
      case @upper["58_DOOR_S"] when 1,2,0xA,0xB then draw_door(21) end
      if @upper["58_DOOR_S"] == 3 then draw_iron_door(21) end
      if @upper["58_DOOR_S"] == 5 then draw_up_stairs(21) end
      if @upper["58_DOOR_S"] == 6 then draw_down_stairs(21) end
      case @upper["61_DOOR_S"] when 1,2,0xA,0xB then draw_door(22) end
      if @upper["61_DOOR_S"] == 3 then draw_iron_door(22) end
      if @upper["61_DOOR_S"] == 5 then draw_up_stairs(22) end
      if @upper["61_DOOR_S"] == 6 then draw_down_stairs(22) end
      case @upper["57_DOOR_S"] when 1,2,0xA,0xB then draw_door(23) end
      if @upper["57_DOOR_S"] == 3 then draw_iron_door(23) end
      if @upper["57_DOOR_S"] == 5 then draw_up_stairs(23) end
      if @upper["57_DOOR_S"] == 6 then draw_down_stairs(23) end
      case @upper["68_DOOR_S"] when 1,2,0xA,0xB then draw_door(24) end
      if @upper["68_DOOR_S"] == 3 then draw_iron_door(24) end
      if @upper["68_DOOR_S"] == 5 then draw_up_stairs(24) end
      if @upper["68_DOOR_S"] == 6 then draw_down_stairs(24) end
      case @upper["69_DOOR_S"] when 1,2,0xA,0xB then draw_door(25) end
      if @upper["69_DOOR_S"] == 3 then draw_iron_door(25) end
      if @upper["69_DOOR_S"] == 5 then draw_up_stairs(25) end
      if @upper["69_DOOR_S"] == 6 then draw_down_stairs(25) end
      case @upper["67_DOOR_S"] when 1,2,0xA,0xB then draw_door(26) end
      if @upper["67_DOOR_S"] == 3 then draw_iron_door(26) end
      if @upper["67_DOOR_S"] == 5 then draw_up_stairs(26) end
      if @upper["67_DOOR_S"] == 6 then draw_down_stairs(26) end
      case @upper["68_DOOR_E"] when 1,2,0xA,0xB then draw_door(27) end
      if @upper["68_DOOR_E"] == 3 then draw_iron_door(27) end
      if @upper["68_DOOR_E"] == 5 then draw_up_stairs(27) end
      if @upper["68_DOOR_E"] == 6 then draw_down_stairs(27) end
      case @upper["68_DOOR_W"] when 1,2,0xA,0xB then draw_door(28) end
      if @upper["68_DOOR_W"] == 3 then draw_iron_door(28) end
      if @upper["68_DOOR_W"] == 5 then draw_up_stairs(28) end
      if @upper["68_DOOR_W"] == 6 then draw_down_stairs(28) end
      case @upper["69_DOOR_E"] when 1,2,0xA,0xB then draw_door(29) end
      if @upper["69_DOOR_E"] == 3 then draw_iron_door(29) end
      if @upper["69_DOOR_E"] == 5 then draw_up_stairs(29) end
      if @upper["69_DOOR_E"] == 6 then draw_down_stairs(29) end
      case @upper["67_DOOR_W"] when 1,2,0xA,0xB then draw_door(30) end
      if @upper["67_DOOR_W"] == 3 then draw_iron_door(30) end
      if @upper["67_DOOR_W"] == 5 then draw_up_stairs(30) end
      if @upper["67_DOOR_W"] == 6 then draw_down_stairs(30) end

      ## 床の描画
      if @upper["41_FLOOR"] >= 0 then draw_floor("A") end
      if @upper["41_FLOOR"] == 1 then draw_floor("A+") end
      if @upper["41_FLOOR"] == 2 then draw_floor("A+") end
      if @upper["41_FLOOR"] == 6 then draw_floor("A-") end
      if @upper["42_FLOOR"] >= 0 then draw_floor("B") end
      if @upper["42_FLOOR"] == 1 then draw_floor("B+") end
      if @upper["42_FLOOR"] == 2 then draw_floor("B+") end
      if @upper["42_FLOOR"] == 6 then draw_floor("B-") end
      if @upper["40_FLOOR"] >= 0 then draw_floor("C") end
      if @upper["40_FLOOR"] == 1 then draw_floor("C+") end
      if @upper["40_FLOOR"] == 2 then draw_floor("C+") end
      if @upper["40_FLOOR"] == 6 then draw_floor("C-") end
      if @upper["50_FLOOR"] >= 0 then draw_floor("D") end
      if @upper["50_FLOOR"] == 1 then draw_floor("D+") end
      if @upper["50_FLOOR"] == 2 then draw_floor("D+") end
      if @upper["50_FLOOR"] == 6 then draw_floor("D-") end
      if @upper["51_FLOOR"] >= 0 then draw_floor("E") end
      if @upper["51_FLOOR"] == 1 then draw_floor("E+") end
      if @upper["51_FLOOR"] == 2 then draw_floor("E+") end
      if @upper["51_FLOOR"] == 6 then draw_floor("E-") end
      if @upper["49_FLOOR"] >= 0 then draw_floor("F") end
      if @upper["49_FLOOR"] == 1 then draw_floor("F+") end
      if @upper["49_FLOOR"] == 2 then draw_floor("F+") end
      if @upper["49_FLOOR"] == 6 then draw_floor("F-") end
      if @upper["52_FLOOR"] >= 0 then draw_floor("G") end
      if @upper["52_FLOOR"] == 1 then draw_floor("G+") end
      if @upper["52_FLOOR"] == 2 then draw_floor("G+") end
      if @upper["52_FLOOR"] == 6 then draw_floor("G-") end
      if @upper["48_FLOOR"] >= 0 then draw_floor("H") end
      if @upper["48_FLOOR"] == 1 then draw_floor("H+") end
      if @upper["48_FLOOR"] == 2 then draw_floor("H+") end
      if @upper["48_FLOOR"] == 6 then draw_floor("H-") end
      if @upper["59_FLOOR"] >= 0 then draw_floor("I") end
      if @upper["59_FLOOR"] == 1 then draw_floor("I+") end
      if @upper["59_FLOOR"] == 2 then draw_floor("I+") end
      if @upper["59_FLOOR"] == 6 then draw_floor("I-") end
      if @upper["60_FLOOR"] >= 0 then draw_floor("J") end
      if @upper["60_FLOOR"] == 1 then draw_floor("J+") end
      if @upper["60_FLOOR"] == 2 then draw_floor("J+") end
      if @upper["60_FLOOR"] == 6 then draw_floor("J-") end
      if @upper["58_FLOOR"] >= 0 then draw_floor("K") end
      if @upper["58_FLOOR"] == 1 then draw_floor("K+") end
      if @upper["58_FLOOR"] == 2 then draw_floor("K+") end
      if @upper["58_FLOOR"] == 6 then draw_floor("K-") end
      if @upper["61_FLOOR"] >= 0 then draw_floor("L") end
      if @upper["61_FLOOR"] == 1 then draw_floor("L+") end
      if @upper["61_FLOOR"] == 2 then draw_floor("L+") end
      if @upper["61_FLOOR"] == 6 then draw_floor("L-") end
      if @upper["57_FLOOR"] >= 0 then draw_floor("M") end
      if @upper["57_FLOOR"] == 1 then draw_floor("M+") end
      if @upper["57_FLOOR"] == 2 then draw_floor("M+") end
      if @upper["57_FLOOR"] == 6 then draw_floor("M-") end
      if @upper["68_FLOOR"] == 6 then draw_floor("N-") end
      if @upper["69_FLOOR"] == 6 then draw_floor("O-") end
      if @upper["67_FLOOR"] == 6 then draw_floor("P-") end
      if @upper["70_FLOOR"] == 6 then draw_floor("Q-") end
      if @upper["66_FLOOR"] == 6 then draw_floor("R-") end

    when 4 # 左を向いている
      ## 壁の描画
      if @lower["41_W"] > 0 then draw_wall(1) end
      if @lower["41_S"] > 0 then draw_wall(2) end
      if @lower["41_N"] > 0 then draw_wall(3) end
      if @lower["50_W"] > 0 then draw_wall(4) end
      if @lower["32_W"] > 0 then draw_wall(5) end
      if @lower["40_W"] > 0 then draw_wall(6) end
      if @lower["40_S"] > 0 then draw_wall(7) end
      if @lower["40_N"] > 0 then draw_wall(8) end
      if @lower["49_W"] > 0 then draw_wall(9) end
      if @lower["31_W"] > 0 then draw_wall(10) end
      if @lower["58_W"] > 0 then draw_wall(11) end
      if @lower["22_W"] > 0 then draw_wall(12) end
      if @lower["49_S"] > 0 then draw_wall(13) end
      if @lower["31_N"] > 0 then draw_wall(14) end
      if @lower["39_S"] > 0 then draw_wall(15) end
      if @lower["39_N"] > 0 then draw_wall(16) end
      if @lower["48_S"] > 0 then draw_wall(17) end
      if @lower["30_N"] > 0 then draw_wall(18) end

      if @lower["39_W"] > 0 then draw_wall(19) end
      if @lower["48_W"] > 0 then draw_wall(20) end
      if @lower["30_W"] > 0 then draw_wall(21) end
      if @lower["57_W"] > 0 then draw_wall(22) end
      if @lower["21_W"] > 0 then draw_wall(23) end
      if @lower["38_W"] > 0 then draw_wall(24) end
      if @lower["47_W"] > 0 then draw_wall(25) end
      if @lower["29_W"] > 0 then draw_wall(26) end
      if @lower["38_S"] > 0 then draw_wall(27) end
      if @lower["38_N"] > 0 then draw_wall(28) end
      if @lower["47_S"] > 0 then draw_wall(29) end
      if @lower["29_N"] > 0 then draw_wall(30) end

      ## 扉の描画
      case @upper["41_DOOR_W"] when 1,2,0xA,0xB then draw_door(1) end
      if @upper["41_DOOR_W"] == 3 then draw_iron_door(1) end
      if @upper["41_DOOR_W"] == 5 then draw_up_stairs(1) end
      if @upper["41_DOOR_W"] == 6 then draw_down_stairs(1) end
      if @upper["41_DOOR_W"] == 4 then draw_t_wall(1) end
      if @upper["41_DOOR_W"] == 7 then draw_switch_wall end
      case @upper["41_DOOR_S"] when 1,2,0xA,0xB then draw_door(2) end
      if @upper["41_DOOR_S"] == 3 then draw_iron_door(2) end
      if @upper["41_DOOR_S"] == 5 then draw_up_stairs(2) end
      if @upper["41_DOOR_S"] == 6 then draw_down_stairs(2) end
      if @upper["41_DOOR_S"] == 4 then draw_t_wall(2) end
      case @upper["41_DOOR_N"] when 1,2,0xA,0xB then draw_door(3) end
      if @upper["41_DOOR_N"] == 3 then draw_iron_door(3) end
      if @upper["41_DOOR_N"] == 5 then draw_up_stairs(3) end
      if @upper["41_DOOR_N"] == 6 then draw_down_stairs(3) end
      if @upper["41_DOOR_N"] == 4 then draw_t_wall(3) end
      case @upper["50_DOOR_W"] when 1,2,0xA,0xB then draw_door(4) end
      if @upper["50_DOOR_W"] == 3 then draw_iron_door(4) end
      if @upper["50_DOOR_W"] == 5 then draw_up_stairs(4) end
      if @upper["50_DOOR_W"] == 6 then draw_down_stairs(4) end
      case @upper["32_DOOR_W"] when 1,2,0xA,0xB then draw_door(5) end
      if @upper["32_DOOR_W"] == 3 then draw_iron_door(5) end
      if @upper["32_DOOR_W"] == 5 then draw_up_stairs(5) end
      if @upper["32_DOOR_W"] == 6 then draw_down_stairs(5) end
      case @upper["40_DOOR_W"] when 1,2,0xA,0xB then draw_door(6) end
      if @upper["40_DOOR_W"] == 3 then draw_iron_door(6) end
      if @upper["40_DOOR_W"] == 5 then draw_up_stairs(6) end
      if @upper["40_DOOR_W"] == 6 then draw_down_stairs(6) end
      if @upper["40_DOOR_W"] == 4 then draw_t_wall(6) end
      case @upper["40_DOOR_S"] when 1,2,0xA,0xB then draw_door(7) end
      if @upper["40_DOOR_S"] == 3 then draw_iron_door(7) end
      if @upper["40_DOOR_S"] == 5 then draw_up_stairs(7) end
      if @upper["40_DOOR_S"] == 6 then draw_down_stairs(7) end
      case @upper["40_DOOR_N"] when 1,2,0xA,0xB then draw_door(8) end
      if @upper["40_DOOR_N"] == 3 then draw_iron_door(8) end
      if @upper["40_DOOR_N"] == 5 then draw_up_stairs(8) end
      if @upper["40_DOOR_N"] == 6 then draw_down_stairs(8) end
      case @upper["49_DOOR_W"] when 1,2,0xA,0xB then draw_door(9) end
      if @upper["49_DOOR_W"] == 3 then draw_iron_door(9) end
      if @upper["49_DOOR_W"] == 5 then draw_up_stairs(9) end
      if @upper["49_DOOR_W"] == 6 then draw_down_stairs(9) end
      case @upper["31_DOOR_W"] when 1,2,0xA,0xB then draw_door(10) end
      if @upper["31_DOOR_W"] == 3 then draw_iron_door(10) end
      if @upper["31_DOOR_W"] == 5 then draw_up_stairs(10) end
      if @upper["31_DOOR_W"] == 6 then draw_down_stairs(10) end
      case @upper["58_DOOR_W"] when 1,2,0xA,0xB then draw_door(11) end
      if @upper["58_DOOR_W"] == 3 then draw_iron_door(11) end
      if @upper["58_DOOR_W"] == 5 then draw_up_stairs(11) end
      if @upper["58_DOOR_W"] == 6 then draw_down_stairs(11) end
      case @upper["22_DOOR_W"] when 1,2,0xA,0xB then draw_door(12) end
      if @upper["22_DOOR_W"] == 3 then draw_iron_door(12) end
      if @upper["22_DOOR_W"] == 5 then draw_up_stairs(12) end
      if @upper["22_DOOR_W"] == 6 then draw_down_stairs(12) end
      case @upper["49_DOOR_S"] when 1,2,0xA,0xB then draw_door(13) end
      if @upper["49_DOOR_S"] == 3 then draw_iron_door(13) end
      if @upper["49_DOOR_S"] == 5 then draw_up_stairs(13) end
      if @upper["49_DOOR_S"] == 6 then draw_down_stairs(13) end
      case @upper["31_DOOR_N"] when 1,2,0xA,0xB then draw_door(14) end
      if @upper["31_DOOR_N"] == 3 then draw_iron_door(14) end
      if @upper["31_DOOR_N"] == 5 then draw_up_stairs(14) end
      if @upper["31_DOOR_N"] == 6 then draw_down_stairs(14) end
      case @upper["39_DOOR_S"] when 1,2,0xA,0xB then draw_door(15) end
      if @upper["39_DOOR_S"] == 3 then draw_iron_door(15) end
      if @upper["39_DOOR_S"] == 5 then draw_up_stairs(15) end
      if @upper["39_DOOR_S"] == 6 then draw_down_stairs(15) end
      case @upper["39_DOOR_N"] when 1,2,0xA,0xB then draw_door(16) end
      if @upper["39_DOOR_N"] == 3 then draw_iron_door(16) end
      if @upper["39_DOOR_N"] == 5 then draw_up_stairs(16) end
      if @upper["39_DOOR_N"] == 6 then draw_down_stairs(16) end
      case @upper["48_DOOR_S"] when 1,2,0xA,0xB then draw_door(17) end
      if @upper["48_DOOR_S"] == 3 then draw_iron_door(17) end
      if @upper["48_DOOR_S"] == 5 then draw_up_stairs(17) end
      if @upper["48_DOOR_S"] == 6 then draw_down_stairs(17) end
      case @upper["30_DOOR_N"] when 1,2,0xA,0xB then draw_door(18) end
      if @upper["30_DOOR_N"] == 3 then draw_iron_door(18) end
      if @upper["30_DOOR_N"] == 5 then draw_up_stairs(18) end
      if @upper["30_DOOR_N"] == 6 then draw_down_stairs(18) end
      case @upper["39_DOOR_W"] when 1,2,0xA,0xB then draw_door(19) end
      if @upper["39_DOOR_W"] == 3 then draw_iron_door(19) end
      if @upper["39_DOOR_W"] == 5 then draw_up_stairs(19) end
      if @upper["39_DOOR_W"] == 6 then draw_down_stairs(19) end
      if @upper["39_DOOR_W"] == 4 then draw_t_wall(19) end
      case @upper["48_DOOR_W"] when 1,2,0xA,0xB then draw_door(20) end
      if @upper["48_DOOR_W"] == 3 then draw_iron_door(20) end
      if @upper["48_DOOR_W"] == 5 then draw_up_stairs(20) end
      if @upper["48_DOOR_W"] == 6 then draw_down_stairs(20) end
      case @upper["30_DOOR_W"] when 1,2,0xA,0xB then draw_door(21) end
      if @upper["30_DOOR_W"] == 3 then draw_iron_door(21) end
      if @upper["30_DOOR_W"] == 5 then draw_up_stairs(21) end
      if @upper["30_DOOR_W"] == 6 then draw_down_stairs(21) end
      case @upper["57_DOOR_W"] when 1,2,0xA,0xB then draw_door(22) end
      if @upper["57_DOOR_W"] == 3 then draw_iron_door(22) end
      if @upper["57_DOOR_W"] == 5 then draw_up_stairs(22) end
      if @upper["57_DOOR_W"] == 6 then draw_down_stairs(22) end
      case @upper["21_DOOR_W"] when 1,2,0xA,0xB then draw_door(23) end
      if @upper["21_DOOR_W"] == 3 then draw_iron_door(23) end
      if @upper["21_DOOR_W"] == 5 then draw_up_stairs(23) end
      if @upper["21_DOOR_W"] == 6 then draw_down_stairs(23) end
      case @upper["38_DOOR_W"] when 1,2,0xA,0xB then draw_door(24) end
      if @upper["38_DOOR_W"] == 3 then draw_iron_door(24) end
      if @upper["38_DOOR_W"] == 5 then draw_up_stairs(24) end
      if @upper["38_DOOR_W"] == 6 then draw_down_stairs(24) end
      case @upper["47_DOOR_W"] when 1,2,0xA,0xB then draw_door(25) end
      if @upper["47_DOOR_W"] == 3 then draw_iron_door(25) end
      if @upper["47_DOOR_W"] == 5 then draw_up_stairs(25) end
      if @upper["47_DOOR_W"] == 6 then draw_down_stairs(25) end
      case @upper["29_DOOR_W"] when 1,2,0xA,0xB then draw_door(26) end
      if @upper["29_DOOR_W"] == 3 then draw_iron_door(26) end
      if @upper["29_DOOR_W"] == 5 then draw_up_stairs(26) end
      if @upper["29_DOOR_W"] == 6 then draw_down_stairs(26) end
      case @upper["38_DOOR_S"] when 1,2,0xA,0xB then draw_door(27) end
      if @upper["38_DOOR_S"] == 3 then draw_iron_door(27) end
      if @upper["38_DOOR_S"] == 5 then draw_up_stairs(27) end
      if @upper["38_DOOR_S"] == 6 then draw_down_stairs(27) end
      case @upper["38_DOOR_N"] when 1,2,0xA,0xB then draw_door(28) end
      if @upper["38_DOOR_N"] == 3 then draw_iron_door(28) end
      if @upper["38_DOOR_N"] == 5 then draw_up_stairs(28) end
      if @upper["38_DOOR_N"] == 6 then draw_down_stairs(28) end
      case @upper["47_DOOR_S"] when 1,2,0xA,0xB then draw_door(29) end
      if @upper["47_DOOR_S"] == 3 then draw_iron_door(29) end
      if @upper["47_DOOR_S"] == 5 then draw_up_stairs(29) end
      if @upper["47_DOOR_S"] == 6 then draw_down_stairs(29) end
      case @upper["29_DOOR_N"] when 1,2,0xA,0xB then draw_door(30) end
      if @upper["29_DOOR_N"] == 3 then draw_iron_door(30) end
      if @upper["29_DOOR_N"] == 5 then draw_up_stairs(30) end
      if @upper["29_DOOR_N"] == 6 then draw_down_stairs(30) end

      ## 床の描画
#~       if @upper["41_FLOOR"] >= 0 then draw_floor("A") end
#~       if @upper["41_FLOOR"] == 1 then draw_floor("A+") end
#~       if @upper["41_FLOOR"] == 2 then draw_floor("A+") end
      if @upper["41_FLOOR"] == 6 then draw_floor("A-") end
#~       if @upper["50_FLOOR"] >= 0 then draw_floor("B") end
#~       if @upper["50_FLOOR"] == 1 then draw_floor("B+") end
#~       if @upper["50_FLOOR"] == 2 then draw_floor("B+") end
      if @upper["50_FLOOR"] == 6 then draw_floor("B-") end
#~       if @upper["32_FLOOR"] >= 0 then draw_floor("C") end
#~       if @upper["32_FLOOR"] == 1 then draw_floor("C+") end
#~       if @upper["32_FLOOR"] == 2 then draw_floor("C+") end
      if @upper["32_FLOOR"] == 6 then draw_floor("C-") end
#~       if @upper["40_FLOOR"] >= 0 then draw_floor("D") end
#~       if @upper["40_FLOOR"] == 1 then draw_floor("D+") end
#~       if @upper["40_FLOOR"] == 2 then draw_floor("D+") end
      if @upper["40_FLOOR"] == 6 then draw_floor("D-") end
#~       if @upper["49_FLOOR"] >= 0 then draw_floor("E") end
#~       if @upper["49_FLOOR"] == 1 then draw_floor("E+") end
#~       if @upper["49_FLOOR"] == 2 then draw_floor("E+") end
      if @upper["49_FLOOR"] == 6 then draw_floor("E-") end
#~       if @upper["31_FLOOR"] >= 0 then draw_floor("F") end
#~       if @upper["31_FLOOR"] == 1 then draw_floor("F+") end
#~       if @upper["31_FLOOR"] == 2 then draw_floor("F+") end
      if @upper["31_FLOOR"] == 6 then draw_floor("F-") end
#~       if @upper["39_FLOOR"] >= 0 then draw_floor("G") end
#~       if @upper["39_FLOOR"] == 1 then draw_floor("G+") end
#~       if @upper["39_FLOOR"] == 2 then draw_floor("G+") end
      if @upper["39_FLOOR"] == 6 then draw_floor("G-") end
#~       if @upper["22_FLOOR"] >= 0 then draw_floor("H") end
#~       if @upper["22_FLOOR"] == 1 then draw_floor("H+") end
#~       if @upper["22_FLOOR"] == 2 then draw_floor("H+") end
      if @upper["22_FLOOR"] == 6 then draw_floor("H-") end
#~       if @upper["39_FLOOR"] >= 0 then draw_floor("I") end
#~       if @upper["39_FLOOR"] == 1 then draw_floor("I+") end
#~       if @upper["39_FLOOR"] == 2 then draw_floor("I+") end
      if @upper["39_FLOOR"] == 6 then draw_floor("I-") end
#~       if @upper["48_FLOOR"] >= 0 then draw_floor("J") end
#~       if @upper["48_FLOOR"] == 1 then draw_floor("J+") end
#~       if @upper["48_FLOOR"] == 2 then draw_floor("J+") end
      if @upper["48_FLOOR"] == 6 then draw_floor("J-") end
#~       if @upper["30_FLOOR"] >= 0 then draw_floor("K") end
#~       if @upper["30_FLOOR"] == 1 then draw_floor("K+") end
#~       if @upper["30_FLOOR"] == 2 then draw_floor("K+") end
      if @upper["30_FLOOR"] == 6 then draw_floor("K-") end
#~       if @upper["57_FLOOR"] >= 0 then draw_floor("L") end
#~       if @upper["57_FLOOR"] == 1 then draw_floor("L+") end
#~       if @upper["57_FLOOR"] == 2 then draw_floor("L+") end
      if @upper["57_FLOOR"] == 6 then draw_floor("L-") end
#~       if @upper["21_FLOOR"] >= 0 then draw_floor("M") end
#~       if @upper["21_FLOOR"] == 1 then draw_floor("M+") end
#~       if @upper["21_FLOOR"] == 2 then draw_floor("M+") end
      if @upper["21_FLOOR"] == 6 then draw_floor("M-") end
      if @upper["38_FLOOR"] == 6 then draw_floor("N-") end
      if @upper["47_FLOOR"] == 6 then draw_floor("O-") end
      if @upper["29_FLOOR"] == 6 then draw_floor("P-") end
      if @upper["56_FLOOR"] == 6 then draw_floor("Q-") end
      if @upper["20_FLOOR"] == 6 then draw_floor("R-") end
    end
    ## シークレットドアの描画
    for wall in 1..30
      if draw_secret_door(wall)
        case check_wall_kind
        when 1; draw_door(wall)   # 城壁は扉を書く
        when 2; erase_wall(wall)  # 石壁は壁を消す
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● どのマスが見えている？
  #--------------------------------------------------------------------------
  def check_seeing_place(adj_x, adj_y)
    ## 現在の場所がダークゾーンの場合
    if dark_zone?
      ## その場しか描画しない
      return true if adj_x == 0 and adj_y == 0
      return false
    end
    case $game_player.direction
    when 8  # 北
      ## 北側壁あり
      if @lower["41_N"] > 0
        return false if adj_y < 0
      end
      if @lower["32_N"] > 0
        return false if adj_x == 0 and adj_y == -2
      end
      if @lower["32_E"] > 0 or @lower["42_N"] > 0
        return false if adj_x > 0 and adj_y < 0
      end
      if @lower["32_W"] > 0 or @lower["40_N"] > 0
        return false if adj_x < 0 and adj_y < 0
      end
      if @lower["33_N"] > 0
        return false if adj_x > 0 and adj_y == -2
      end
      if @lower["31_N"] > 0
        return false if adj_x < 0 and adj_y == -2
      end
      if @lower["24_E"] > 0 or @lower["25_S"] > 0
        return false if adj_x == 2 and adj_y == -2
      end
      if @lower["22_W"] > 0 or @lower["21_S"] > 0
        return false if adj_x == -2 and adj_y == -2
      end
      return true
    when 2  # 南
      ## 南側壁あり
      if @lower["41_S"] > 0
        return false if adj_y > 0
      end
      if @lower["50_S"] > 0
        return false if adj_x == 0 and adj_y == 2
      end
      if @lower["50_W"] > 0 or @lower["40_S"] > 0
        return false if adj_x < 0 and adj_y > 0
      end
      if @lower["50_E"] > 0 or @lower["42_S"] > 0
        return false if adj_x > 0 and adj_y > 0
      end
      if @lower["51_S"] > 0
        return false if adj_x > 0 and adj_y == 2
      end
      if @lower["49_S"] > 0
        return false if adj_x < 0 and adj_y == 2
      end
      if @lower["58_W"] > 0 or @lower["57_N"] > 0
        return false if adj_x == -2 and adj_y == 2
      end
      if @lower["60_E"] > 0 or @lower["61_N"] > 0
        return false if adj_x == 2 and adj_y == 2
      end
      return true
    when 6  # 東
      ## 東側壁あり
      if @lower["41_E"] > 0
        return false if adj_x > 0
      end
      if @lower["42_E"] > 0
        return false if adj_x == 2 and adj_y == 0
      end
      if @lower["32_E"] > 0 or @lower["42_N"] > 0
        return false if adj_x > 0 and adj_y < 0
      end
      if @lower["50_E"] > 0 or @lower["42_S"] > 0
        return false if adj_x > 0 and adj_y > 0
      end
      if @lower["33_E"] > 0
        return false if adj_x == 2 and adj_y < 0
      end
      if @lower["51_E"] > 0
        return false if adj_x == 2 and adj_y > 0
      end
      if @lower["24_E"] > 0 or @lower["34_N"] > 0
        return false if adj_x == 2 and adj_y == -2
      end
      if @lower["60_E"] > 0 or @lower["52_S"] > 0
        return false if adj_x == 2 and adj_y == 2
      end
      return true
    when 4  # 西
      ## 西側壁あり
      if @lower["41_W"] > 0
        return false if adj_x < 0
      end
      if @lower["40_W"] > 0
        return false if adj_x == -2 and adj_y == 0
      end
      if @lower["32_W"] > 0 or @lower["40_N"] > 0
        return false if adj_x < 0 and adj_y < 0
      end
      if @lower["50_W"] > 0 or @lower["40_S"] > 0
        return false if adj_x < 0 and adj_y > 0
      end
      if @lower["31_W"] > 0
        return false if adj_x == -2 and adj_y < 0
      end
      if @lower["49_W"] > 0
        return false if adj_x == -2 and adj_y > 0
      end
      if @lower["22_W"] > 0 or @lower["30_N"] > 0
        return false if adj_x == -2 and adj_y == -2
      end
      if @lower["58_W"] > 0 or @lower["48_S"] > 0
        return false if adj_x == -2 and adj_y == 2
      end
      return true
    end
  end
  #--------------------------------------------------------------------------
  # ● 前進可否判定
  #--------------------------------------------------------------------------
  def check_can_forward # 前に壁が無いか調査
    if check_wall_kind == 2
      return true if draw_secret_door(1)
    end
    case $game_player.direction
    when 8 # 北向き
      return false if @lower["41_N"] != 0 # 壁情報があればfalseをreturn
    when 6 # 東向き
      return false if @lower["41_E"] != 0
    when 4 # 西向き
      return false if @lower["41_W"] != 0
    when 2 # 南向き
      return false if @lower["41_S"] != 0
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 目の前が閂扉（入口）判定
  #--------------------------------------------------------------------------
  def check_1way_door_in
    case $game_player.direction
    when 8 # 北向き
      return 8 if @upper["41_DOOR_N"] == 0xB
    when 6 # 東向き
      return 6 if @upper["41_DOOR_E"] == 0xB
    when 4 # 西向き
      return 4 if @upper["41_DOOR_W"] == 0xB
    when 2 # 南向き
      return 2 if @upper["41_DOOR_S"] == 0xB
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 目の前が閂扉（出口）判定
  #--------------------------------------------------------------------------
  def check_1way_door_out
    case $game_player.direction
    when 8 # 北向き
      return 8 if @upper["41_DOOR_N"] == 0xA
    when 6 # 東向き
      return 6 if @upper["41_DOOR_E"] == 0xA
    when 4 # 西向き
      return 4 if @upper["41_DOOR_W"] == 0xA
    when 2 # 南向き
      return 2 if @upper["41_DOOR_S"] == 0xA
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 目の前がスイッチ判定
  #--------------------------------------------------------------------------
  def check_switch_wall
    case $game_player.direction
    when 8 # 北向き
      return 8 if @upper["41_DOOR_N"] == 0x7
    when 6 # 東向き
      return 6 if @upper["41_DOOR_E"] == 0x7
    when 4 # 西向き
      return 4 if @upper["41_DOOR_W"] == 0x7
    when 2 # 南向き
      return 2 if @upper["41_DOOR_S"] == 0x7
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 四方がスイッチ壁か？
  #--------------------------------------------------------------------------
  def check_switch
    return true if @upper["41_DOOR_N"] == 7
    return true if @upper["41_DOOR_E"] == 7
    return true if @upper["41_DOOR_W"] == 7
    return true if @upper["41_DOOR_S"] == 7
    return false
  end
  #--------------------------------------------------------------------------
  # ● 目の前が水たまり判定
  #--------------------------------------------------------------------------
  def check_water
    case $game_player.direction
    when 8 # 北向き
      return @upper["32_FLOOR"] == 6 # 目の前が水か？
    when 6 # 東向き
      return @upper["42_FLOOR"] == 6
    when 4 # 西向き
      return @upper["40_FLOOR"] == 6
    when 2 # 南向き
      return @upper["50_FLOOR"] == 6
    end
  end
  #--------------------------------------------------------------------------
  # ● 橋がかけられるか？
  #--------------------------------------------------------------------------
  def check_can_bridge # 2歩前に壁が無いか調査
    case $game_player.direction
    when 8 # 北向き
      return false if @lower["41_N"] != 0 # そのブロックの前壁判定
      return false if @lower["32_N"] != 0 # 1歩前の壁判定
      return false if @upper["32_FLOOR"] != 6 # 一歩前は水ではないか？
      return false if @upper["23_FLOOR"] == 6 # 二歩前は水か？
      return true
    when 6 # 東向き
      return false if @lower["41_E"] != 0 # そのブロックの前壁判定
      return false if @lower["42_E"] != 0 # 1歩前の壁判定
      return false if @upper["42_FLOOR"] != 6 # 一歩前は水ではないか？
      return false if @upper["43_FLOOR"] == 6 # 二歩前は水か？
      return true
    when 4 # 西向き
      return false if @lower["41_W"] != 0
      return false if @lower["40_W"] != 0
      return false if @upper["40_FLOOR"] != 6
      return false if @upper["39_FLOOR"] == 6 # 二歩前は水か？
      return true
    when 2 # 南向き
      return false if @lower["41_S"] != 0
      return false if @lower["50_S"] != 0
      return false if @upper["50_FLOOR"] != 6
      return false if @upper["59_FLOOR"] == 6 # 二歩前は水か？
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 目の前がダークゾーン判定
  #--------------------------------------------------------------------------
  def check_darkzone
    case $game_player.direction
    when 8 # 北向き
      return true if @upper["32_FLOOR"] == 3 # 目の前がダークゾーンか？
    when 6 # 東向き
      return true if @upper["42_FLOOR"] == 3
    when 4 # 西向き
      return true if @upper["40_FLOOR"] == 3
    when 2 # 南向き
      return true if @upper["50_FLOOR"] == 3
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 呪文禁止床チェック
  #--------------------------------------------------------------------------
  def check_slient_floor
    return @upper["41_FLOOR"] == 0x7 # 現在値が呪文禁止？
  end
  #--------------------------------------------------------------------------
  # ● ランダムイベント床チェック
  #--------------------------------------------------------------------------
  def check_random_floor
    return @upper["41_FLOOR"] == 0x8 # 現在値がランダムイベントフラグ？
  end
  #--------------------------------------------------------------------------
  # ● イベント床チェック
  #--------------------------------------------------------------------------
  def check_event_floor
    return @upper["41_FLOOR"] == 0x1 # 現在値がイベントフラグ？
  end
  #--------------------------------------------------------------------------
  # ● 毒霧床チェック
  #--------------------------------------------------------------------------
  def check_poison_floor
    return @upper["41_FLOOR"] == 0x9 # 現在値が毒霧フラグ？
  end
  #--------------------------------------------------------------------------
  # ● イベント（ハーブ）床チェック
  #--------------------------------------------------------------------------
  def check_herb_floor
    return @upper["41_FLOOR"] == 0xA # 現在値がフラグ？
  end
  #--------------------------------------------------------------------------
  # ● イベント（きのこ）床チェック
  #--------------------------------------------------------------------------
  def check_mush_floor
    return @upper["41_FLOOR"] == 0xB # 現在値がフラグ？
  end
  #--------------------------------------------------------------------------
  # ● 罠：ピット床チェック
  #--------------------------------------------------------------------------
  def check_pit_floor
    return @upper["41_FLOOR"] == 0xC # 現在値がフラグ？
  end
  #--------------------------------------------------------------------------
  # ● 罠：邪神像床チェック
  #--------------------------------------------------------------------------
  def check_evilstatue_floor
    return @upper["41_FLOOR"] == 0xD # 現在値がフラグ？
  end
  #--------------------------------------------------------------------------
  # ● 罠：回転床チェック
  #--------------------------------------------------------------------------
  def check_turn_floor
    return @upper["41_FLOOR"] == 0x1F # 現在値がフラグ？
  end
  #--------------------------------------------------------------------------
  # ● 罠：すべる床チェック
  #--------------------------------------------------------------------------
  def check_slip_floor_n
    return @upper["41_FLOOR"] == 0x11 # 現在値がフラグ？
  end
  def check_slip_floor_e
    return @upper["41_FLOOR"] == 0x12 # 現在値がフラグ？
  end
  def check_slip_floor_s
    return @upper["41_FLOOR"] == 0x13 # 現在値がフラグ？
  end
  def check_slip_floor_w
    return @upper["41_FLOOR"] == 0x14 # 現在値がフラグ？
  end
  #--------------------------------------------------------------------------
  # ● 罠：ダストシュートチェック
  #--------------------------------------------------------------------------
  def check_dustshoot
    return @upper["41_FLOOR"] == 0x15 # 現在値がフラグ？
  end
  #--------------------------------------------------------------------------
  # ● 魔法の水汲み場チェック
  #--------------------------------------------------------------------------
  def check_drawing_fountain_floor
    return @upper["41_FLOOR"] == 0x16 # 現在値がフラグ？
  end
  #--------------------------------------------------------------------------
  # ● ゴミ捨て場チェック
  #--------------------------------------------------------------------------
  def check_dump_floor
    return @upper["41_FLOOR"] == 0x17 # 現在値がフラグ？
  end
  #--------------------------------------------------------------------------
  # ● 帰還の魔法陣（留守）場チェック
  #--------------------------------------------------------------------------
  def check_return_floor
    return @upper["41_FLOOR"] == 0x18 # 現在値がフラグ？
  end
  #--------------------------------------------------------------------------
  # ● エレベータチェック
  # kind 1: メインエレベータ(リフトカードが必要)
  #--------------------------------------------------------------------------
  def check_elevator(kind)
    case kind
    when 1
      return @upper["41_FLOOR"] == 0x5 # 現在値がフラグ？
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 現在地の壁情報を取得
  #--------------------------------------------------------------------------
  def now_wallinfo(f=41) # 現在の座標の壁情報を取得 visit_place用
    n = 0b0
    e = 0b0
    s = 0b0
    w = 0b0
    nd = 0b0
    ed = 0b0
    sd = 0b0
    wd = 0b0

    n  = 0b10000000000 if @lower["#{f}_N"] >= 1
    e  = 0b01000000000 if @lower["#{f}_E"] >= 1
    s  = 0b00100000000 if @lower["#{f}_S"] >= 1
    w  = 0b00010000000 if @lower["#{f}_W"] >= 1
    nd = 0b00001000000 if @upper["#{f}_DOOR_N"] >= 1
    ed = 0b00000100000 if @upper["#{f}_DOOR_E"] >= 1
    sd = 0b00000010000 if @upper["#{f}_DOOR_S"] >= 1
    wd = 0b00000001000 if @upper["#{f}_DOOR_W"] >= 1
    nd = 0b00000000000 if @upper["#{f}_DOOR_N"] == 4  # シークレットドア
    ed = 0b00000000000 if @upper["#{f}_DOOR_E"] == 4
    sd = 0b00000000000 if @upper["#{f}_DOOR_S"] == 4
    wd = 0b00000000000 if @upper["#{f}_DOOR_W"] == 4
    nd = 0b00000000000 if @upper["#{f}_DOOR_N"] == 5  # 階段
    ed = 0b00000000000 if @upper["#{f}_DOOR_E"] == 5
    sd = 0b00000000000 if @upper["#{f}_DOOR_S"] == 5
    wd = 0b00000000000 if @upper["#{f}_DOOR_W"] == 5
    nd = 0b00000000000 if @upper["#{f}_DOOR_N"] == 6  # 階段
    ed = 0b00000000000 if @upper["#{f}_DOOR_E"] == 6
    sd = 0b00000000000 if @upper["#{f}_DOOR_S"] == 6
    wd = 0b00000000000 if @upper["#{f}_DOOR_W"] == 6
    nd = 0b00000000000 if @upper["#{f}_DOOR_N"] == 7  # 壁スイッチ
    ed = 0b00000000000 if @upper["#{f}_DOOR_E"] == 7
    sd = 0b00000000000 if @upper["#{f}_DOOR_S"] == 7
    wd = 0b00000000000 if @upper["#{f}_DOOR_W"] == 7

    ## 0=nothing,1=event,3=dz,4=玄室,6=water,7=magic,8=randomは使用済み
    ## 4(0b100),2(0b010)を階段2種に使う
    floor_b = nil
    floor_b = 0b010 if @upper["#{f}_DOOR_N"] == 5  # 階段
    floor_b = 0b010 if @upper["#{f}_DOOR_E"] == 5
    floor_b = 0b010 if @upper["#{f}_DOOR_S"] == 5
    floor_b = 0b010 if @upper["#{f}_DOOR_W"] == 5
    floor_b = 0b101 if @upper["#{f}_DOOR_N"] == 6  # 階段
    floor_b = 0b101 if @upper["#{f}_DOOR_E"] == 6
    floor_b = 0b101 if @upper["#{f}_DOOR_S"] == 6
    floor_b = 0b101 if @upper["#{f}_DOOR_W"] == 6

    floor_b = 0b111 if @upper["#{f}_FLOOR"] == 5 # Elevator
    floor_b = 0b000 if @upper["#{f}_FLOOR"] == 7 # Antimagic


    if floor_b == nil                   # 床情報を２進数に
      case @upper["#{f}_FLOOR"]
      when 0x8      # ランダムグリッド検知
        floor_b = 0
      when 0x3,0x6  # DZ,Water
        floor_b = @upper["#{f}_FLOOR"]
      else
        ## そのまま代入すると16進でFFまで入ることになる。
        floor_b = 0
      end
    end

    bdata = n + e + s + w + nd + ed + sd + wd + floor_b
#~     DEBUG.write(c_m, "Wall Info 0b#{bdata.to_s(2)}")
    return bdata
  end
  #--------------------------------------------------------------------------
  # ● 正面の扉の種類を取得
  #--------------------------------------------------------------------------
  def check_door # 前の扉が開く扉か判定
    if check_wall_kind == 1
      return 1 if draw_secret_door(1) # 城壁で目の前が発見済みシークレットドアなら
    end
    case $game_player.direction
    when 8 # 北向き
      return @upper["41_DOOR_N"] # 扉の種類が1なら
    when 6 # 東向き
      return @upper["41_DOOR_E"] # 扉の種類が1なら
    when 4 # 西向き
      return @upper["41_DOOR_W"] # 扉の種類が1なら
    when 2 # 南向き
      return @upper["41_DOOR_S"] # 扉の種類が1なら
    end
  end
  #--------------------------------------------------------------------------
  # ● 隠し扉の入力
  #--------------------------------------------------------------------------
  def input_kakushi
    x = $game_player.x
    y = $game_player.y
    id = $game_map.map_id
    direction = $game_player.direction
    $game_player.kakushi[x, y, id] = direction # 上記座標と向きに隠し扉あり
    $game_player.visit_place
    input_kakushi_anotherside # 逆側からも隠し扉を入力
    DEBUG.write(c_m, "#{$game_player.kakushi}")
  end
  #--------------------------------------------------------------------------
  # ● 反対側の扉の隠し扉の処理
  #--------------------------------------------------------------------------
  def input_kakushi_anotherside
    # 反対側からみた扉状態も解除にする-------------------------------
    x = $game_player.x
    y = $game_player.y
    id = $game_map.map_id
    direction = $game_player.direction
    case direction
    when 8 # 北向き
      direction = 2
      y -= 1
    when 6 # 東向き
      direction = 4
      x += 1
    when 4 # 西向き
      direction = 6
      x -= 1
    when 2 # 南向き
      direction = 8
      y += 1
    end
    $game_player.kakushi[x, y, id] = direction # 上記座標と向きに鍵開済扉あり
  end
  #--------------------------------------------------------------------------
  # ● 鍵穴を破壊した扉の保管
  #--------------------------------------------------------------------------
  def input_broken(id=nil, x=nil ,y=nil ,direction=nil)
    # @kakushi[Didxxxyyy] = true or false
    x = $game_player.x if x == nil
    y = $game_player.y if y == nil
    id = $game_map.map_id if id == nil
    direction = $game_player.direction if direction == nil
    $game_player.broken[x, y, id] = direction # 上記座標と向きに壊れた扉あり
  end
  #--------------------------------------------------------------------------
  # ● 開錠した扉の保管
  #--------------------------------------------------------------------------
  def input_unlock(id=nil, x=nil ,y=nil ,direction=nil)
    x = $game_player.x if x == nil
    y = $game_player.y if y == nil
    id = $game_map.map_id if id == nil
    direction = $game_player.direction if direction == nil
    DEBUG.write(c_m, "x:#{x} y:#{y} map:#{id} direction:#{direction}")
    result = $game_player.unlock[x, y, id] == 0 ? true : false
    $game_player.unlock[x, y, id] = direction  # 上記座標と向きに鍵開済扉あり
    input_unlock_anotherside(id, x, y, direction) # 反対側の扉の開錠処理
    return result # すでにアンロック済みであればfalseを返答
  end
  #--------------------------------------------------------------------------
  # ● スイッチを押したことによる付近の鉄格子のアンロック
  #--------------------------------------------------------------------------
  def input_unlock_byswitch
    r = false
    cur_x = $game_player.x  # 現在の座標
    cur_y = $game_player.y
    for adj_x in -1..1
      for adj_y in -1..1
        case $game_map.data[ (cur_x + adj_x), (cur_y + adj_y), 2]
        when 25; r = input_unlock(nil, (cur_x + adj_x), (cur_y + adj_y), 8); return r # 北向きにスイッチ
        when 26; r = input_unlock(nil, (cur_x + adj_x), (cur_y + adj_y), 6); return r # 東向きにスイッチ
        when 28; r = input_unlock(nil, (cur_x + adj_x), (cur_y + adj_y), 4); return r # 西向きにスイッチ
        when 27; r = input_unlock(nil, (cur_x + adj_x), (cur_y + adj_y), 2); return r # 南向きにスイッチ
        end
      end
    end
    return r  # すでにアンロック済みであればfalseを返答
  end
  #--------------------------------------------------------------------------
  # ● 反対側の扉の開錠処理
  #--------------------------------------------------------------------------
  def input_unlock_anotherside(id, x, y, direction)
    # 反対側からみた扉状態も解除にする-------------------------------
    case direction
    when 8 # 北向き
      direction = 2
      y -= 1
    when 6 # 東向き
      direction = 4
      x += 1
    when 4 # 西向き
      direction = 6
      x -= 1
    when 2 # 南向き
      direction = 8
      y += 1
    end
    $game_player.unlock[x, y, id] = direction # 上記座標と向きに鍵開済扉あり
    DEBUG.write(c_m, "x:#{x} y:#{y} id:#{id} direction:#{direction}")
  end
  #--------------------------------------------------------------------------
  # ● 解錠状態の削除（鉄格子イベント）
  #--------------------------------------------------------------------------
  def clear_unlock(id, x , y, direction)
    $game_player.unlock[x, y, id] = 0 # Directionを消去
    clear_unlock_anotherside(id, x, y, direction) # 反対側の扉の開錠処理
  end
  #--------------------------------------------------------------------------
  # ● 反対側の扉の解錠状態消去
  #--------------------------------------------------------------------------
  def clear_unlock_anotherside(id, x, y, direction)
    # 反対側からみた扉状態も削除-------------------------------
    case direction
    when 8 # 北向き
      y -= 1
    when 6 # 東向き
      x += 1
    when 4 # 西向き
      x -= 1
    when 2 # 南向き
      y += 1
    end
    $game_player.unlock[x, y, id] = 0 # 上記座標と向きに鍵開済扉あり
  end
  #--------------------------------------------------------------------------
  # ● 秘密発見済みの入力
  #--------------------------------------------------------------------------
  def input_secret
    x = $game_player.x
    y = $game_player.y
    id = $game_map.map_id
    $game_player.input_secret(x, y, id)
    DEBUG.write(c_m, "x:#{x} y:#{y} B#{id}F")
  end
  #--------------------------------------------------------------------------
  # ● 踏破度の確認
  #     mapid: 地図ID   floor:フロア階層
  #--------------------------------------------------------------------------
  def check_mapkit_completion(mapid, floor)
    map = load_data(sprintf("Data/Map%03d.rvdata", floor))
    num = 0 # 踏破不可能
    got = 0 # 踏破済み
    for x in 0..49
      for y in 0..49
        ## 石ブロック？
        num += 1 if map.data[x, y, 0] == 1543
        ## 踏破済み？
        got += 1 if $game_mapkits[mapid].map_data.include?([floor*10000+x*100+y])
      end
    end
    ## 踏破すべきマス,
    candidate = (50 * 50 - num)
    ratio = got / candidate.to_f
    ratio *= 100.0
    ## 踏破可能、踏破済み、踏破率
    return candidate, got, ratio
  end
  #--------------------------------------------------------------------------
  # ● 階段チェック
  #--------------------------------------------------------------------------
  def get_stair(direction = nil)
    direction = $game_player.direction if direction == nil
    case direction
    when 8
      case @upper["41_DOOR_N"]
      when 5;  return 1
      when 6;  return 2
      end
    when 6 # 東向き
      case @upper["41_DOOR_E"]
      when 5;  return 1
      when 6;  return 2
      end
    when 2 # 南向き
      case @upper["41_DOOR_S"]
      when 5;  return 1
      when 6;  return 2
      end
    when 4 # 西向き
      case @upper["41_DOOR_W"]
      when 5;  return 1
      when 6;  return 2
      end
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 下のフロアの同座標の壁データを取得
  #--------------------------------------------------------------------------
  def get_stair_below_floor(floor_diff)
    now_x = $game_player.x
    now_y = $game_player.y
    map = load_data(sprintf("Data/Map%03d.rvdata", $game_map.map_id + floor_diff))
    wall_info = wall_id_to_wall_info_upper(map.data[ now_x, now_y, 2])
    n_wall = (wall_info / 0x1000) % 16	# 1000の位
    e_wall = (wall_info / 0x100) % 16		# 100の位
    s_wall = (wall_info / 0x10) % 16		# 10の位
    w_wall = (wall_info / 0x1) % 16			# 1の位
    return n_wall, e_wall, s_wall, w_wall
  end
end
