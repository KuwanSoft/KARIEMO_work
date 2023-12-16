#==============================================================================
# ■ DEBUG用現在実行中メソッドの名前を文字列で持ってくる。
# http://d.hatena.ne.jp/secondlife/20051013/1129210792 より拝借
#==============================================================================
class Object
  def c_m # current method
    caller.first.scan(/`(.*)'/).to_s
  end
  def c_cm # current Class & Method
    "#{self.class}##{caller.first.scan(/`(.*)'/).to_s}"
    # "#{self.class}##{caller.first[/([^']*)'/, 1]}"
  end
  # def c_cm # current Class & Method
  #   mod_nest = Module.nesting
  #   mod_name = mod_nest.empty? ? self.class : mod_nest.first
  #   "#{mod_name}##{caller.first[/`([^']*)'/, 1]}"
  # end
end


