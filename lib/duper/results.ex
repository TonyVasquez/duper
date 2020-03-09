defmodule Duper.Results do
  use GenServer

  @me __MODULE__

  # API
  def start_link(_), do: GenServer.start(@me, :no_args, name: @me)

  def add_hash_for(path, hash), do: GenServer.cast(@me, {:add, path, hash})

  def find_duplicates, do: GenServer.call(@me, :find_duplicates)

  # Server
  def init(:no_args), do: {:ok, %{}}

  def handle_cast({:add, path, hash}, results) do
    results = Map.update(results, hash, [path], &[path | &1])
    {:noreply, results}
  end

  def handle_call(:find_duplicates, _from, results) do
    {:reply, hashes_with_more_than_one_path(results), results}
  end

  defp hashes_with_more_than_one_path(results) do
    results
    |> Enum.filter(fn {_hashe, paths} -> length(paths) > 1 end)
    |> Enum.map(&elem(&1, 1))
  end
end
