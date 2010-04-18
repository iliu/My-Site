
module LayoutHelper

  def layouthelper_get_menu_links(curr_page,result)
    if (curr_page == result.title) then
      linkval = "<li id=\"current\">";
    else
      linkval = "<li>";
    end
    
    linkval += "<a href=\"";
    
    if ( result.url == "/" ) then
       linkval += "/index.html";
    else
       linkval += result.url;
    end
    
    linkval += "\">" + result.title + "</a></li>";
  end

end  # module LayoutHelper

Webby::Helpers.register(LayoutHelper)

# EOF
