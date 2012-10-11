outputs = `/usr/local/bin/todo.sh -p list|grep "([ABCD])" |sort -s -t \+ -d -k 2`
proj = outputs.select{|t| /.*\+.*/ =~t}
notproj = outputs.select{|t| !(/.*\+.*/=~t)}

p=''
proj.each_with_index.each{|t, i|
 if /.*(\+.*)/ =~ t
    if $1 != p
      if i!=0
        puts ""
      end
    end
    p = $1
  else
    if p != ''
      puts ""
      p = ''
    end
  end
  puts t
}
puts ""
notproj=notproj.sort{|t, s|
  /\d\d \(([ABCD])\).*/ =~t
  prit = $1
  /\d\d \(([ABCD])\).*/ =~s
  pris = $1
#  puts "#{prit},  #{pris}"
  prit<=>pris
}

puts notproj
