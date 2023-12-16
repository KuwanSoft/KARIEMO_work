#==============================================================================
# * エセフルスクリーン
# @author : CACAO
# @note   : F5キーを押すとウィンドウのサイズを３段階で変更します。
#

module WLIB
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  # SystemMetrics
  SM_CXSCREEN   = 0x00
  SM_CYSCREEN   = 0x01
  SM_CYCAPTION  = 0x04
  SM_CXDLGFRAME = 0x07
  SM_CYDLGFRAME = 0x08
  # SetWindowPos
  SWP_NOSIZE     = 0x01
  SWP_NOMOVE     = 0x02
  SWP_NOZORDER   = 0x04
  SWP_NOACTIVATE = 0x10
  SWP_SHOWWINDOW = 0x40
  SWP_HIDEWINDOW = 0x80
  #--------------------------------------------------------------------------
  # ● Win32API
  #--------------------------------------------------------------------------
  @@FindWindow =
    Win32API.new('user32', 'FindWindow', 'pp', 'l')
  @@GetDesktopWindow =
    Win32API.new('user32', 'GetDesktopWindow', 'v', 'l')
  @@SetWindowPos =
    Win32API.new('user32', 'SetWindowPos', 'lliiiii', 'i')
  @@GetClientRect =
    Win32API.new('user32', 'GetClientRect', 'lp', 'i')
  @@GetWindowRect =
    Win32API.new('user32', 'GetWindowRect', 'lp', 'i')
  @@GetWindowLong =
    Win32API.new('user32', 'GetWindowLong', 'li', 'l')
  @@GetSystemMetrics =
    Win32API.new('user32', 'GetSystemMetrics', 'i', 'i')
  @@SystemParametersInfo =
    Win32API.new('user32', 'SystemParametersInfo', 'iipi', 'i')
  #--------------------------------------------------------------------------
  # ● ウィンドウの情報
  #--------------------------------------------------------------------------
  unless $!
    GAME_TITLE  = NKF.nkf("-sxm0", load_data("Data/System.rvdata").game_title)
    GAME_HANDLE = @@FindWindow.call("RGSS Player", GAME_TITLE)
  end
  GAME_STYLE   = @@GetWindowLong.call(GAME_HANDLE, -16)
  GAME_EXSTYLE = @@GetWindowLong.call(GAME_HANDLE, -20)
  HDSK = @@GetDesktopWindow.call

module_function
  #--------------------------------------------------------------------------
  # ● GetWindowRect
  #--------------------------------------------------------------------------
  def GetWindowRect(hwnd)
    r = [0,0,0,0].pack('l4')
    if @@GetWindowRect.call(hwnd, r) != 0
      result = Rect.new(*r.unpack('l4'))
      result.width -= result.x
      result.height -= result.y
    else
      result = nil
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● GetClientRect
  #--------------------------------------------------------------------------
  def GetClientRect(hwnd)
    r = [0,0,0,0].pack('l4')
    if @@GetClientRect.call(hwnd, r) != 0
      result = Rect.new(*r.unpack('l4'))
      result.width -= result.x
      result.height -= result.y
    else
      result = nil
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● GetSystemMetrics
  #--------------------------------------------------------------------------
  def GetSystemMetrics(index)
    @@GetSystemMetrics.call(index)
  end
  #--------------------------------------------------------------------------
  # ● SetWindowPos
  #--------------------------------------------------------------------------
  def SetWindowPos(hwnd, x, y, width, height, z, flag)
    @@SetWindowPos.call(hwnd, z, x, y, width, height, flag) != 0
  end

  #--------------------------------------------------------------------------
  # ● ウィンドウのサイズを取得
  #--------------------------------------------------------------------------
  def GetGameWindowRect
    GetWindowRect(GAME_HANDLE)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウのクライアントサイズを取得
  #--------------------------------------------------------------------------
  def GetGameClientRect
    GetClientRect(GAME_HANDLE)
  end
  #--------------------------------------------------------------------------
  # ● デスクトップのサイズを取得
  #--------------------------------------------------------------------------
  def GetDesktopRect
    r = [0,0,0,0].pack('l4')
    if @@SystemParametersInfo.call(0x30, 0, r, 0) != 0
      result = Rect.new(*r.unpack('l4'))
      result.width -= result.x
      result.height -= result.y
    else
      result = nil
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウのフレームサイズを取得
  #--------------------------------------------------------------------------
  def GetFrameSize
    return [
      GetSystemMetrics(SM_CYCAPTION),   # タイトルバー
      GetSystemMetrics(SM_CXDLGFRAME),  # 左右フレーム
      GetSystemMetrics(SM_CYDLGFRAME)   # 上下フレーム
    ]
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの位置を中央へ
  #--------------------------------------------------------------------------
  def MoveGameWindowCenter
    dr = GetDesktopRect()
    wr = GetGameWindowRect()
    x = (dr.width - wr.width) / 2
    y = (dr.height - wr.height) / 2
    SetWindowPos(GAME_HANDLE, x, y, 0, 0, 0, SWP_NOSIZE|SWP_NOZORDER)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウのサイズを変更
  #--------------------------------------------------------------------------
  def SetGameWindowSize(width, height)
    # 各領域の取得
    dr = GetDesktopRect()         # Rect デスクトップ
    wr = GetGameWindowRect()      # Rect ウィンドウ
    cr = GetGameClientRect()      # Rect クライアント
    return false unless dr && wr && cr
    # フレームサイズの取得
    frame = GetFrameSize()
    ft = frame[0] + frame[2]      # タイトルバーの縦幅
    fl = frame[1]                 # 左フレームの横幅
    fs = frame[1] * 2             # 左右フレームの横幅
    fb = frame[2]                 # 下フレームの縦幅
    if width < 0 || height < 0
      w = dr.width + fs
      h = dr.height + ft + fb
      SetWindowPos(GAME_HANDLE, -fl, -ft, w, h, 0, SWP_NOZORDER)
    else
      w = width + fs
      h = height + ft + fb
      SetWindowPos(GAME_HANDLE, 0, 0, w, h, 0, SWP_NOMOVE|SWP_NOZORDER)
      MoveGameWindowCenter()
    end
  end
  #--------------------------------------------------------------------------
  # ○ フレーム更新
  #--------------------------------------------------------------------------
  def change_console_size
    case WLIB::GetGameClientRect().width
    when Graphics.width
      width, height = Graphics.width * 2  , Graphics.height * 2
    when Graphics.width * 2
      width, height = Graphics.width * 3  , Graphics.height * 3
    when Graphics.width * 3
      width, height = -1, -1
    else
      width, height = Graphics.width, Graphics.height
    end
    unless WLIB::SetGameWindowSize(width, height)
#~       Sound.play_buzzer
    end
    case WLIB::GetGameClientRect().width
    when Graphics.width;      return "S"
    when Graphics.width * 2;  return "M"
    when Graphics.width * 3;  return "L"
    else;                     return "F"
    end
  end
end

class Scene_Base
  #--------------------------------------------------------------------------
  # ○ フレーム更新
  #--------------------------------------------------------------------------
  alias _cao_update_wndsize update
  def update
    _cao_update_wndsize
    if Input.trigger?(Input::F5)
      case WLIB::GetGameClientRect().width
      when Graphics.width
        width, height = Graphics.width * 2, Graphics.height * 2
      when Graphics.width * 3
        width, height = Graphics.width * 3, Graphics.height * 3
      when Graphics.width * 3
        width, height = -1, -1
      else
        width, height = Graphics.width, Graphics.height
      end
      unless WLIB::SetGameWindowSize(width, height)
      end
    end
  end
end
