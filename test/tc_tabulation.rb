require "tabulation"
require "test/unit"

class TC_Tabulation < Test::Unit::TestCase
  def test_initialize_empty
    t = Tabulation.new
    assert t.empty?
    assert t.rows.empty?
    assert t.row(0).empty?
    assert t.columns.empty?
    assert t.column(0).empty?
    assert t.cell(0,0).empty?
  end

  def test_initialize_not_empty
    t = Tabulation.new(2, 2)
    assert t.any?
    assert_equal 2, t.rows.count
    assert_equal 2, t.columns.count
  end

  def test_initialize_incorrect_size
    t = Tabulation.new(1, 0)
    assert_equal 0, t.rows.count
    t = Tabulation.new(0, 1)
    assert_equal 0, t.columns.count
  end

  def test_initialize_invalid_size
    assert_raise(ArgumentError) { Tabulation.new(-1, 1) }
    assert_raise(ArgumentError) { Tabulation.new(1, -1) }
  end

  def test_clear
    t = Tabulation.new(2, 2)
    t.clear
    assert t.empty?
  end

  def test_cell_assign
    t = Tabulation.new 
    t.cell(1, 1).value = 1
    assert_equal 2, t.rows.count
    assert_equal 2, t.columns.count
    assert_nil t.cell(0, 0).value
    assert_nil t.cell(0, 1).value
    assert_nil t.cell(1, 0).value
    assert_equal 1, t.cell(1, 1).value
  end

  def test_cell_assign_invalid
    t = Tabulation.new(2,2)
    assert_nothing_raised { t.cell(-1, 1).value = 1 }
    assert_nothing_raised { t.cell(1, -1).value = 1 }
    assert_raise(IndexError) { t.cell(-3, 1).value = 1 }
    assert_raise(IndexError) { t.cell(1, -3).value = 1 }
  end
  
  def test_rows_push
    t = Tabulation.new
    t.rows << [1]
    t.rows << [2,3]
    assert_equal 2, t.rows.count
    assert_equal 2, t.columns.count
    assert_equal 1, t.cell(0, 0).value
    assert_nil t.cell(0, 1).value
    assert_equal 2, t.cell(1, 0).value
    assert_equal 3, t.cell(1, 1).value
  end

  def test_rows_push_empty
    t = Tabulation.new
    t.rows << []
    assert_equal 0, t.rows.count
    assert_equal 0, t.columns.count
  end

  def test_rows_push_coercion
    t = Tabulation.new
    assert_nothing_raised { t.rows << nil }
    assert_nothing_raised { t.rows << "" }
    assert_nothing_raised { t.rows << 1 }
    assert_equal 1, t.rows.count
  end
  
  def test_rows_insert
    t = Tabulation.new(1, 2)
    t.rows.insert 2, [1]
    assert_equal 3, t.rows.count
    assert_equal 2, t.columns.count
    assert_equal 1, t.cell(2, 0).value
  end

  def test_rows_enumeration
    t = Tabulation.new
    t.rows << [1]
    t.rows << [2]
    t.rows << [3]
    t.rows << [4]
    assert_equal 10, t.rows.inject(0) { |sum,row| sum + row.column(0).value }
  end

  def test_row_cells_enumeration
    t = Tabulation.new
    t.rows << [1,2,3,4]
    assert_equal 10, t.row(0).columns.inject(0) { |sum,cell| sum + cell.value }
  end
  
  def test_columns_push
    t = Tabulation.new
    t.columns << [1]
    t.columns << [2,3]
    assert_equal 2, t.rows.count
    assert_equal 2, t.columns.count
    assert_equal 1, t.cell(0, 0).value
    assert_equal 2, t.cell(0, 1).value
    assert_nil t.cell(1, 0).value
    assert_equal 3, t.cell(1, 1).value
  end

  def test_columns_push_empty
    t = Tabulation.new
    t.columns << []
    assert_equal 0, t.rows.count
    assert_equal 0, t.columns.count
  end

  def test_columns_push_coercion
    t = Tabulation.new
    assert_nothing_raised { t.columns << nil }
    assert_nothing_raised { t.columns << "" }
    assert_nothing_raised { t.columns << 1 }
    assert_equal 1, t.columns.count
  end
  
  def test_columns_insert
    t = Tabulation.new(2, 1)
    t.columns.insert 2, [1]
    assert_equal 2, t.rows.count
    assert_equal 3, t.columns.count
    assert_equal 1, t.cell(0, 2).value
  end

  def test_columns_enumeration
    t = Tabulation.new
    t.columns << [1]
    t.columns << [2]
    t.columns << [3]
    t.columns << [4]
    assert_equal 10, t.columns.inject(0) { |sum,column| sum + column.row(0).value }
  end

  def test_column_cells_enumeration
    t = Tabulation.new
    t.columns << [1,2,3,4]
    assert_equal 10, t.column(0).rows.inject(0) { |sum,cell| sum + cell.value }   
  end
end