defmodule Example.PubSub.Frame do
  use GenServer

  alias Scenic.PubSub

  @name :frame
  @version "1.0.0"
  @description "Global animation frame counter"

  @timer_ms div(1000, 30)

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: @name)

  def init(_) do
    PubSub.register(:frame, version: @version, description: @description)
    PubSub.publish(:frame, 0)
    {:ok, timer} = :timer.send_interval(@timer_ms, :tick)
    {:ok, %{timer: timer, frame: 0}}
  end

  def handle_info(:tick, %{frame: frame} = state) do
    PubSub.publish(:frame, frame)

    {:noreply, %{state | frame: frame + 1}}
  end
end
