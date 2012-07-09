require 'tabulation'
require 'erb'

class Formatter

  class HTML
    private_class_method :new

    def self.render(tabulation)
      template = ERB.new <<-HTML
        <table>
          <thead>
            <tr>
              <% tabulation.columns.each do |column| %>
              <th></th>
              <% end %>
            </tr>
          </thead>
          <tbody>
            <% tabulation.rows.each do |row| %>
            <tr>
              <% row.columns.each do |cell| %>
              <td><%= cell.value %></td>
              <% end %>
            </tr>
            <% end %>
          </tbody>
        </table>
      HTML
      template.result(binding)
    end
  end

end