# See https://lakret.net/blog/2024-03-05-keyword-get-considered-harmful
defmodule Bench do
  @opts [x: true, y: 2, z: 3.154] ++
          for(id <- 1..7, do: {:"option#{id}", "value#{id}"})

  def get_opts, do: @opts

  def keyword_get_opts(opts) do
    x = Keyword.get(opts, :x, false)
    y = Keyword.get(opts, :y, 0)
    z = Keyword.get(opts, :z, 0.0)

    values =
      Enum.reduce(7..1, [], fn id, vs ->
        [Keyword.get(opts, :"option#{id}", "") | vs]
      end)

    :crypto.hash(:sha, :erlang.term_to_binary({x, y, z, values}))
  end

  def keyword_pop_opts(opts) do
    {x, opts} = Keyword.pop(opts, :x, false)
    {y, opts} = Keyword.pop(opts, :y, 0)
    {z, opts} = Keyword.pop(opts, :z, 0.0)

    {values, _opts} =
      Enum.reduce(7..1, {[], opts}, fn id, {vs, opts} ->
        {value, opts} = Keyword.pop(opts, :"option#{id}", "")
        {[value | vs], opts}
      end)

    :crypto.hash(:sha, :erlang.term_to_binary({x, y, z, values}))
  end

  def keyword_validate_opts(opts) do
    opts =
      Keyword.validate!(
        opts,
        [x: false, y: 0, z: 0.0] ++
          for(id <- 1..7, do: {:"option#{id}", ""})
      )

    x = Keyword.get(opts, :x)
    y = Keyword.get(opts, :y)
    z = Keyword.get(opts, :z)

    values =
      Enum.reduce(7..1, [], fn id, vs ->
        [Keyword.get(opts, :"option#{id}") | vs]
      end)

    :crypto.hash(:sha, :erlang.term_to_binary({x, y, z, values}))
  end

  def kword_extract_opts(opts) do
    [x, y, z | values] =
      Kword.extract!(
        opts,
        [x: false, y: 0, z: 0.0] ++
          for(id <- 1..7, do: {:"option#{id}", ""})
      )

    :crypto.hash(:sha, :erlang.term_to_binary({x, y, z, values}))
  end

  def get(), do: :timer.tc(Bench, :keyword_get_opts, [@opts]) |> elem(0)
  def pop(), do: :timer.tc(Bench, :keyword_pop_opts, [@opts]) |> elem(0)
  def validate(), do: :timer.tc(Bench, :keyword_validate_opts, [@opts]) |> elem(0)
  def extract(), do: :timer.tc(Bench, :kword_extract_opts, [@opts]) |> elem(0)
end
