A Pagination Helper Utility PORO

### Example

```
require './paginator'

total_items = 24
paginator = Paginator.new(total_items)

puts "Total Items: #{paginator.total_items}"
puts "Default Items Per Page: #{paginator.items_per_page}"
puts "\n"

(1..3).each do |page_num|
  puts "With current_page as #{page_num}"

  paginator.current_page = page_num

  puts "Item Offset: #{paginator.current_page_first_item_offset}"
  puts "Next Page: #{paginator.next_page}"
  puts "Last Page: #{paginator.last_page}"
  puts "\n"
end
```

#### Output of Example

```
Total Items: 24
Default Items Per Page: 10

With current_page as 1
Item Offset: 1
Next Page: 2
Last Page: 3

With current_page as 2
Item Offset: 11
Next Page: 3
Last Page: 3

With current_page as 3
Item Offset: 21
Next Page: no_next_page
Last Page: 3

```

Please refer the rspecs for more examples.
