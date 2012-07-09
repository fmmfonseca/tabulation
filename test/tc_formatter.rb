require "tabulation"
require "formatter"
require "test/unit"

class TC_Formatter < Test::Unit::TestCase
	def test_to_html
		t = Tabulation.new
		t.rows.push [1,2]
		t.rows.push [3,4]
		out = Formatter.new(t).to_html
		assert out.include? "<td>1</td>"
		assert out.include? "<td>2</td>"
		assert out.include? "<td>3</td>"
		assert out.include? "<td>4</td>"
	end
end