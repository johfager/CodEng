require './parser.rb'

def run_file(filename)
  parser = CodEng.new()
  text = File.read(filename)
  parser.test(text)
end

run_file(ARGV[0])
