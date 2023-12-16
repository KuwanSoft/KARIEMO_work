class Window_Treasure_Box < Window_Base
  #--------------------------------------------------------------------------
  # ● 初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 64, 64)
    self.opacity = 0
    self.z = 30
    @box = Sprite.new
    @box.bitmap = Cache.system("chest3")
    @box.x = 512/2
    @box.y = WLH*(22)
    @box.z = self.z + 1
    @box.ox = @box.width / 2
    @box.oy = @box.height / 2
  end
  #--------------------------------------------------------------------------
  # ● 画像を宝箱から戦利品へ
  #--------------------------------------------------------------------------
  def change_to_treasure
    @box.bitmap = Cache.system("treasure2")
    @box.ox = @box.width / 2
    @box.oy = @box.height / 2
  end
  #--------------------------------------------------------------------------
  # ● dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @box.bitmap.dispose
    @box.dispose
  end
end
