require_relative '../paginator'

describe Paginator do
  def remove_constant(constant_symbol)
    Object.send(:remove_const, constant_symbol)
  end

  context "instance methods" do
    subject { Paginator.new(25) }

    it { should respond_to(:total_items) }
    it { should respond_to(:items_per_page) }
    it { should respond_to(:current_page) }
    it { should respond_to(:next_page) }
    it { should respond_to(:last_page) }
    it { should respond_to(:current_page_first_item_offset) }
  end

  context "provides mutator for" do
    subject { Paginator.new(25) }

    it "items_per_page" do
      expect(subject).to respond_to(:items_per_page=)
    end

    it "current_page" do
      expect(subject).to respond_to(:current_page=)
    end
  end

  context "doesn't provides mutator for" do
    subject { Paginator.new(25) }

    it "total_items" do
      expect(subject).to_not respond_to(:total_items=)
    end

    it "next_page" do
      expect(subject).to_not respond_to(:next_page=)
    end

    it "last_page" do
      expect(subject).to_not respond_to(:last_page=)
    end

    it "current_page_first_item_offset" do
      expect(subject).to_not respond_to(:current_page_first_item_offset=)
    end
  end

  context ".new" do
    it "raises error when total_items argument value is found nil" do
      expect {
        Paginator.new(nil)
      }.to raise_error(/total_items argument value must be an integer/)
    end

    it "raises error when total_items argument value is not found to be an integer value" do
      expect {
        Paginator.new("12")
      }.to raise_error(/total_items argument value must be an integer/)
    end

    it "doesn't raise error when total_items argument value is found 0(zero)" do
      expect {
        Paginator.new(0)
      }.to_not raise_error
    end

    it "raises error when total_items argument value is found LESS THAN 0(zero)" do
      expect {
        Paginator.new(-1)
      }.to raise_error(/total_items argument value must be an integer greater than or equal to 0/)
    end
  end

  context "#items_per_page=" do
    let(:pagination_info) { Paginator.new(25) }

    it "raises error when value to be set is found nil" do
      expect {
        pagination_info.items_per_page = nil
      }.to raise_error(/value must be an integer/)
    end

    it "raises error when value to be set is not found to be an integer value" do
      expect {
        pagination_info.items_per_page = "1"
      }.to raise_error(/value must be an integer/)
    end

    it "raises error when value to be set is found 0(zero)" do
      expect {
        pagination_info.items_per_page = 0
      }.to raise_error(/value must be an integer greater than 0/)
    end

    it "raises error when value to be set is found LESS THAN 0(zero)" do
      expect {
        pagination_info.items_per_page = -1
      }.to raise_error(/value must be an integer greater than 0/)
    end

    it "correctly sets a accepted number" do
      pagination_info.items_per_page = 5
      expect(pagination_info.items_per_page).to eql(5)
    end
  end

  context "#current_page=" do
    let(:pagination_info) { Paginator.new(25) }

    it "raises error when value to be set is found nil" do
      expect {
        pagination_info.current_page = nil
      }.to raise_error(/value must be an integer/)
    end

    it "raises error when value to be set is not found to be an integer value" do
      expect {
        pagination_info.current_page = "1"
      }.to raise_error(/value must be an integer/)
    end

    it "raises error when value to be set is found 0(zero)" do
      expect {
        pagination_info.current_page = 0
      }.to raise_error(/value must be an integer greater than 0/)
    end

    it "raises error when value to be set is found LESS THAN 0(zero)" do
      expect {
        pagination_info.current_page = -1
      }.to raise_error(/value must be an integer greater than 0/)
    end

    it "correctly sets an accepted number" do
      pagination_info.current_page = 2
      expect(pagination_info.current_page).to eql(2)
    end
  end

  context "with items_per_page set to a DEFAULT VALUE 10" do
    let(:default_items_per_page) { 10 }

    before do
      # Instead of stubbing first Paginator constant, if just stubbing
      # the constant using following code
      #   stub_const("Paginator::DEFAULT_ITEMS_PER_PAGE", default_items_per_page)
      # and attaching a tag to this example and running the tagged example using --tag=<TAG_NAME>
      # switch the spec example fails with error:
      #   undefined method `new' for Paginator:Module
      # Refer http://www.relishapp.com/rspec/rspec-mocks/v/3-3/docs/mutating-constants/stub-undefined-constant#stub-nested-constant
      # why Paginator was considered as Module(instead of Class).

      stub_const("Paginator", Paginator)
      stub_const("Paginator::DEFAULT_ITEMS_PER_PAGE", default_items_per_page)
    end

    context "and there are 25 total items available" do
      let(:total_items) { 25 }
      let(:pagination_info) { Paginator.new(total_items) }

      context ".new" do
        it "sets total_items to 25" do
          expect(pagination_info.total_items).to_not be_nil
          expect(pagination_info.total_items).to eql(total_items)
        end

        it "sets items_per_page to 10" do
          expect(pagination_info.items_per_page).to_not be_nil
          expect(pagination_info.items_per_page).to eql(Paginator::DEFAULT_ITEMS_PER_PAGE)
        end

        it "sets last_page to 3" do
          expect(pagination_info.last_page).to_not be_nil
          expect(pagination_info.last_page).to eql(3)
        end

        it "sets current_page to 1" do
          expect(pagination_info.current_page).to_not be_nil
          expect(pagination_info.current_page).to eql(1)
        end

        it "sets current_page_first_item_offset to 1" do
          expect(pagination_info.current_page_first_item_offset).to_not be_nil
          expect(pagination_info.current_page_first_item_offset).to eql(1)
        end

        it "sets next_page to 2" do
          expect(pagination_info.next_page).to_not be_nil
          expect(pagination_info.next_page).to eql(2)
        end
      end

      context "current_page" do
        context "when set to 4" do
          let(:expected_last_page) { 3 }
          let(:current_page_to_be_set) { 4 }

          before do
            expect(pagination_info.last_page).to eql(expected_last_page)
          end

          it "raises invalid page number error" do
            expect {
              pagination_info.current_page = current_page_to_be_set
            }.to raise_error(/Invalid page number \d+\. There are maximum \d+ pages/)
          end
        end
      end

      context "items_per_page" do
        context "when set to 7" do
          let(:expected_last_page) { 4 }
          let(:custom_items_per_page) { 7 }

          before do
            pagination_info.items_per_page = custom_items_per_page
          end

          it "resets the last_page value to 4" do
            expect(pagination_info.last_page).to eql(expected_last_page)
          end
        end
      end
    end

    context "and there are 3 total items available" do
      let(:total_items) { 3 }
      let(:pagination_info) { Paginator.new(total_items) }

      before do
        expect(pagination_info.items_per_page).to eql(Paginator::DEFAULT_ITEMS_PER_PAGE)
        expect(pagination_info.last_page).to eql(1)
        expect(pagination_info.current_page).to eql(1)
        expect(pagination_info.next_page).to eql(:no_next_page)
      end

      context "items_per_page" do
        context "when set to 2" do
          let(:expected_next_page) { 2 }
          let(:expected_last_page) { 2 }
          let(:custom_items_per_page) { 2 }

          before do
            pagination_info.items_per_page = custom_items_per_page
          end

          it "resets the last_page value to 2" do
            expect(pagination_info.last_page).to eql(expected_last_page)
          end

          it "resets the next_page value to 2" do
            expect(pagination_info.next_page).to eql(expected_next_page)
          end
        end
      end
    end

    context "and there are no items available" do
      let(:total_items) { 0 }
      let(:pagination_info) { Paginator.new(total_items) }

      it "sets items_per_page value to 10" do
        expect(pagination_info.items_per_page).to eql(Paginator::DEFAULT_ITEMS_PER_PAGE)
      end

      it "sets last_page value to 1" do
        expect(pagination_info.last_page).to eql(1)
      end

      it "sets current_page value to 1" do
        expect(pagination_info.current_page).to eql(1)
      end

      it "sets next_page value to :no_next_page" do
        expect(pagination_info.next_page).to eql(:no_next_page)
      end
    end

    context "#last_page" do
      it "is set to an expected value based on total items available" do
        PaginationDataStruct = Struct.new(:total_items, :expected_last_page)

        pagination_data_arr = [
          PaginationDataStruct.new(9, 1),
          PaginationDataStruct.new(10, 1),
          PaginationDataStruct.new(11, 2),
          PaginationDataStruct.new(20, 2),
          PaginationDataStruct.new(21, 3),
          PaginationDataStruct.new(35, 4),
        ]

        pagination_data_arr.each do |pagination_data|
          pagination_info = Paginator.new(pagination_data.total_items)
          expect(pagination_info.last_page).to eql(pagination_data.expected_last_page)
        end

        remove_constant(:PaginationDataStruct)
      end
    end

    context "#next_page" do
      it "is set to an expected value based on total_items, current_page and last_page values" do
        PaginationDataStruct = Struct.new(:total_items, :expected_last_page, :current_page, :expected_next_page)

        pagination_data_arr = [
          PaginationDataStruct.new(11, 2, 1, 2),
          PaginationDataStruct.new(10, 1, 1, :no_next_page),
          PaginationDataStruct.new(50, 5, 3, 4)
        ]

        pagination_data_arr.each do |pagination_data|
          pagination_info = Paginator.new(pagination_data.total_items)
          expect(pagination_info.last_page).to eql(pagination_data.expected_last_page)
          pagination_info.current_page = pagination_data.current_page
          expect(pagination_info.next_page).to eql(pagination_data.expected_next_page)
        end

        remove_constant(:PaginationDataStruct)
      end
    end

    context "#current_page_first_item_offset" do
      it "is set to an expected value based on total_items and current_page values" do
        PaginationDataStruct = Struct.new(:total_items, :current_page, :expected_current_page_first_item_offset)

        pagination_data_arr = [
          PaginationDataStruct.new(9, 1, 1),
          PaginationDataStruct.new(11, 1, 1),
          PaginationDataStruct.new(11, 2, 11),
          PaginationDataStruct.new(25, 1, 1),
          PaginationDataStruct.new(25, 2, 11),
          PaginationDataStruct.new(25, 3, 21)
        ]

        pagination_data_arr.each do |pagination_data|
          pagination_info = Paginator.new(pagination_data.total_items)
          pagination_info.current_page = pagination_data.current_page
          expect(pagination_info.current_page_first_item_offset).to eql(pagination_data.expected_current_page_first_item_offset)
        end

        remove_constant(:PaginationDataStruct)
      end
    end
  end

  context "with items_per_page changed from default 10 to a CUSTOM VALUE" do
    context "#last_page" do
      it "is set to an expected value based on total items available" do
        PaginationDataStruct = Struct.new(:total_items, :items_per_page, :expected_last_page)

        pagination_data_arr = [
          PaginationDataStruct.new(9, 10, 1),
          PaginationDataStruct.new(10, 10, 1),
          PaginationDataStruct.new(11, 10, 2),
          PaginationDataStruct.new(18, 5, 4),
          PaginationDataStruct.new(35, 20, 2),
          PaginationDataStruct.new(5, 2, 3)
        ]

        pagination_data_arr.each do |pagination_data|
          pagination_info = Paginator.new(pagination_data.total_items)
          pagination_info.items_per_page = pagination_data.items_per_page
          expect(pagination_info.last_page).to eql(pagination_data.expected_last_page)
        end

        remove_constant(:PaginationDataStruct)
      end
    end

    context "#next_page" do
      it "is set to an expected value based on total_items, current_page and last_page values" do
        PaginationDataStruct = Struct.new(:total_items, :items_per_page, :expected_last_page, :current_page, :expected_next_page)

        pagination_data_arr = [
          PaginationDataStruct.new(11, 4, 3, 1, 2),
          PaginationDataStruct.new(18, 4, 5, 5, :no_next_page),
          PaginationDataStruct.new(12, 4, 3, 2, 3),
        ]

        pagination_data_arr.each do |pagination_data|
          pagination_info = Paginator.new(pagination_data.total_items)
          pagination_info.items_per_page = pagination_data.items_per_page
          expect(pagination_info.last_page).to eql(pagination_data.expected_last_page)
          pagination_info.current_page = pagination_data.current_page
          expect(pagination_info.next_page).to eql(pagination_data.expected_next_page)
        end

        remove_constant(:PaginationDataStruct)
      end
    end

    context "#current_page_first_item_offset" do
      it "is set to an expected value based on total_items and current_page values" do
        PaginationDataStruct = Struct.new(:total_items, :items_per_page, :current_page, :expected_current_page_first_item_offset)

        pagination_data_arr = [
          PaginationDataStruct.new(10, 5, 1, 1),
          PaginationDataStruct.new(10, 5, 2, 6),
          PaginationDataStruct.new(18, 7, 1, 1),
          PaginationDataStruct.new(18, 7, 2, 8),
          PaginationDataStruct.new(18, 7, 3, 15),
        ]

        pagination_data_arr.each do |pagination_data|
          pagination_info = Paginator.new(pagination_data.total_items)
          pagination_info.items_per_page = pagination_data.items_per_page
          pagination_info.current_page = pagination_data.current_page
          expect(pagination_info.current_page_first_item_offset).to eql(pagination_data.expected_current_page_first_item_offset)
        end

        remove_constant(:PaginationDataStruct)
      end
    end
  end
end
