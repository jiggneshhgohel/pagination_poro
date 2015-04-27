require_relative '../paginator'

describe Paginator do
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

    it "raises error when total_items argument value is found 0(zero)" do
      expect {
        Paginator.new(0)
      }.to raise_error(/total_items argument value must be an integer greater than 0/)
    end

    it "raises error when total_items argument value is found LESS THAN 0(zero)" do
      expect {
        Paginator.new(-1)
      }.to raise_error(/total_items argument value must be an integer greater than 0/)
    end

    it "sets total_items attribute value to given total_items" do
      paginator =  Paginator.new(25)
      expect(paginator.total_items).to_not be_nil
      expect(paginator.total_items).to eql(25)
    end

    it "sets items_per_page to a default value #{Paginator::DEFAULT_ITEMS_PER_PAGE}" do
      paginator =  Paginator.new(25)
      expect(paginator.items_per_page).to_not be_nil
      expect(paginator.items_per_page).to eql(Paginator::DEFAULT_ITEMS_PER_PAGE)
    end

    it "sets current_page to a default value 1" do
      paginator =  Paginator.new(1)
      expect(paginator.current_page).to_not be_nil
      expect(paginator.current_page).to eql(1)
    end

    it "sets current_page_first_item_offset to a default value 1" do
      paginator =  Paginator.new(1)
      expect(paginator.current_page_first_item_offset).to_not be_nil
      expect(paginator.current_page_first_item_offset).to eql(1)
    end

    it "sets last_page attribute to an integer value calculated using total_items and items_per_page values" do
      paginator =  Paginator.new(25)
      expect(paginator.last_page).to_not be_nil
      expect(paginator.last_page).to be_kind_of(Fixnum)
    end

    it "sets next_page attribute to an integer value calculated using current_page and last_page values" do
      paginator =  Paginator.new(25)
      expect(paginator.next_page).to_not be_nil
      expect(paginator.next_page).to be_kind_of(Fixnum)
    end
  end

  context "#current_page=" do
    let(:paginator) { Paginator.new(25) }

    it "raises error when value to be set is found nil" do
      expect {
        paginator.current_page = nil
      }.to raise_error(/value must be an integer/)
    end

    it "raises error when value to be set is not found to be an integer value" do
      expect {
        paginator.current_page = "1"
      }.to raise_error(/value must be an integer/)
    end

    it "raises error when value to be set is found 0(zero)" do
      expect {
        paginator.current_page = 0
      }.to raise_error(/value must be an integer greater than 0/)
    end

    it "raises error when value to be set is found LESS THAN 0(zero)" do
      expect {
        paginator.current_page = -1
      }.to raise_error(/value must be an integer greater than 0/)
    end

    it "correctly sets an accepted number" do
      paginator.current_page = 2
      expect(paginator.current_page).to eql(2)
    end

    it "sets next_page attribute to an integer value calculated using current_page and last_page values" do
      paginator.current_page = 2
      expect(paginator.next_page).to_not be_nil
      expect(paginator.next_page).to be_kind_of(Fixnum)
    end

    context "when value to be set is found to be greater than last_page value" do
      let(:total_items) { 25 }
      let(:expected_last_page) { 3 } # considering default items_per_page
      let(:current_page_to_be_set) { 4 }

      let(:paginator) { Paginator.new(total_items) }

      before do
        expect(paginator.last_page).to eql(expected_last_page)
      end

      it "raises invalid page number error" do
        expect {
          paginator.current_page = current_page_to_be_set
        }.to raise_error(/Invalid page number \d+\. There are maximum \d+ pages/)
      end
    end

    it "sets current_page_first_item_offset attribute to an integer value calculated using current_page and items_per_page values" do
      paginator.current_page = 2
      expect(paginator.current_page_first_item_offset).to_not be_nil
      expect(paginator.current_page_first_item_offset).to be_kind_of(Fixnum)
    end
  end

  context "#items_per_page=" do
    let(:paginator) { Paginator.new(25) }

    it "raises error when value to be set is found nil" do
      expect {
        paginator.items_per_page = nil
      }.to raise_error(/value must be an integer/)
    end

    it "raises error when value to be set is not found to be an integer value" do
      expect {
        paginator.items_per_page = "1"
      }.to raise_error(/value must be an integer/)
    end

    it "raises error when value to be set is found 0(zero)" do
      expect {
        paginator.items_per_page = 0
      }.to raise_error(/value must be an integer greater than 0/)
    end

    it "raises error when value to be set is found LESS THAN 0(zero)" do
      expect {
        paginator.items_per_page = -1
      }.to raise_error(/value must be an integer greater than 0/)
    end

    it "correctly sets a accepted number" do
      paginator.items_per_page = 5
      expect(paginator.items_per_page).to eql(5)
    end

    it "re-calculates the last_page value" do
      pinfo = Paginator.new(8)
      expect(pinfo.last_page).to eql(1)

      pinfo.items_per_page = 5

      expect(pinfo.items_per_page).to eql(5)
      expect(pinfo.last_page).to eql(2)
    end
  end

  context "#last_page" do
    context "when total_items=9 and items_per_page=<DEFAULT SET TO #{Paginator::DEFAULT_ITEMS_PER_PAGE}>" do
      let(:total_items) { 9 }

      let(:paginator) { Paginator.new(total_items) }

      it "returns 1" do
        expect(paginator.last_page).to eql(1)
      end
    end

    context "when total_items=10 and items_per_page=<DEFAULT SET TO #{Paginator::DEFAULT_ITEMS_PER_PAGE}>" do
      let(:total_items) { 10 }

      let(:paginator) { Paginator.new(total_items) }

      it "returns 1" do
        expect(paginator.last_page).to eql(1)
      end
    end

    context "when total_items=11 and items_per_page=<DEFAULT SET TO #{Paginator::DEFAULT_ITEMS_PER_PAGE}>" do
      let(:total_items) { 11 }

      let(:paginator) { Paginator.new(total_items) }

      it "returns 2" do
        expect(paginator.last_page).to eql(2)
      end
    end

    context "when total_items=20 and items_per_page=<DEFAULT SET TO #{Paginator::DEFAULT_ITEMS_PER_PAGE}>" do
      let(:total_items) { 20 }

      let(:paginator) { Paginator.new(total_items) }

      it "returns 2" do
        expect(paginator.last_page).to eql(2)
      end
    end

    context "when total_items=21 and items_per_page=<DEFAULT SET TO #{Paginator::DEFAULT_ITEMS_PER_PAGE}>" do
      let(:total_items) { 21 }

      let(:paginator) { Paginator.new(total_items) }

      it "returns 3" do
        expect(paginator.last_page).to eql(3)
      end
    end

    context "when total_items=35 and items_per_page=<DEFAULT SET TO #{Paginator::DEFAULT_ITEMS_PER_PAGE}>" do
      let(:total_items) { 35 }

      let(:paginator) { Paginator.new(total_items) }

      it "returns 4" do
        expect(paginator.last_page).to eql(4)
      end
    end

    context "when total_items=4 and items_per_page=5" do
      let(:total_items) { 4 }
      let(:items_per_page) { 5 }

      let(:paginator) { Paginator.new(total_items) }

      before do
        paginator.items_per_page = items_per_page
      end

      it "returns 1" do
        expect(paginator.last_page).to eql(1)
      end
    end

    context "when total_items=6 and items_per_page=5" do
      let(:total_items) { 6 }
      let(:items_per_page) { 5 }

      let(:paginator) { Paginator.new(total_items) }

      before do
        paginator.items_per_page = items_per_page
      end

      it "returns 2" do
        expect(paginator.last_page).to eql(2)
      end
    end

    context "when total_items=27 and items_per_page=5" do
      let(:total_items) { 27 }
      let(:items_per_page) { 5 }

      let(:paginator) { Paginator.new(total_items) }

      before do
        paginator.items_per_page = items_per_page
      end

      it "returns 6" do
        expect(paginator.last_page).to eql(6)
      end
    end
  end

  context "#next_page" do
    context "with default items_per_page=10" do
      context "when last_page=2 and current_page=1" do
        let(:total_items) { 11 }
        let(:expected_last_page) { 2 }
        let(:current_page) { 1 }

        let(:paginator) { Paginator.new(total_items) }

        before do
          expect(paginator.last_page).to eql(expected_last_page)
          paginator.current_page = current_page
        end

        it "returns 2" do
          expect(paginator.next_page).to eql(2)
        end
      end

      context "when last_page=1 and current_page=1" do
        let(:total_items) { 10 }
        let(:expected_last_page) { 1 }
        let(:current_page) { 1 }

        let(:paginator) { Paginator.new(total_items) }

        before do
          expect(paginator.last_page).to eql(expected_last_page)
          paginator.current_page = current_page
        end

        it "returns a symbol :#{Paginator::NO_NEXT_PAGE}" do
          expect(paginator.next_page).to eql(Paginator::NO_NEXT_PAGE)
        end
      end

      context "when last_page=5 and current_page=3" do
        let(:total_items) { 50 }
        let(:expected_last_page) { 5 }
        let(:current_page) { 3 }

        let(:paginator) { Paginator.new(total_items) }

        before do
          expect(paginator.last_page).to eql(expected_last_page)
          paginator.current_page = current_page
        end

        it "returns 4" do
          expect(paginator.next_page).to eql(4)
        end
      end
    end

    context "with custom items_per_page, say items_per_page=4" do
      let(:items_per_page) { 4 }

      context "when last_page=3 and current_page=1" do
        let(:total_items) { 11 }
        let(:expected_last_page) { 3 }
        let(:current_page) { 1 }

        let(:paginator) { Paginator.new(total_items) }

        before do
          paginator.items_per_page = items_per_page
          expect(paginator.last_page).to eql(expected_last_page)
          paginator.current_page = current_page
        end

        it "returns 2" do
          expect(paginator.next_page).to eql(2)
        end
      end

      context "when last_page=5 and current_page=5" do
        let(:total_items) { 18 }
        let(:expected_last_page) { 5 }
        let(:current_page) { 5 }

        let(:paginator) { Paginator.new(total_items) }

        before do
          paginator.items_per_page = items_per_page
          expect(paginator.last_page).to eql(expected_last_page)
          paginator.current_page = current_page
        end

        it "returns a symbol :#{Paginator::NO_NEXT_PAGE}" do
          expect(paginator.next_page).to eql(Paginator::NO_NEXT_PAGE)
        end
      end

      context "when last_page=3 and current_page=2" do
        let(:total_items) { 12 }
        let(:expected_last_page) { 3 }
        let(:current_page) { 2 }

        let(:paginator) { Paginator.new(total_items) }

        before do
          paginator.items_per_page = items_per_page
          expect(paginator.last_page).to eql(expected_last_page)
          paginator.current_page = current_page
        end

        it "returns 3" do
          expect(paginator.next_page).to eql(3)
        end
      end
    end
  end

  context "#current_page_first_item_offset" do
    context "when total_items=9, items_per_page=<DEFAULT SET TO #{Paginator::DEFAULT_ITEMS_PER_PAGE}>" do
      let(:total_items) { 9 }
      let(:paginator) { Paginator.new(total_items) }

      context "and current_page=1"do
        before do
          paginator.current_page = 1
        end

        it "returns 1" do
          expect(paginator.current_page_first_item_offset).to eql(1)
        end
      end
    end

    context "when total_items=11, items_per_page=<DEFAULT SET TO #{Paginator::DEFAULT_ITEMS_PER_PAGE}>" do
      let(:total_items) { 11 }

      let(:paginator) { Paginator.new(total_items) }

      context "and current_page=1"do
        before do
          paginator.current_page = 1
        end

        it "returns 1" do
          expect(paginator.current_page_first_item_offset).to eql(1)
        end
      end

      context "and current_page=2"do
        before do
          paginator.current_page = 2
        end

        it "returns 11" do
          expect(paginator.current_page_first_item_offset).to eql(11)
        end
      end
    end

    context "when total_items=25, items_per_page=<DEFAULT SET TO #{Paginator::DEFAULT_ITEMS_PER_PAGE}>" do
      let(:total_items) { 25 }

      let(:paginator) { Paginator.new(total_items) }

      context "and current_page=1"do
        before do
          paginator.current_page = 1
        end

        it "returns 1" do
          expect(paginator.current_page_first_item_offset).to eql(1)
        end
      end

      context "and current_page=2"do
        before do
          paginator.current_page = 2
        end

        it "returns 11" do
          expect(paginator.current_page_first_item_offset).to eql(11)
        end
      end

      context "and current_page=3"do
        before do
          paginator.current_page = 3
        end

        it "returns 21" do
          expect(paginator.current_page_first_item_offset).to eql(21)
        end
      end
    end

    context "when total_items=10, items_per_page=5" do
      let(:total_items) { 10 }
      let(:items_per_page) { 5 }

      let(:paginator) { Paginator.new(total_items) }

      before do
        paginator.items_per_page = items_per_page
      end

      context "and current_page=1"do
        before do
          paginator.current_page = 1
        end

        it "returns 1" do
          expect(paginator.current_page_first_item_offset).to eql(1)
        end
      end

      context "and current_page=2"do
        before do
          paginator.current_page = 2
        end

        it "returns 6" do
          expect(paginator.current_page_first_item_offset).to eql(6)
        end
      end
    end

    context "when total_items=18, items_per_page=7" do
      let(:total_items) { 18 }
      let(:items_per_page) { 7 }

      let(:paginator) { Paginator.new(total_items) }

      before do
        paginator.items_per_page = items_per_page
      end

      context "and current_page=1"do
        before do
          paginator.current_page = 1
        end

        it "returns 1" do
          expect(paginator.current_page_first_item_offset).to eql(1)
        end
      end

      context "and current_page=2"do
        before do
          paginator.current_page = 2
        end

        it "returns 8" do
          expect(paginator.current_page_first_item_offset).to eql(8)
        end
      end

      context "and current_page=3"do
        before do
          paginator.current_page = 3
        end

        it "returns 15" do
          expect(paginator.current_page_first_item_offset).to eql(15)
        end
      end
    end
  end
end
