# frozen_string_literal: true
# typed: true

class Reader
  def self.strip_headers(fs)
    CSV.parse(
      fs.map { |file| new(file).strip_header }.join("\n")
    )
  end

  def self.no_headers(fs)
    CSV.parse(
      fs.map { |file| new(file).no_header }.join("\n")
    )
  end

  def initialize(file)
    @file = file
  end

  def no_header
    read
  end

  def strip_header
    read.split("\n")[1..]&.join("\n")
  end

  def read
    File.read(@file).gsub("\r", '')
  end
end
