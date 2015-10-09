class Paginator
  DEFAULT_ITEMS_PER_PAGE = 10
  NO_NEXT_PAGE = :no_next_page

  attr_reader :total_items, :items_per_page, :current_page, :last_page, :next_page
  # current page's first-item position in total_items sequence
  attr_reader :current_page_first_item_offset

  def initialize(total_items)
    raise_error_if_value_not_an_integer_or_less_than_or_equal_to_0(total_items, "total_items argument value")

    @total_items = total_items
    self.items_per_page = DEFAULT_ITEMS_PER_PAGE
    self.current_page = 1
    @last_page = calculate_last_page
  end

  def current_page=(page)
    raise_error_if_value_not_an_integer_or_less_than_or_equal_to_0(page)
    raise_error_if_invalid_current_page_value(page)
    @current_page = page
    @current_page_first_item_offset = calculate_current_page_first_item_offset
    @next_page = calculate_next_page
  end

  def items_per_page=(per_page)
    raise_error_if_value_not_an_integer_or_less_than_or_equal_to_0(per_page)
    @items_per_page = per_page
    @last_page = calculate_last_page
    @next_page = calculate_next_page
  end

  private

  def raise_error_if_value_not_an_integer_or_less_than_or_equal_to_0(value, error_message_prefix=:value)
    if !value.is_a?(Fixnum)
      raise "#{error_message_prefix} must be an integer"
    end

    if value <= 0
      raise "#{error_message_prefix} must be an integer greater than 0"
    end
  end

  def raise_error_if_invalid_current_page_value(value)
    if value > last_page
      raise "Invalid page number #{value}\. There are maximum #{last_page} pages available."
    end
  end

  def calculate_next_page
    # current_page is found nil when this object is initialized and
    # current_page= is invoked which inturn invokes this method
    return if current_page.nil?
    return NO_NEXT_PAGE if current_page == last_page
    current_page + 1
  end

  def calculate_last_page
    return 1 if total_items <= items_per_page

    result = (total_items / items_per_page) + 1
    result -= 1 if 0 == (total_items % items_per_page)
    result
  end

  def calculate_current_page_first_item_offset
    ( (current_page * items_per_page) - (items_per_page - 1) )
  end
end
