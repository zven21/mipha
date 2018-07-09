defmodule Mipha.Markdown.EmbedVideoReplacer do
  @moduledoc false

  @youtube_url_regex  ~r{(\s|^|<div>|<br>)(https?://)(www.)?(youtube\.com/watch\?v=|youtu\.be/|youtube\.com/watch\?feature=player_embedded&v=)([A-Za-z0-9_\-]*)(\&\S+)?(\?\S+)?}
  @youku_url_regex    ~r{(\s|^|<div>|<br>)(http?://)(v\.youku\.com/v_show/id_)([a-zA-Z0-9\-_\=]*)(\.html)(\&\S+)?(\?\S+)?}
  @youku_base_url     "//player.youku.com/embed/"
  @youtube_base_url   "//www.youtube.com/embed/"

  def run(body) do
    cond do
      Regex.match?(@youtube_url_regex, body) == true  ->
        @youtube_url_regex
        |> Regex.replace(body, &youtube_replacer/1)

      Regex.match?(@youku_url_regex, body) == true ->
        @youku_url_regex
        |> Regex.replace(body, &youku_replacer/1)

      true ->
        body
    end
  end

  defp youku_replacer(whole_match) do
    youku_id =
      @youku_url_regex
      |> Regex.run(whole_match)
      |> Enum.at(4)

    embed_tag("#{@youku_base_url}#{youku_id}")
  end

  defp youtube_replacer(whole_match) do
    youtube_id =
      @youtube_url_regex
      |> Regex.run(whole_match)
      |> Enum.at(5)

    embed_tag("#{@youtube_base_url}#{youtube_id}")
  end

  defp embed_tag(src) do
    ~s(<span class="embed-responsive embed-responsive-16by9">
    <iframe class="embed-responsive-item" src="#{src}" allowfullscreen></iframe>
    </span>)
  end
end
