defmodule PodiumApi.AIProviders.Mock do
  def generate_response(message) when is_binary(message) do
    Process.sleep(200)
    {:ok, "MOCK reply to: #{message}"}
  end
end
