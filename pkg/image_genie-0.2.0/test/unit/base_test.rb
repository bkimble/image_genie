require 'test_helper'

class BaseTest < Test::Unit::TestCase
  test "path for when path exists" do
    ImageGenie::Base.expects(:paths).returns({:convert => "/some/dir/convert", :montage => "/some/dir/montage"}).times(2)
    assert_equal("/some/dir/convert", ImageGenie::Base.path_for(:convert))
    assert_equal("/some/dir/montage", ImageGenie::Base.path_for(:montage))    
  end

  test "path for when path doesnt exist" do
    ImageGenie::Base.expects(:paths).returns({:convert => "/some/dir/convert", :montage => "/some/dir/montage"})
    assert_equal(nil, ImageGenie::Base.path_for(:identify))
  end
  
  test "make command with args only" do
    command = "some_command"
    args = ["abc","def"]
    assert_equal("some_command abc def", ImageGenie::Base.make_command(command,args))
  end

  test "make command with flags only" do
    command = "some_command"
    flags = {:foo => 1, :bar => 2}
    assert_equal("some_command -foo 1 -bar 2", ImageGenie::Base.make_command(command,flags))
  end
  
  test "make command" do
    command = "some_command"
    args = ["abc","def"]
    flags = {:foo => 1, :bar => 2}
    assert_equal("some_command -foo 1 -bar 2 abc def", ImageGenie::Base.make_command(command,flags,args))
  end
  
  test "make command with no flags or args" do
    command = "some_command"
    args = []
    flags = {}
    assert_equal("some_command", ImageGenie::Base.make_command(command))
  end
  
  test "make flags" do
    flags = {:foo => 1, :bar => 2}
    assert_equal("-foo 1 -bar 2", ImageGenie::Base.make_flags(flags))
  end
  
  test "make flags with nothing" do
    flags = {}
    assert_equal(nil, ImageGenie::Base.make_flags(flags))
  end

  test "make args" do
    args = ["abc","def"]
    assert_equal("abc def", ImageGenie::Base.make_args(args))
  end

  test "make args with nothing" do
    args = []
    assert_equal(nil, ImageGenie::Base.make_args(args))
  end
end

