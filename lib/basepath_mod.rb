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
  end

  def filter
    doc = @mode == :xml ? Hpricot.XML(@str) : Hpricot(@str)
    base_path = ::Webby.site.base
    attr_rgxp = %r/\[@(\w+)\]$/o
    sub_rgxp = %r/\A(?=\/)/o

    ::Webby.site.xpaths.each do |xpath|
      @attr_name = nil

      doc.search(xpath).each do |element|
        @attr_name ||= attr_rgxp.match(xpath)[1]
        a = element.get_attribute(@attr_name)
        if @attr_name == "href" then
          element.set_attribute(@attr_name, a) if a.sub!(sub_rgxp, base_path)
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
