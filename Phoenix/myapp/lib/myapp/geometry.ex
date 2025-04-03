defmodule Collinear do
  def roughly_collinear(points, tolerance \\ 1.0e-8) do
    case points do
      [_, _] -> true  # Two points are always collinear
      [p1, p2 | rest] -> check_collinear(p1, p2, rest, tolerance)
      _ -> false  # No points or single point
    end
  end

  defp check_collinear(_p1, _p2, [], _tolerance), do: true

  defp check_collinear({x1, y1}, {x2, y2}, [{x3, y3} | rest], tolerance) do
    area = abs((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1))

    IO.puts("area #{area}, tolerance #{tolerance}")

    if area < tolerance do
      check_collinear({x1, y1}, {x2, y2}, rest, tolerance)
    else
      false
    end
  end
end
