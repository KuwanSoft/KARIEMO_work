class Magics
  attr_accessor :id
  attr_accessor :sort
  attr_accessor :domain
  attr_accessor :name
  attr_accessor :purpose
  attr_accessor :skill
  attr_accessor :cost
  attr_accessor :difficulty
  attr_accessor :tier
  attr_accessor :use
  attr_accessor :target
  attr_accessor :target_num
  attr_accessor :lc
  attr_accessor :resist
  attr_accessor :anim_id
  attr_accessor :damage
  attr_accessor :element_type
  attr_accessor :element
  attr_accessor :add_state_set
  attr_accessor :remove_state_set
  attr_accessor :depend
  attr_accessor :depend_class
  attr_accessor :fire
  attr_accessor :water
  attr_accessor :air
  attr_accessor :earth
  attr_accessor :summ
  attr_accessor :comment
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def name
    return @name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def comment
    return @comment.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 付加異常を取得
  #--------------------------------------------------------------------------
  def add_state_set
    return @add_state_set.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 回復異常を取得
  #--------------------------------------------------------------------------
  def remove_state_set
    return @remove_state_set.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 属性IDを取得
  #--------------------------------------------------------------------------
  def element_type
    return @element_type.to_i
  end
  #--------------------------------------------------------------------------
  # ● 属性を取得
  #--------------------------------------------------------------------------
  def element
    return @element.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 詠唱難易度を取得
  #--------------------------------------------------------------------------
  def difficulty
    return @difficulty.to_f
  end
  #--------------------------------------------------------------------------
  # ● 対象は敵側か
  #--------------------------------------------------------------------------
  def for_opponent?
    return ["group","solo","all","random"].include?(@target)
  end
  #--------------------------------------------------------------------------
  # ● 対象はグループか
  #--------------------------------------------------------------------------
  def group?
    return @target == "group"
  end
  #--------------------------------------------------------------------------
  # ● 対象は単体か
  #--------------------------------------------------------------------------
  def solo?
    return ["solo","friend"].include?(@target)
  end
  #--------------------------------------------------------------------------
  # ● 対象は全体か
  #--------------------------------------------------------------------------
  def all?
    return @target == "all"
  end
  #--------------------------------------------------------------------------
  # ● 対象はランダムか
  #--------------------------------------------------------------------------
  def random?
    return @target == "random"
  end
  #--------------------------------------------------------------------------
  # ● 対象はフィールドか
  #--------------------------------------------------------------------------
  def field?
    return @target == "field"
  end
  #--------------------------------------------------------------------------
  # ● 対象は自分以外か
  #--------------------------------------------------------------------------
  def exceptme?
    return @target == "exceptme"
  end
  #--------------------------------------------------------------------------
  # ● 対象は見方側か
  #--------------------------------------------------------------------------
  def for_friend?
    return ["party","friend","self"].include?(@target)
  end
  #--------------------------------------------------------------------------
  # ● 対象の選択が必要か
  #--------------------------------------------------------------------------
  def need_selection?
    return ["group","solo","friend"].include?(@target)
  end
  #--------------------------------------------------------------------------
  # ● ターゲットが必要か（イベントや対象が必要無い場合はいらない）
  #--------------------------------------------------------------------------
  def need_target?
    return ["group","solo","party","all","random","self","friend","field","exceptme"].include?(@target)
  end
  #--------------------------------------------------------------------------
  # ● 自分自身に使用するか？
  #--------------------------------------------------------------------------
  def for_user?
    return ["self"].include?(@target)
  end
  #--------------------------------------------------------------------------
  # ● 味方全員？
  #--------------------------------------------------------------------------
  def for_friends_all?
    return ["party"].include?(@target)
  end
  #--------------------------------------------------------------------------
  # ● パーティマジックか？
  #--------------------------------------------------------------------------
  def party_magic?
    return @use == "partymagic" # メニューからのみの使用（CAMP）
  end
  #--------------------------------------------------------------------------
  # ● 習得前提呪文
  #--------------------------------------------------------------------------
  def depend
    return @depend.to_s
  end
end