# frozen_string_literal: true

require_relative "qr_emv/version"

module QrEmv
  class Error < StandardError; end

  class Parser
    attr_accessor :raw_string, :root, :merchant_info

    def initialize(raw_string:)
      @raw_string = raw_string
      @root = {}
      @merchant_info = {}

      process
    end

    def process 
      parse_root
      parse_merchant_info
    end

    def parse(data:)
      attrs = {}
      current_cursor = :id
      ids = []
      lengths = []
      values = []

      data.chars.each do |c|
        case current_cursor 
        when :id
          ids << c
          current_cursor = :length if ids.size == 2
        when :length
          lengths << c
          current_cursor = :value if lengths.size == 2
        when :value
          value_counter = lengths.join.to_i
          values << c

          if value_counter == values.size
            attrs[ids.join] = values.join

            ids = []
            lengths = []
            values = []

            current_cursor = :id
          end
        end
      end

      attrs
    end

    private

    def parse_root
      attrs = parse(data: @raw_string)
      @root = attrs
    end

    def parse_merchant_info
      parsed_merchant_info = parse(data: @root['27'])
      @merchant_info = parsed_merchant_info
    end
  end
end

