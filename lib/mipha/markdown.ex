defmodule Mipha.Markdown do
  @moduledoc """
  Sanitize a string's HTML, then render the string as markdown in the Mipha style.
  """

  def render(body) do
    body
    |> as_html!()
  end

  defp as_html!(body) do
    body
    |> HtmlSanitizeEx.markdown_html()
    |> Earmark.as_html!(earmark_options())
  end

  def example do
    File.read!("./lib/mipha/markdown/markdown_guides.md")
  end

  def earmark_options do
    %Earmark.Options{
      # Prefix the `code` tag language class, as in `language-elixir`, for
      # proper support from http://prismjs.com/
      code_class_prefix: "language-",
      # renderer: Mipha.Markdown.HtmlRenderer,
      gfm: true,
      breaks: true,
      smartypants: false
    }
  end
end
