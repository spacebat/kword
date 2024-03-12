# Kword

<!-- MDOC !-->

A library of keyword-list handling functions to complement Keyword

## Use Case

Elixir keyword lists as a common representation of optional arguments to functions feels a bit clunky. You may find yourself writing something like:

```elixir
  def update_user_details(opts \\ []) do
    opts = Keyword.validate!(opts, [:name, :email, role: :guest, gender: :unspecified])
    name = Keyword.fetch!(opts, :name)
    email = Keyword.fetch!(opts, :email)
    ...
  end
```

The intent of Kword is to enable list matching (there's an order of parameters in the second argument) and to write instead:

```elixir
  def update_user_details(opts \\ []) do
    [name, email | _rest] = Kword.extract!(opts, [:name, :email, role: :guest, gender: :unspecified])
    ...
  end
```

If you want to ensure required parameters are in fact supplied, use `extract` or `extract!`.

If you don't want to allow parameters that aren't specified, use `extract_exhaustive` or `extract_exhaustive!`.

And if you just want to pluck values out of a keyword list in the order specified, use `extract_permissive` which will default parameters to nil that have no default specified.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `kword` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kword, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/kword>.

