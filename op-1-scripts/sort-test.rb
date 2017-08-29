
list01    = %w( 01_w 02_w 03_w 04_b 05_b )
control01 = %w( 01_w 04_b 02_w 05_b 03_w )

# working
list02    = %w( 01_w 02_w 03_w 04_w 05_b 06_b 07_b )
control02 = %w( 01_w 05_b 02_w 06_b 03_w 07_b 04_w )


def my_sort( list )

  if list.size < 7
    half = list.size / 2
    puts half
    puts [ 0 .. half ]
    [0..half].map{ |index|
      [list[index], list[half + index]]
    }
  else
  part01 = list.take(7)
  rest01 = list.drop(7)
  white = part01.take(4)
  black = part01.drop(4)
  [ white[0], black[0], white[1], black[1], white[2], black[2], white[3]]
  end
end


def output(head, list, control)
  sorted_list = my_sort(list)
  puts "----------"
  puts  head
  puts "----------"
  print "original : "
  print list
  puts
  print "sorted   : "
  print sorted_list
  puts
  print "controll : "
  print control
  puts
  puts
  print "are they equal ? -> "
  print sorted_list == control
  puts
  puts
end


output("list02", list02, control02)
