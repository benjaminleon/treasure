defmodule CollinearTest do
  use ExUnit.Case
  doctest Collinear

  test "returns true for collinear points" do
    assert Collinear.roughly_collinear([{1, 2}, {2, 4}, {3, 6}, {4, 8}])
  end

  test "returns false for non-collinear points" do
    refute Collinear.roughly_collinear([{1, 2}, {2, 4}, {3, 7}, {4, 10}])
  end

  test "returns true for two points" do
    assert Collinear.roughly_collinear([{1, 2}, {2, 4}])
  end

  test "returns false for empty list" do
    refute Collinear.roughly_collinear([])
  end

  test "returns false for a single point" do
    refute Collinear.roughly_collinear([{1, 2}])
  end

  test "handles points with small numerical errors within tolerance" do
    assert Collinear.roughly_collinear([{0.0, 0.0}, {1.0, 1.0}, {2.0, 2.0000001}], 1.0e-5)
  end

  test "fails collinearity check when outside the given tolerance" do
    refute Collinear.roughly_collinear([{0.0, 0.0}, {1.0, 1.0}, {2.0, 2.1}], 1.0e-3)
  end

  test "real life examples" do
    # These coordinates are from a stretch of ~20m on Åsvägen 5,
    # expect for p4 which deviates a few metres from the line
    p1 = {59.367088167659716, 17.996969777722637}
    p2 = {59.36690024258298, 17.997293839999088}
    p3 = {59.36684887696343, 17.99738209670755}
    p4 = {59.36703474770291, 17.997127208607964}  # not on the same line
    p5 = {59.367041490318435, 17.997051560000745}
    assert Collinear.roughly_collinear([p1, p2, p3, p5])
    refute Collinear.roughly_collinear([p1, p2, p3, p4, p5])
  end


end
