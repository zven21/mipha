[
  inputs: [
    "{lib,test,priv}/**/*.{ex,exs}",
    "mix.exs",
    ".formatter.exs",
    ".iex.exs",
    ".credo.exs"
  ],
  import_deps: [:ecto, :plug, :phoenix]
]
