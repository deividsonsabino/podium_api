defmodule PodiumApi.AIService do
  def generate_response(message) do
    case System.get_env("AI_PROVIDER", "mock") do
      "hf" -> PodiumApi.AIProviders.HuggingFace.generate_response(message)
      _ -> PodiumApi.AIProviders.Mock.generate_response(message)
    end
  end
end
