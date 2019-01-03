defmodule GorgTest do
  use ExUnit.Case
  doctest Gorg

  test "greets the world" do
    assert Gorg.hello() == :world
  end
end
