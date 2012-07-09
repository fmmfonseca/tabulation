##
# A two-dimensional, mutable table of values.
#
class Tabulation
  VERSION = "0.0.1"
  
  ##
  # Creates a new tabulation.
  #
  # ==== Parameter(s)
  # * +rows+ - number of rows;
  # * +columns+ - number of columns;
  #
  # ==== Example(s)
  #  t = Tabulation.new
  #  t = Tabulation.new(2, 2)
  #
  def initialize(rows=0, columns=0)
    @data = Data.new(rows, columns)
  end
  
  ##
  # Returns a collection of rows.
  #
  # ==== Example(s)
  #  t = Tabulation.new
  #  t.rows #=> #<Tabulation::RowCollection>
  #
  def rows
    RowCollection.new(@data)
  end

  ##
  # Returns a single row.
  #
  # ==== Parameter(s)
  # * +row+ - row index;
  #
  # ==== Example(s)
  #  t = Tabulation.new
  #  t.row(0) #=> #<Tabulation::Row>
  #
  def row(row)
    Row.new(@data, row)
  end
  
  ##
  # Returns a collection of columns.
  #
  # ==== Example(s)
  #  t = Tabulation.new
  #  t.rows #=> #<Tabulation::ColumnCollection>
  #
  def columns
    ColumnCollection.new(@data)
  end
  
  ##
  # Returns a single column.
  #
  # ==== Parameter(s)
  # * +column+ - column index;
  #
  # ==== Example(s)
  #  t = Tabulation.new
  #  t.row(0) #=> #<Tabulation::Column>
  #
  def column(column)
    Column.new(@data, column)
  end
  
  ##
  # Returns a single cell.
  #
  # ==== Parameter(s)
  # * +row+ - row index;
  # * +column+ - column index;
  #
  # ==== Example(s)
  #  t = Tabulation.new
  #  t.cell(0, 0) #=> #<Tabulation::Cell>
  #
  def cell(row, column)
    Cell.new(@data, row, column)
  end
  
  ##
  # Returns true if the number of allocated cells is zero.
  #
  # ==== Example(s)
  #  t = Tabulation.new
  #  t.empty? #=> true
  #  t = Tabulation.new(2, 2)
  #  t.empty? #=> false
  #
  def empty?
    @data.cells_count <= 0
  end
  
  ##
  # Returns true if the number of allocated cells is greater than zero.
  #
  # ==== Example(s)
  #  t = Tabulation.new
  #  t.any? #=> false
  #  t = Tabulation.new(2, 2)
  #  t.any? #=> true
  #
  def any?
    !empty?
  end

  ##
  # Deletes all allocated cells.
  #
  # ==== Example(s)
  #  t = Tabulation.new(2, 2)
  #  t.clear
  #  t.empty? #=> true
  #
  def clear
    @data.resize(0, 0)
    self
  end
  
  ##
  # A collection of rows for a Tabulation.
  #
  class RowCollection
    include Enumerable
    
    def initialize(data)
      @data = data
    end

    ##
    # Returns true if the number of allocated rows is zero.
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t.rows.empty? #=> true
    #
    def empty?
      @data.rows_count <= 0
    end
    
    ##
    # Adds a new row at the end position.
    #
    # ==== Parameter(s)
    # * +values+ - array of cell values;
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t.rows.push [1,2]
    #  t.rows.push [3]
    #  t.rows.push [4, 5, 6]
    #  t.rows.count #=> 3
    #
    def push(values)
      values = Array(values)
      unless values.empty?
        @data.expand(@data.rows_count, values.count)
        @data.values.push Array.new([@data.columns_count, values.count].max) { |index| values[index] }
      end
      self
    end

    alias << push

    ##
    # Adds a new row at the given position.
    #
    # ==== Parameter(s)
    # * +row+ - row index;
    # * +values+ - array of cell values;
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t = t.rows.insert 0, [1, 2]
    #  t = t.rows.insert 2, [3]
    #  t = t.rows.insert 4, [4, 5, 6]
    #  t.rows.count #=> 5
    #
    def insert(row, values)
      values = Array(values)
      unless values.empty?
        @data.expand(row, values.count)
        @data.values.insert row, Array.new([@data.columns_count, values.count].max) { |index| values[index] }
      end
      self
    end
  
    ##
    # Calls block once for each row.
    # If no block is given, an enumerator is returned instead.
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t = t.rows.push [1, 2]
    #  t = t.rows.push [3]
    #  t.rows.each { |row| }
    #
    def each
      return to_enum unless block_given?
      @data.rows_count.times { |row| yield Row.new(@data, row) }
      self
    end
  end

  ##
  # A single row for a Tabulation.
  #
  class Row    
    def initialize(data, row)
      @data = data
      @row = row
    end

    ##
    # Returns true if the number of allocated cells is zero.
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t.row(0).empty? #=> true
    #
    def empty?
      @row >= @data.rows_count
    end

    ##
    # Returns a collection of cells.
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t = t.rows(0).columns #=> #<Tabulation::Row::CellCollection>
    #
    def columns
      CellCollection.new(@data, @row)
    end
    
    ##
    # Returns a single cell.
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t = t.rows(0).column(0) #=> #<Tabulation::Cell>
    #
    def column(column)
      Cell.new(@data, @row, column)
    end

    ##
    # A collection of cells for a Row.
    #
    class CellCollection
      include Enumerable

      ##
      # Creates a new cell collection.
      #
      def initialize(data, row)
        @data = data
        @row = row
      end

      ##
      # Calls block once for each cell.
      # If no block is given, an enumerator is returned instead.
      #
      # ==== Example(s)
      #  t = Tabulation.new
      #  t = t.rows.push [1, 2]
      #  t.row(0).columns.each { |cell| }
      #
      def each
        return to_enum unless block_given?
        @data.columns_count.times { |column| yield Cell.new(@data, @row, column) }
        self
      end
    end
  end
  
  ##
  # A collection of columns for a Tabulation.
  #
  class ColumnCollection
    include Enumerable
    
    def initialize(data)
      @data = data
    end

    ##
    # Returns true if the number of allocated columns is zero.
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t.columns.empty? #=> true
    #
    def empty?
      @data.columns_count <= 0
    end

    ##
    # Adds a new column at the end position.
    #
    # ==== Parameter(s)
    # * +values+ - array of cell values;
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t.columns.push [1, 2]
    #  t.columns.push [3]
    #  t.columns.push [4, 5, 6]
    #  t.columns.count #=> 3
    #
    def push(values)
      values = Array(values)
      unless values.empty?
        @data.expand(values.count, @data.columns_count)
        [@data.rows_count, values.count].max.times { |index| (@data.values[index] ||= []).push values[index] }
      end
      self
    end

    alias << push

    ##
    # Adds a new column at the given position.
    #
    # ==== Parameter(s)
    # * +column+ - column index;
    # * +values+ - array of cell values;
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t = t.columns.insert 0, [1, 2]
    #  t = t.columns.insert 2, [3]
    #  t = t.columns.insert 4, [4, 5, 6]
    #  t.columns.count #=> 5
    #
    def insert(column, values)
      values = Array(values)
      unless values.nil? or values.empty?
        @data.expand(values.count, column)
        [@data.rows_count, values.count].max.times { |index| (@data.values[index] ||= []).insert column, values[index] }
      end
      self
    end
    
    ##
    # Calls block once for each column.
    # If no block is given, an enumerator is returned instead.
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t = t.columns.push [1, 2]
    #  t = t.columns.push [3]
    #  t.columns.each { |column| }
    #
    def each
      return to_enum unless block_given?
      @data.columns_count.times { |index| yield Column.new(@data, index) }
      self
    end
  end
  
  ##
  # A single column for a Tabulation.
  #
  class Column
    def initialize(data, column)
      @data = data
      @column = column
    end

    ##
    # Returns true if the number of allocated cells is zero.
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t.column(0).empty? #=> true
    #
    def empty?
      @column >= @data.columns_count
    end

    ##
    # Returns a collection of cells.
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t = t.column(0).rows #=> #<Tabulation::Column::CellCollection>
    #
    def rows
      CellCollection.new(@data, @column)
    end
    
    ##
    # Returns a single cell.
    #
    # ==== Example(s)
    #  t = Tabulation.new
    #  t = t.column(0).row(0) #=> #<Tabulation::Cell>
    #
    def row(row)
      Cell.new(@data, row, @column)
    end
  
    ##
    # A collection of cells for a Column.
    #
    class CellCollection
      include Enumerable

      def initialize(data, column)
        @data = data
        @column = column
      end

      ##
      # Calls block once for each cell.
      # If no block is given, an enumerator is returned instead.
      #
      # ==== Example(s)
      #  t = Tabulation.new
      #  t.columns.push [1, 2]
      #  t.column(0).rows.each { |cell| }
      #
      def each
        return to_enum unless block_given?
        @data.rows_count.times { |row| yield Cell.new(@data, row, @column) }
        self
      end
    end
  end
  
  ##
  # A single cell for a Tabulation.
  #
  class Cell
    def initialize(data, row, column)
      @data = data
      @row = row
      @column = column
    end

    ##
    # Returns true if not allocated.
    #
    # ==== Example(s)
    #  t = Tabulation.new(2, 2)
    #  t.cell(0, 0).empty? #=> false
    #  t.cell(2, 2).empty? #=> true
    #
    def empty?
      @row >= @data.columns_count || @column >= @data.columns_count
    end
    
    ##
    # Returns the value.
    #
    def value
      @data[@row, @column]
    end
    
    ##
    # Sets the value.
    #
    def value=(value)
      @data[@row, @column] = value
    end
  end

  protected

  ##
  # :nodoc:
  #
  # The supporting structure for a Tabulation.
  #
  Data = Class.new do
    attr_accessor :values
    
    def initialize(rows, columns)
      @values = []
      resize(rows, columns)
    end
    
    ##
    # Returns a cell.
    #
    # ==== Parameter(s)
    # * +row+ - row index;
    # * +column+ - column index;
    #
    def [](row, column)
      (@values[row] || [])[column]
    end
    
    ##
    # Sets a cell.
    #
    # ==== Parameter(s)
    # * +row+ - row index;
    # * +column+ - column index;
    # * +obj+ - object;
    #
    def []=(row, column, obj)
      raise IndexError, "row #{row} is out of bounds" if row < -rows_count
      raise IndexError, "column #{column} is out of bounds" if column < -columns_count
      expand(row+1, column+1)
      @values[row][column] = obj
    end
    
    ##
    # Returns the number of rows.
    #
    def rows_count
      @values.count
    end
    
    ##
    # Returns the number of columns.
    #
    def columns_count
      @values.empty? ? 0 : @values.first.count
    end

    ##
    # Returns the number of cells.
    #
    def cells_count
      rows_count * columns_count
    end
    
    ##
    # Alters the number of rows and/or columns.
    #
    # ==== Parameter(s)
    # * +rows+ - number of rows;
    # * +columns+ - number of columns;
    #
    def resize(rows, columns)
      raise ArgumentError, "number of rows must be greater than or equal to zero" if rows < 0
      raise ArgumentError, "number of columns must be greater than or equal to zero" if columns < 0
      if rows * columns > 0
        @values = Array.new(rows) { |row| Array.new(columns) { |column| self[row, column] } }
      else
        @values = []
      end
      self
    end

    ##
    # Grows the number of rows and/or columns.
    #
    # ==== Parameter(s)
    # * +rows+ - number of rows;
    # * +columns+ - number of columns;
    #
    def expand(rows, columns)
      if rows_count < rows || columns_count < columns
        resize([rows_count, rows].max, [columns_count, columns].max)
      end
      self
    end
  end
end