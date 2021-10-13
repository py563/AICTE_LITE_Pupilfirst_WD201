require "date"
require "active_record"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def overdue?
    due_date < Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.to_displayable_list
    all.map { |todo| todo.to_displayable_string }
  end

  def self.show_list
    puts "My Todo-list\n\n"
    puts "Overdue \n"
    all.filter { |todo_item| todo_item.overdue? }
      .map { |todo_item| puts todo_item.to_displayable_string }

    puts "\n\n"
    puts "Due Today\n"
    all.filter { |todo_item| todo_item.due_today? }
      .map { |todo_item| puts todo_item.to_displayable_string }

    puts "\n\n"
    puts "Due Later\n"
    all.filter { |todo_item| todo_item.due_later? }
      .map { |todo_item| puts todo_item.to_displayable_string }
  end

  def self.add_task(todo_item)
    Todo.create!(todo_text: todo_item[:todo_text], due_date: Date.today + todo_item[:due_in_days], completed: false)
  end

  def self.mark_as_complete(completed_item_id)
    Todo.update(completed_item_id, completed: true)
  end
end
