defmodule Kword do
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  require Logger

  # values is a keyword list:
  # required: (list of key atoms)
  # optional: (list of key atoms or {key, default} tuples)
  # exhaustive: (boolean)
  @doc """
  Like `Keyword.validate/2` except in place of a keyword list in the return value, it returns a list
  of values in the order they appear in the second argument.
  """
  def extract(opts, params) do
    values =
      Enum.reduce(params, [], fn key_spec, acc ->
        value =
          case key_spec do
            {key, default} when is_atom(key) ->
              Keyword.get(opts, key, default)

            key when is_atom(key) ->
              case Keyword.fetch(opts, key) do
                {:ok, value} ->
                  value

                :error ->
                  throw({:error, {:missing, key}})
              end
          end

        [value | acc]
      end)
      |> Enum.reverse()

    {:ok, values}
  catch
    {:error, _} = err -> err
  end

  @doc """
  Like `Keyword.validate!/2` except instead of returning a keyword list, it returns a list of values
  in the order they appear in the second argument.

  ## Examples

      iex> Kword.extract!([x: 1, y: 2, z: 3, w: 4], [:w, x: 10, a: 7])
      [4, 1, 7]

      iex> Kword.extract!([x: 1, y: 2, z: 3], [:w, x: 10, a: 7])
      ** (ArgumentError) Missing key :w
  """
  def extract!(opts, params) do
    opts
    |> extract(params)
    |> maybe_raise()
  end

  @doc """
  Like `extract/2` except any keys supplied in opts that are not declared in params result in an error tuple.

  ## Examples

      iex> Kword.extract_exhaustive([x: 1], [:x, y: 7])
      {:ok, [1, 7]}

      iex> Kword.extract_exhaustive([x: 1, z: 3], [:x, y: 7])
      {:error, {:unexpected, :z}}
  """
  def extract_exhaustive(opts, params) do
    expected =
      Enum.reduce(params, MapSet.new(), fn key_spec, acc ->
        MapSet.put(
          acc,
          case key_spec do
            {key, _default} when is_atom(key) -> key
            key when is_atom(key) -> key
          end
        )
      end)

    error =
      Enum.find_value(opts, fn
        {key, _default} ->
          if MapSet.member?(expected, key) do
            false
          else
            {:error, {:unexpected, key}}
          end

        other ->
          {:error, {:invalid, other}}
      end)

    case error do
      {:error, _} = err -> err
      _ -> extract(opts, params)
    end
  end

  @doc """
  Like `extract_exhaustive/2` but raises an `ArgumentError` with the first key that was unexpected,


  ## Examples

      iex> Kword.extract_exhaustive!([x: 1], [:x, y: 7])
      [1, 7]

      iex> Kword.extract_exhaustive!([x: 1, z: 3], [:x, y: 7])
      ** (ArgumentError) Unexpected key :z
  """
  def extract_exhaustive!(opts, params) do
    opts
    |> extract_exhaustive(params)
    |> maybe_raise()
  end

  @doc """
  Map over `params`, each element of which is either an atom or a 2-tuple {atom, default}, getting
  the value of the first occurrence of the atom key in the keyword list `opts`, and if not found the
  default is used, or nil if there is no default.

  ## Examples

      iex> Kword.extract_permissive([x: 1, y: 2, z: 3], [:w, x: 10, a: 7, b: 8])
      [nil, 1, 7, 8]
  """
  def extract_permissive(opts, params) when is_list(opts) and is_list(params) do
    Enum.map(params, fn elt ->
      case elt do
        {key, default} when is_atom(key) ->
          Keyword.get(opts, key, default)

        key when is_atom(key) ->
          Keyword.get(opts, key)
      end
    end)
  end

  @compile :inline
  defp maybe_raise(value) do
    case value do
      {:ok, values} when is_list(values) -> values
      {:error, {:missing, key}} -> raise ArgumentError, "Missing key #{inspect(key)}"
      {:error, {:unexpected, key}} -> raise ArgumentError, "Unexpected key #{inspect(key)}"
      {:error, {:invalid, value}} -> raise ArgumentError, "Invalid value #{inspect(value)}"
      {:error, err} -> raise RuntimeError, "Unknown error #{inspect(err)}"
    end
  end
end
