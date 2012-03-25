require 'roo'

module Bilingual
  class Parser
     def load(xls_file, sheet_name)
       s = Excelx.new(xls_file.to_s, nil, :ignore)
       s.default_sheet = sheet_name
       puts s.info
       puts s.first_row
       #pp s

       s.first_row.upto(s.last_row) do |row|
         puts "#{row} #{s.cell(row, 'A')}"
       end

     end

  end
end
