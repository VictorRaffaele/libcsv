# frozen_string_literal: true

def process_csv(csv, selected_columns, row_filter_definitions)
  process_data(csv, selected_columns, row_filter_definitions)
end

def process_csv_file(csv_file_path, selected_columns, row_filter_definitions)
  csv = File.read(csv_file_path)
  process_data(csv, selected_columns, row_filter_definitions)
end

def process_data(csv, selected_columns, row_filter_definitions) # Will process the csv data and return only the selected columns
  result_csv = ''
  coluns_numbers = []
  split_csv_lines = csv.split("\n")
  csv_header = split_csv_lines[0]
  split_header = csv_header.split(',')
  select_columns = selected_columns.nil? || selected_columns == '' ? split_header : selected_columns.split(',')
  
  split_csv_lines.each do |line|
    if line == csv_header
      info = extract_header_info(split_header, select_columns)
      result_csv += info[:header_selected].join(',')
      coluns_numbers = info[:coluns_numbers]
    else
      match = []
      row_filter = row_filter_definitions.split("\n")
  
      row_filter.each { |row| match << regex(row) }
      line_selected = select_line(match, coluns_numbers, line.split(','))
      result_csv += "\n#{line_selected}" if line_selected != ''
    end
  end
  result_csv
end

def extract_header_info(split_header, select_columns) # Return the number of columns(will be need to relation index of column) based in headers filter
  info = { coluns_numbers: [], header_selected: [] }

  split_header.each_with_index do |column_name, index_c|
    select_columns.each do |column|
      next unless column == column_name

      info[:coluns_numbers] << index_c
      info[:header_selected] << column_name
    end
  end
  info
end

def regex(row_filter)
  pattern_equal = /[a-zA-Z0-9'"]+=[a-zA-Z0-9'"]+/
  pattern_bigger = /[a-zA-Z0-9'"]+>[a-zA-Z0-9'"]+/
  pattern_less = /[a-zA-Z0-9'"]+<[a-zA-Z0-9'"]+/

  if pattern_equal.match?(row_filter)
    filter = row_filter.split('=')
    { header: filter.first, operator: '=' , value: filter.last }
  elsif pattern_bigger.match?(row_filter)
    filter = row_filter.split('>')
    { header: filter.first, operator: '>', value: filter.last }
  elsif pattern_less.match?(row_filter)
    filter = row_filter.split('<')
    { header: filter.first, operator: '<', value: filter.last }
  end
end

def select_line(filter_groups, coluns_numbers, line) # Search for line which match they values with column numbers
  line_match = []
  line_selected = []

  filter_groups.each_with_index do |group, g_index|
    case g_index
    when 0
      column = coluns_numbers[0]
      line_match << match_value(line[column], group[:operator], group[:value])
    when 1
      column = coluns_numbers[1]
      line_match << match_value(line[column], group[:operator], group[:value])
    end
  end
  coluns_numbers.each { |column| line_selected << line[column] } if line_match.all? { |element| element == true }
  line_selected.join(',')
end

def match_value(line_value, operator, group_value) # Match values using strcmp
  result = false
  comparison = line_value <=> group_value

  case [comparison, operator]
  when [-1, '<']
    result = true
  when [0, '=']
    result = true
  when [1, '>']
    result = true
  end
  result
end
