require 'sinatra'
require 'slim'

LOGREGEX = /\A\d{2}-[A-Z][a-z]{2}-\d{4} \d{2}:\d{2}:\d{2}\.\d{3}/

def parse(file)
  lines = file.readlines.select { |line| line =~ LOGREGEX }
  table = lines.map { |line| line.split(/\s+/, 8) }
  return table
end

get '/' do
  slim :form
end

post '/table' do
  begin
    file = params[:file][:tempfile]
    @table = parse(file)
    if @table.empty?
      raise
    else
      slim :table
    end
  rescue
    slim :error
  end
end

__END__

@@ form
form action='/table' method='post' enctype='multipart/form-data'
  p
    label for='file' file:
    input type='file' name='file'
  p
    input type='submit' name='commit' value='upload & see table'

@@ table
a href='/' go home
table
  - for row in @table
    tr
      - for cell in row
        td = cell

@@ error
a href='/' go home
h1 error
p there is no way I can parse this
p come back when u sane

