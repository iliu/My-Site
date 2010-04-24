require 'hpricot'

module Webby
class Renderer
  attr_reader :page
end

module Filters

# To use: add relpath to the end of the list of filters in the layout. It won't
# work in the content file itself.
class BasePath_Mod
  def initialize( str, mode, path )
    @str = str
    @mode = mode.downcase.to_sym
    dir = File.dirname(path)
    depth = 0
    while (parent = File.dirname(dir)) != dir
      dir = parent
      depth += 1
    end
    depth -= 1 # because of the 'content/' prefix
    @prefix = "../" * depth
  end

  def filter
    doc = @mode == :xml ? Hpricot.XML(@str) : Hpricot(@str)
    base_path = ::Webby.site.base
    attr_rgxp = %r/\[@(\w+)\]$/o
    sub_rgxp = %r/\A(?=\/)/o
    sub_rgxp_relpath = %r/\A\//o # <-- note this rgxp _consumes_ the "/"

    ::Webby.site.xpaths.each do |xpath|
      @attr_name = nil
      doc.search(xpath).each do |element|
        @attr_name ||= attr_rgxp.match(xpath)[1]
        a = element.get_attribute(@attr_name)
        if (@attr_name == "href") && !(xpath.include? 'link') then
          element.set_attribute(@attr_name, a) if a.sub!(sub_rgxp, base_path)
        else
          element.set_attribute(@attr_name, a) if a.sub!(sub_rgxp_relpath, @prefix)
          #This is my fix to relpath, where the index.html page would contain nothing, which will link to current page
          if a == "" then
            element.set_attribute(@attr_name, "index.html") 
          end
        end
      end
    end

    doc.to_html
  end
end

register :basepath_mod do |input, cursor|
  BasePath_Mod.new(input, cursor.page.extension, cursor.renderer.page.path).filter
end

end  # module Filters
end  # module Webby
