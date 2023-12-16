#==============================================================================
# ■ Scene_Treasure
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Ending < Scene_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @message = Window_Message.new(0, 0, 544, 416)
    @text = [
#~     "- Design -"
#~     "Original Concept"
#~     "Director"
#~     "Lead Designer"
#~     "Level / Scenario Design"
#~     "Writing / Dialogue / Story"
#~     "Research"
#~     "- Programming -"
#~     "Technical Director"
#~     "Lead Programming"
#~     "Programming"
#~     "Additional Programming"
#~     "Game Engine / Development System"
#~     "Graphics Programming"
#~     "Music / Sound Programming"
#~     "Libraries / Utilities"
#~     "- Graphics -"
#~     "Art Director"
#~     "Lead Artist"
#~     "Graphics / Artwork"
#~     "Additional Graphics / Artwork"
#~     "Animation"
#~     "- Music and Sound -"
#~     "Music"
#~     "Sound"
#~     "Acting / Voiceovers"
#~     "- Management -"
#~     "Project Leader"
#~     "Producer"
#~     "Executive Producer"
#~     "Associate Producer"
#~     "Assistant Producer"
#~     "Product Manager"
#~     "Marketing / PR"
#~     "Management"
#~     "- Box & Content -"
#~     "Production / Packaging"
#~     "Cover Design"
#~     "Documentation / Manual"
#~     "Manual Illustrations / Photos"
#~     "Localization / Translation"
#~     "- Support -"
#~     "Support"
#~     "Webmaster"
#~     "Playtesting"
#~     "Quality Assurance"
#~     "Special Thanks to"
    ]
  end

  def start
    @message.add_instant_text
  end
end
