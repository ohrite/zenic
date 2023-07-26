defmodule Zenic.Scenic do
  alias Scenic.{Graph, Primitive}
  alias Zenic.{Illustration, Camera}

  @spec illustration(
          source :: Graph.t() | Primitive.t(),
          {list(term), Camera.t()},
          options :: list
        ) :: Graph.t() | Primitive.t()
  def illustration(graph_or_primitive, data, opts \\ [])
  def illustration(%Graph{} = g, data, opts), do: add_to_graph(g, Illustration, data, opts)

  def illustration(
        %Primitive{module: Primitive.Component, data: {Illustration, _, _}} = p,
        data,
        opts
      ),
      do: modify(p, data, opts)

  @spec illustration_spec(list, options :: list) :: Graph.deferred()
  def illustration_spec(data, opts \\ []), do: &illustration(&1, data, opts)

  @spec renderable(
          source :: Graph.t() | Primitive.t(),
          module :: atom,
          data :: term,
          options :: list
        ) :: Graph.t() | Primitive.t()
  def renderable(%Graph{} = g, mod, data, opts), do: add_to_graph(g, mod, data, opts)
  def renderable(%Primitive{} = p, data, opts), do: modify(p, data, opts)

  @spec renderable_spec(module :: atom, term, options :: list) :: Graph.deferred()
  def renderable_spec(mod, data, opts), do: fn g -> renderable(g, mod, data, opts) end

  defp add_to_graph(%Graph{} = g, mod, data, opts) do
    data =
      case mod.validate(data) do
        {:ok, data} -> data
        {:error, error} -> raise Exception.message(error)
      end

    mod.add_to_graph(g, data, opts)
  end

  defp modify(%Primitive{module: Primitive.Component, data: {mod, _, id}} = p, data, options) do
    data =
      case mod.validate(data) do
        {:ok, data} -> data
        {:error, msg} -> raise msg
      end

    Primitive.put(p, {mod, data, id}, options)
  end

  defp modify(%Primitive{module: mod} = p, data, opts) do
    data =
      case mod.validate(data) do
        {:ok, data} -> data
        {:error, error} -> raise Exception.message(error)
      end

    Primitive.put(p, data, opts)
  end
end
