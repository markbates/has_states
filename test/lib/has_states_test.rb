require 'test_helper'

class Foo
  include HasStates

  has_states %w{completed running}

  attr_accessor :state
end

class Bar
  include HasStates

  has_states :started, :stopped, attr_name: "status", const_name: "statuses"

  attr_accessor :status
end

describe HasStates do

  it "creates a list at the class level" do
    Foo::STATES.must_equal %w{completed running}
    Bar::STATUSES.must_equal %w{started stopped}
  end

  it "creates ? methods" do
    f = Foo.new

    f.state = "completed"
    f.completed?.must_equal true
    f.running?.must_equal false
    f.not_running?.must_equal true

    f.state = "running"
    f.completed?.must_equal false
    f.not_completed?.must_equal true
    f.running?.must_equal true

    b = Bar.new

    b.status = "started"
    b.started?.must_equal true
    b.stopped?.must_equal false

    b.status = "stopped"
    b.started?.must_equal false
    b.stopped?.must_equal true
  end

  it "creates ! methods" do
    f = Foo.new
    f.expects(:save!)

    f.state = "completed"
    f.running!
    f.state.must_equal "running"
  end

  it "creates where methods" do
    Foo.expects(:where).with(state: "completed")
    Foo.completed

    Bar.expects(:where).with(status: "started")
    Bar.started
  end

end
