Dir.children("../mjhgx/").select{|f| f.match(/txt$/)}.each do |file|
  system("mv ../mjhgx/#{file} ./lua/#{file.gsub(/\.txt$/, "")}")
end