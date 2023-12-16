# require 'Win32API'

class Font
  AUTO_LOAD = false
  FONT_FOLDER = 'Fonts2'

  WM_FONTCHANGE = 0x1D
  HWND_BROADCAST = 0xFFFF
  AddFontResource = Win32API.new('gdi32', 'AddFontResource', ['P'], 'L')
  SendMessage = Win32API.new('user32', 'SendMessage', ['L', 'L', 'L', 'P'], 'L')
  SendNotifyMessage = Win32API.new('user32', 'SendNotifyMessage', 'LLLP', 'L')
  RemoveFontResource = Win32API.new('gdi32', 'RemoveFontResource', ['P'], 'L')
  @@memory_fonts = []

  def self.add(*filenames)
    filenames.each do |f|
      next if @@memory_fonts.include?(f)
      AddFontResource.call(f)
      @@memory_fonts.push(f)
      # ログなどで確認用のメッセージを出力する
    end
  end

  def self.send_mes
    # フォントの反映に十分な時間を待機する（1000ミリ秒 = 1秒）
    # sleep 5
    # SendMessage.call(HWND_BROADCAST, WM_FONTCHANGE, 0, 0)
    SendNotifyMessage.call(HWND_BROADCAST, WM_FONTCHANGE, 0, 0)
    # ログなどで確認用のメッセージを出力する
  end

  def self.auto_load
    dir = File.join(Dir.pwd, FONT_FOLDER)
    return unless File.directory?(dir)
    files = Dir.glob(File.join(dir, '*.{ttf,otf}'))
    self.add(*files)
  end

  def self.remove_resource(f)
    i = 0
    while i < Constant_Table::TIMEOUT_POSTPROCESS
      rc = RemoveFontResource.call(f)
      break if rc > 0
      i += 1
    end
  end
end

if Font::AUTO_LOAD
  Font.auto_load
  Font.send_mes
end
