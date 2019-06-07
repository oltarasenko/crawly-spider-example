defmodule EslBlogTest do
  use ExUnit.Case
  doctest EslBlog

  test "greets the world" do
    assert EslBlog.hello() == :world
  end
end
