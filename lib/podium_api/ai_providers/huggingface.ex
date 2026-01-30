defmodule PodiumApi.AIProviders.HuggingFace do
  @url "https://router.huggingface.co/v1/chat/completions"
  @model "HuggingFaceTB/SmolLM3-3B:hf-inference"

  def generate_response(message) when is_binary(message) do
    token = System.get_env("HF_API_TOKEN")

    headers = [
      {"Authorization", "Bearer #{token}"},
      {"Content-Type", "application/json"}
    ]

    history = PodiumApi.ChatServer.get_history()

    messages =
      [
        %{role: "system", content: "You are a helpful assistant."}
      ] ++
      Enum.map(history, fn msg ->
        cond do
          String.starts_with?(msg, "User: ") ->
            %{role: "user", content: String.replace_prefix(msg, "User: ", "")}

          String.starts_with?(msg, "AI: ") ->
            %{role: "assistant", content: String.replace_prefix(msg, "AI: ", "")}

        true ->
          %{role: "user", content: msg}
      end
    end)

    body =
      Jason.encode!(%{
        model: @model,
        messages: messages,
        temperature: 0.7
      })

    case HTTPoison.post(@url, body, headers, recv_timeout: 60_000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: resp}} ->
        case Jason.decode(resp) do
          {:ok, decoded} ->
            reply = get_in(decoded, ["choices", Access.at(0), "message", "content"]) || ""
            {:ok, reply}

          {:error, err} ->
            {:error, :bad_json, "decode error: #{inspect(err)}"}
        end

      {:ok, %HTTPoison.Response{status_code: s, body: resp}} ->
        {:error, {:http_error, s}, extract_error_message(resp)}

      {:error, %HTTPoison.Error{reason: r}} ->
        {:error, :network, inspect(r)}
    end
  end

  defp extract_error_message(resp) when is_binary(resp) do
    case Jason.decode(resp) do
      {:ok, %{"error" => %{"message" => msg}}} -> msg
      {:ok, %{"error" => msg}} -> msg
      {:ok, %{"message" => msg}} -> msg
      _ -> resp
    end
  end
end
