defmodule PodiumApi.AIService do
  def generate_response(message) when is_binary(message) do
    # Simulação de latência de IA
    Process.sleep(800)

    cond do
      String.contains?(String.downcase(message), "hello") ->
        "Hello! How can I help you today?"

      String.contains?(String.downcase(message), "weather") ->
        "I don't have real-time data, but it looks sunny in the AI world ☀️"

      true ->
        "Interesting question about '#{message}'. Tell me more!"
    end
  end
end
