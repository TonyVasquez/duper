defmodule Duper.WorkerSupervisor do
  use DynamicSupervisor

  @me __MODULE__

  def start_link(_), do: DynamicSupervisor.start_link(@me, :no_args, name: @me)

  def init(:no_args), do: DynamicSupervisor.init(strategy: :one_for_one)

  def add_worker do
    {:ok, _pid} = DynamicSupervisor.start_child(@me, Duper.Worker)
  end
end
