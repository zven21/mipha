defmodule Trubo.HTML.Paginate do
  @moduledoc """
  借鉴 https://raw.githubusercontent.com/mgwidmann/scrivener_html/master/lib/scrivener/html.ex
  适配 现有的 Trubo Paginate.
  """
  use Phoenix.HTML

  @raw_defaults [
    distance: 5,
    next: ">>",
    prev: "<<",
    first: true,
    last: true,
    ellipsis: raw("&hellip;")
  ]

  @doc """
  分页处理
  """
  # @spec quest_pagination_links(Map.t()) :: any
  def quest_pagination_links(paginator) do
    content_tag :ul, class: "pagination pagination-sm" do
      paginator
      |> raw_pagination_links()
      |> Enum.map(&page(&1, paginator))
    end
  end

  # a 标签的链接地址。
  # params: %{"q" => %{"title_like" => "a"}},
  # path_info: ["admin", "topics"],
  def path_info(paginator, page_number) do
    params = Map.put(paginator.params, "page", page_number)
    Path.join(["/" | paginator.path_info]) <> "?" <> Plug.Conn.Query.encode(params)
  end

  # 根据组装数据，填充分页信息。
  defp page({:ellipsis, text}, paginator) do
    content_tag(:li, class: li_classes_for_style(paginator, :ellipsis)) do
      content_tag(:a, safe(text), class: "page-link")
    end
  end
  defp page({text, page_number}, paginator) do
    content_tag(:li, class: li_classes_for_style(paginator, page_number)) do
      content_tag(:a, safe(text), href: path_info(paginator, page_number), class: "page-link")
    end
  end

  defp li_classes_for_style(_paginator, :ellipsis), do: "page-item"
  defp li_classes_for_style(paginator, page_number) do
    if paginator.current_page == page_number, do: "page-item active", else: "page-item"
  end

  defp raw_pagination_links(paginator) do
    opts = @raw_defaults
    paginator.current_page
    |> add_first(opts[:distance], opts[:first])
    |> add_first_ellipsis(paginator.current_page, paginator.total_pages, opts[:distance], opts[:first])
    |> add_prev(paginator.current_page)
    |> page_number_list(paginator.current_page, paginator.total_pages, opts[:distance])
    |> add_last_ellipsis(paginator.current_page, paginator.total_pages, opts[:distance], opts[:last])
    |> add_last(paginator.current_page, paginator.total_pages, opts[:distance], opts[:last])
    |> add_next(paginator.current_page, paginator.total_pages)
    |> Enum.map(fn
      :next -> if opts[:next], do: {opts[:next], paginator.next_page}
      :prev -> if opts[:prev], do: {opts[:prev], paginator.prev_page}
      :first_ellipsis -> if opts[:ellipsis] && opts[:first], do: {:ellipsis, opts[:ellipsis]}
      :last_ellipsis -> if opts[:ellipsis] && opts[:last], do: {:ellipsis, opts[:ellipsis]}
      :first -> if opts[:first], do: {opts[:first], 1}
      :last -> if opts[:last], do: {opts[:last], paginator.total_pages}
      num when is_number(num) -> {num, num}
    end) |> Enum.filter(&(&1))
  end

  # Computing page number ranges
  defp page_number_list(list, page, total, distance) when is_integer(distance) and distance >= 1 do
    list ++ Enum.to_list(beginning_distance(page, total, distance)..end_distance(page, total, distance))
  end

  defp add_first(page, distance, true) when page - distance > 1 do
    [1]
  end
  defp add_first(page, distance, first) when page - distance > 1 and first != false do
    [:first]
  end
  defp add_first(_page, _distance, _included) do
    []
  end

  defp add_next(list, page, total) when page != total and page < total do
    list ++ [:next]
  end
  defp add_next(list, _page, _total) do
    list
  end

  defp add_last(list, page, total, distance, true) when page + distance < total do
    list ++ [total]
  end
  defp add_last(list, page, total, distance, last) when page + distance < total and last != false do
    list ++ [:last]
  end
  defp add_last(list, _page, _total, _distance, _included) do
    list
  end

  defp add_first_ellipsis(list, page, total, distance, true) do
    add_first_ellipsis(list, page, total, distance + 1, nil)
  end

  defp add_first_ellipsis(list, page, _total, distance, _first) when page - distance > 1 and page > 1 do
    list ++ [:first_ellipsis]
  end
  defp add_first_ellipsis(list, _page_number, _total, _distance, _first) do
    list
  end

  # Adding next/prev/first/last links
  defp add_prev(list, page) when page != 1 do
    [:prev | list]
  end
  defp add_prev(list, _page) do
    list
  end

  defp safe({:safe, _string} = whole_string) do
    whole_string
  end
  defp safe(string) when is_binary(string) do
    string
  end
  defp safe(string) do
    string
    |> to_string()
    |> raw()
  end

  # Beginning distance computation
  # For low page numbers
  defp beginning_distance(page, _total, distance) when page - distance < 1 do
    page - (distance + (page - distance - 1))
  end
  # For medium to high end page numbers
  defp beginning_distance(page, total, distance) when page <= total  do
    page - distance
  end
  # For page numbers over the total number of pages (prevent DOS attack generating too many pages)
  defp beginning_distance(page, total, distance) when page > total do
    total - distance
  end

  # End distance computation
  # For high end page numbers (prevent DOS attack generating too many pages)
  defp end_distance(page, total, distance) when page + distance >= total and total != 0 do
    total
  end
  # For when there is no pages, cannot trust page number because it is supplied by user potentially (prevent DOS attack)
  defp end_distance(_page, 0, _distance) do
    1
  end
  # For low to mid range page numbers (guard here to ensure crash if something goes wrong)
  defp end_distance(page, total, distance) when page + distance < total do
    page + distance
  end

  defp add_last_ellipsis(list, page, total, distance, true) do
    add_last_ellipsis(list, page, total, distance + 1, nil)
  end
  defp add_last_ellipsis(list, page, total, distance, _) when page + distance < total and page != total do
    list ++ [:last_ellipsis]
  end
  defp add_last_ellipsis(list, _page_number, _total, _distance, _last) do
    list
  end
end
