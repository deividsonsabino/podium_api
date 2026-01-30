defmodule PodiumApiWeb.ChatController do
  use PodiumApiWeb, :controller

  def history(conn, _params) do
    json(conn, %{history: PodiumApi.ChatServer.get_history()})
  end

  def chat(conn, %{"message" => message}) when is_binary(message) do
    PodiumApi.ChatServer.add_message("User: " <> message)

    case PodiumApi.AIService.generate_response(message) do
      {:ok, reply} ->
        PodiumApi.ChatServer.add_message("AI: " <> reply)
        json(conn, %{reply: reply})

      {:error, reason, msg} ->
        PodiumApi.ChatServer.add_message("AI_ERROR: #{inspect(reason)} - #{msg}")

        conn
        |> put_status(:service_unavailable)
        |> json(%{error: inspect(reason), message: msg})
    end
  end

  def chat(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "missing or invalid 'message'"})
  end
end
