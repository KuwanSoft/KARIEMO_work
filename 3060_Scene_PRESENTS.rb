#==============================================================================
# ■ Scene_PRESENTS
#------------------------------------------------------------------------------
# タイトル画面の前のプレゼンツ処理を行うクラス
#==============================================================================

class Scene_PRESENTS < Scene_Base
  def initialize
    @time = 0
    @everard = Window_Everard.new
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    presents
  end
  #--------------------------------------------------------------------------
  # ● ロゴの表示
  #--------------------------------------------------------------------------
  def presents
    vol = IniFile.read("Game.ini", "Settings", "MASTER_ME_VOLUME", Constant_Table::MASTER_ME_VOLUME)
    RPG::ME.new("jingle-logo01-wav",vol,100).play
    @pre = Window_PRESENTS.new
    @pre.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
#~     @logo.bitmap.dispose
#~     @logo.dispose
    @pre.dispose
    @everard.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @everard.update
    if @time == 0
      Graphics.fadein(50)
    elsif @time == 100
      Graphics.fadeout(50)
      @pre.visible = false
    elsif @time == 150
      @everard.visible = true
      Graphics.fadein(20)
    elsif @time == 220
      Graphics.fadeout(50)
    elsif @time == 250
      @everard.refresh(2)
      Graphics.fadein(20)
    elsif @time == 320
      Graphics.fadeout(50)
    elsif @time == 350
      $scene = Scene_Title.new
    end
    @time += 1
  end
end
