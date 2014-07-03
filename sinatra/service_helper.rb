module Sinatra
  module ServiceHelper
    def my_upcase(txt)
      "HEY: #{txt.upcase}"
    end
  end
  helpers ServiceHelper
end

