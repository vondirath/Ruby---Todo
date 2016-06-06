module Menu
    
    def menu
        "Welcome! With this tool you can add
        or modify task - specific text files. 
        it is best to start a new file with 
        this for best results!
        1) Add task
        2) Show current tasks
        3) Save or Create a file
        4) Open a file
        5) Delete a task from list
        6) Update a task
        7) Toggle current task
        Q) Quit "
    end
    
    def show
        menu
    end
    
end

module Promptable
    
    def prompt(message ='What would you like to do?', symbol = ':>')
        print message
        print symbol
        gets.chomp
    end
    
end

#classes
class List
    attr_reader:all_tasks
    
    def initialize
        @all_tasks = []
    end
    
    def add(task)
        all_tasks << task
    end
    
    def show
        all_tasks.map.with_index {|l, i| "(#{i.next}): #{l}" }
    end
    
    def write_to_file(filename)
        ma = @all_tasks.map(&:to_machine).join("\n")
        IO.write(filename, ma)
            if File.exists?(filename)
                puts "Saving to #{filename}.."
            elsif
                puts "Creating #{filename}..."
            else filename == nil
                puts "Nothing entered. Returning to main menu.."
            end
    end
    
    def read_file(filename)
        IO.readlines(filename).each do |line|
            status, *description = line.split (':')
            status = status.downcase.include?('x')
            add(Task.new(description.join(':').strip, status))
        end
    end
    
    def delete(task_number)
        all_tasks.delete_at(task_number - 1)
    end
    
    def update(task_number, task)
        all_tasks[task_number - 1] = task
    end
    
    def toggle(task_number)
        all_tasks[task_number - 1].toggle_status
    end
    
end

class Task
    attr_reader :description
    attr_accessor :completed_status
    def initialize(description, status = false)
        @status = status
        @description = description
    end
    
    def to_s
        "#{represent_status} : #{description}"
    end
    
    def completed?
        completed_status
    end
        
    def toggle_status
        @completed_status = !completed? 
    end

    def to_machine
       "#{represent_status}:#{description}" 
    end
    
    private
    
    def represent_status
        completed? ? '[X]' : '[ ]'
    end

end

if __FILE__ == $PROGRAM_NAME
    include Promptable
    include Menu 
    my_list = List.new
    puts "Please choose from the following..."
        until ['q'].include?(user_input = prompt(show).downcase) 
            case user_input
                when '1'
                    my_list.add(Task.new(prompt('What is the task you would like to accomplish?')))
                when '2'
                    puts my_list.show
                when '3'
                    puts Dir["*.txt"]
                    begin
                        my_list.write_to_file(prompt 'What file would you like to write to? or create?(just enter a name and use file extensions as necessary)')
                    rescue Errno::ENOENT
                            puts 'Nothing entered... returning to main menu'
                    end
                when '4'
                    puts Dir["*.txt"]
                    begin 
                        my_list.read_file(prompt('What file would you like to open?'))
                        puts my_list.show
                    rescue Errno::ENOENT
                        puts 'File name not found, please verify your file name and path.'
                    end
                when '5'
                    puts my_list.show
                    my_list.delete(prompt('What line number would you like to delete?').to_i)
                when '6'
                    puts my_list.show
                    my_list.update(prompt('What line would you like to update?').to_i,
                    Task.new(prompt('Task Description?')))
                when '7'
                    puts my_list.show
                my_list.toggle(prompt('Which would you like to toggle the status for?').to_i)
                    puts my_list.show
            else
              puts 'Sorry, I did not understand'
         end
        prompt ('Press enter to Continue')
    end 
puts 'Goodbye!'
end 