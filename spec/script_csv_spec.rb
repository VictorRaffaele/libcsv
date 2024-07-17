# frozen_string_literal: true

require 'rspec'
require_relative '../script_csv'

RSpec.describe 'script_csv' do
  describe '#process_csv' do
    let(:csv) { "header1,header2,header3\n1,2,3\n4,5,6\n7,8,9" }
    let(:selected_columns) { 'header1,header3' }
    let(:row_filter_definitions) { "header1>1\nheader3<8" }

    it 'processes the CSV correctly' do       
        result = process_csv(csv, selected_columns, row_filter_definitions)
        expect(result).to eq("header1,header3\n4,6")
    end
  end

  describe '#process_csv_file' do
    let(:csv_path) { 'data.csv' }
    let(:selected_columns) { 'col1,col4' }
    let(:row_filter_definitions) { "col1>l2c1\ncol4>l2c4" }

    it 'processes the CSV correctly' do
      result = process_csv_file(csv_path, selected_columns, row_filter_definitions)
      expect(result).to eq("col1,col4\nl3c1,l3c4")
    end
  end

  describe '#process_data' do
    let(:csv) { "header1,header2,header3\n1,2,3\n4,5,6\n7,8,9" }
    let(:selected_columns) { 'header1,header3' }
    let(:row_filter_definitions) { "header1>1\nheader3<8" }

    it 'processes the data' do       
      result = process_data(csv, selected_columns, row_filter_definitions)
      expect(result).to eq("header1,header3\n4,6")
    end
  end

  describe '#extract_header_info' do
    let(:split_header) { ["header1", "header2", "header3"] }
    let(:select_columns) { ["header1", "header3"] }

    it 'divides the header and get their index' do       
        result = extract_header_info(split_header, select_columns)
        expected_result = { coluns_numbers: [0, 2], header_selected: ["header1", "header3"] }
        expect(result).to eq(expected_result)
      end
  end

  describe '#regex' do
    context 'filter =' do
      let(:row_filter) { 'header1=1' }

      it 'divides header, operator and value' do
        result = regex(row_filter)
        expected_result = { header: 'header1', operator: '=' , value: '1' }
        expect(result).to eq(expected_result)
      end
    end

    context 'filter >' do
      let(:row_filter) { 'header1>1' }

      it 'separe header, operator and value' do
        result = regex(row_filter)
        expected_result = { header: 'header1', operator: '>' , value: '1' }
        expect(result).to eq(expected_result)
      end
    end

    context 'filter <' do
      let(:row_filter) { 'header1<1' }

      it 'separe header, operator and value' do
        result = regex(row_filter)
        expected_result = { header: 'header1', operator: '<' , value: '1' }
        expect(result).to eq(expected_result)
      end
    end
  end

  describe '#select_line' do
    let(:filter_groups) do 
      [
        { header: 'header1', operator: '>', value: '1' },
        { header: 'header3', operator: '<', value: '8' }
      ]
    end
    let(:coluns_numbers) { [0, 2] }
    let(:line) { ['4', '5', '6'] }

    it 'returns the line values after match with filters' do
      result = select_line(filter_groups, coluns_numbers, line)
      expected_result = '4,6'
      expect(result).to eq(expected_result)
    end
  end

  describe '#match_value' do

    context 'when comparison value isnt equal operator' do
      let(:line_value) { 1 }
      let(:operator) { '>' }
      let(:group_value) { 1 }

      it 'returns false' do
        result = match_value(line_value, operator, group_value)
        expected_result = false
        expect(result).to eq(expected_result)
      end
    end

    context 'when comparison value is equal operator' do
        let(:line_value) { 2 }
        let(:operator) { '>' }
        let(:group_value) { 1 }
  
        it 'returns true' do
          result = match_value(line_value, operator, group_value)
          expected_result = true
          expect(result).to eq(expected_result)
        end
      end
  end
end
