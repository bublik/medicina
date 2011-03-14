# 
# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc "Create documentation in UTF8"
task "utf8doc" do
  require 'rdoc/rdoc'
  rdoc = RDoc::RDoc.new
  options = Array.new
  #options << '-a'   # parses all methods (include protected, private)
  options << '-cUTF-8' # you may want to set the charset
  options << '-odoc/apputf8'
  options << '--line-numbers'
  options << '--inline-source'
  options << '-Thtml'
  options << 'doc/README_FOR_APP'
  Dir.glob('app/**/*.rb').each do |file|
    options << file
  end
  rdoc.document(options)
end
