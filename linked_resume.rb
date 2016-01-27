require 'yaml'
require 'colorize'

class CurriculumVitae
  RESUME = './resume.yml'
  attr_reader :resume, :root_node

  def initialize(file=nil)
    file = file || RESUME
    @resume = YAML.load_file(file)
  end

  def root_node
    @root_node || EmptyNode.new(self)
  end

  def consume_resume
    resume.each(&consume)
    self
  end

  def consume
    proc do |key, values|
      push({phrase: key, type: :key})
      if values.is_a?(Hash)
        values.each(&consume) unless values.all? {|v| v.nil?}
      else
        push({phrase: values, type: :value}) if values
      end
    end
  end

  def push(hirable_bit)
    root_node.push(hirable_bit)
  end

  def print
    root_node.print.split("\n").each_with_index do |message, index|
      sleep 0.01
      printf message + "\n"
    end
  end

  def node_type
    :@root_node
  end

  def key_count
    count(:key)
  end

  def value_count
    count(:value)
  end

  def count(type=nil)
    root_node.count(type)
  end
end

class ResumeNode
  COLOR_CHART = {key: :orange, value: :blue}
  attr_reader :phrase, :next_node, :type

  def initialize(hirable_bit)
    @phrase    = hirable_bit[:phrase]
    @type      = hirable_bit[:type]
    @next_node = EmptyNode.new(self)
  end

  def push(phrase)
    next_node.push(phrase)
  end

  def node_type
    :@next_node
  end

  def print
    "#{pretty_phrase}#{type_signout}#{next_node.print}"
  end

  def type_signout
    if type == :key && next_node.type == :key
      ":\n  "
    elsif type == :key
      ": "
    else
      "\n"
    end
  end

  def pretty_phrase
    phrase.colorize(COLOR_CHART[type])
  end

  def count(param_type=nil)
    if type == param_type
      next_node.count(type) + 1
    elsif !param_type
      next_node.count(nil) + 1
    else
      next_node.count(param_type)
    end
  end
end

class EmptyNode
  attr_reader :parent
  def initialize(parent)
    @parent = parent
  end

  def push(hirable_bit)
    parent.instance_variable_set(parent.node_type, ResumeNode.new(hirable_bit))
  end

  def print
    "\n\n\nI hope you enjoyed DJ's Resume!".colorize(:red)
  end

  def type
    :key
  end

  def count(_)
    0
  end

  def value
    nil
  end
end

class Printer
  @@cv = CurriculumVitae.new.consume_resume
  @@total_count = @@cv.count
  @@key_count   = @@cv.key_count
  @@value_count = @@cv.value_count

  def self.introduction
    50.times { puts "\n" }
    sleep 1
    30.times { puts "\n" }
    puts "You did say #{'link'.colorize(:green)} your Resume didn't you?"
    34.times { puts "\n" }

    sleep 3
    30.times { puts "\n" }
    puts "Well I took my resume..."
    33.times { puts "\n" }

    sleep 3
    30.times { puts "\n" }
    puts "...put it in YAML form..."
    32.times { puts "\n" }

    sleep 3
    30.times { puts "\n" }
    puts "And made a #{'linked list'.colorize(:green)} out of it!"
    31.times { puts "\n" }

    sleep 3
    30.times { puts "\n" }
    puts "You're in for a treat! There are #{@@total_count} nodes in this #{'linked list'.colorize(:green)}!\n"
    30.times { puts "\n" }

    sleep 4
    30.times { puts "\n" }
    puts "Out of those, #{@@key_count} of them are just topics."
    29.times { puts "\n" }

    sleep 3
    30.times { puts "\n" }
    puts "But the real information...\n"
    28.times { puts "\n" }

    sleep 4
    30.times { puts "\n" }
    puts "...is in the #{@@value_count} YAML bodies the resume has.\n"
    27.times { puts "\n" }

    sleep 4
    30.times { puts "\n" }
    puts "Check it out!"
    26.times { puts "\n" }

    sleep 2
    30.times { puts "\n" }
  end

  def self.list_output
    @@cv.print
  end
end


if __FILE__ == $0
  Printer.introduction
  Printer.list_output
end

