# frozen_string_literal: true
# typed: true

class Reader
  def self.strip_headers(files)
    CSV.parse(
      files.map { |file| new(file).strip_header }.join("\n").gsub("\n\n", "\n")
    )
  end

  def self.no_headers(files)
    CSV.parse(
      files.map { |file| new(file).no_header }.join("\n").gsub("\n\n", "\n")
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
