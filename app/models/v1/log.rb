 require 'simple_record'

 class Log < SimpleRecord::Base
    has_strings :name
 end