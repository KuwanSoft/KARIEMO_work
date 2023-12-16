module RequireVXConfig
  #
  # -Configure options here-
  #
  # What they do:
  #
  #   :make_default_load_paths
  #     Initializes the $LOAD_PATH variable to it's default values (not the
  #     paths that are used to require C files becauset hey will not work).
  #     If this is done the Ruby standard library can be copy/pasted
  #     to the root project folder and require/load will work.
  #     To do that, copy the folder named 'lib' in your Ruby install folder
  #     and paste it to the project root folder (where Game.exe is located)
  #
  #   :extra_load_paths
  #     If you assign a path to this array it will be added to the load path.
  #     So if you for example want to be able to require files from C:\rmvx
  #     you would type the following: :extra_load_paths => ["c:/rmvx"]
  #     (note: use forward slash, and not back slash)
  #     More paths can be added by separating them with commas. For example,
  #     :extra_load_paths => ["c:/rmvx", "c:/scripts/rgss"]
  #

  OPTIONS = {
    :make_default_load_paths  => true,
    :extra_load_paths         => []
  }

  # -End configuration-

  if OPTIONS[:make_default_load_paths]
    lib_dir = File.join(Dir.getwd, "lib")
    default = [lib_dir + "/ruby/site_ruby/1.8", lib_dir + "/ruby/1.8", "."]
    default.each { |path| $LOAD_PATH << path }
  end

  extra = OPTIONS[:extra_load_paths]
  extra.each { |path| $LOAD_PATH << path } unless extra.empty?

  $LOADED_FEATURES ||= []
end

class Object
  alias_method :method_missing_original, :method_missing

  def method_missing(m, *args, &block)
    case m
    when :require
      vx_require(*args, &block)
    when :load
      vx_load(*args, &block)
    else
      method_missing_original(m, *args, &block)
    end
  end

  private

  def vx_require(path)
    vx_base(path) do |file|
      return false if $LOADED_FEATURES.include?(file)
      eval(File.read(file))
      $LOADED_FEATURES << file
      true
    end
  end

  def vx_load(path)
    vx_base(path) do |file|
      eval(File.read(file))
      true
    end
  end

  # Helper methods

  def vx_base(path, &load_block)
    result = vx_load_if_valid(path, &load_block)
    return result unless result.nil?

    $LOAD_PATH.each do |load_path|
      f = File.join(load_path, path)
      result = vx_load_if_valid(f, &load_block)
      return result unless result.nil?
    end

    raise LoadError, "cannot load such file -- #{path}"
  end

  def vx_load_if_valid(path, &load_block)
    rbfied_path = path + ".rb"
    if File.file?(path)
      load_block.call(path)
    elsif File.file?(rbfied_path)
      load_block.call(rbfied_path)
    end
  end
end
