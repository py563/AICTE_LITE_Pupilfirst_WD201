require "date"
require "active_record"

class Todo < ActiveRecord::Base
  def is_due_today?
    due_date == Date.today
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = is_due_today? ? nil : due_date
    "#{id}. #{display_status} #{todo_text} #{display_date}"
  end

  def self.due_today?
    where("due_date = ?", Date.today)
  end

  def self.due_later?
    where("due_date > ?", Date.today)
  end

  def self.overdue?
    where("due_date < ?", Date.today)
  end

  def self.show_list
    puts "My Todo-list\n\n"
    puts "Overdue \n"
    overdue?.map { |todo_item| puts todo_item.to_displayable_string }

    puts "\n\n"
    puts "Due Today\n"
    due_today?.map { |todo_item| puts todo_item.to_displayable_string }

    puts "\n\n"
    puts "Due Later\n"
    due_later?.map { |todo_item| puts todo_item.to_displayable_string }
  end

  def self.add_task(todo_item)
    Todo.create!(todo_text: todo_item[:todo_text], due_date: Date.today + todo_item[:due_in_days], completed: false)
  end

  def self.mark_as_complete(completed_item_id)
    Todo.update(completed_item_id, completed: true)
  end
end
