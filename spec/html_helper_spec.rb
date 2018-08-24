require 'spec_helper'

def set_file_content(string)
	string = normalize_string_indent(string)
	File.open(filename, 'w'){ |f| f.write(string) }
	vim.edit filename
end

def get_file_content()
	vim.write
	IO.read(filename).strip
end

def before(string)
	set_file_content(string)
end

def after(string)
	expect(get_file_content()).to eq normalize_string_indent(string)
end

def type(string)
	string.scan(/<.*?>|./).each do |key|
		if /<.*>/.match(key)
			vim.feedkeys "\\#{key}"
		else
			vim.feedkeys key
		end
	end
end

describe "HTML helper multiple line" do
	let(:filename) { 'test.txt' }
	specify "Normal mode" do
		before <<-EOF
			<a href="#">bla bla bla</a>
		EOF

		vim.command(':call html_helper#multiline("n")')

		after <<-EOF
			<a href="#">
				bla bla bla
			</a>
		EOF
	end
end