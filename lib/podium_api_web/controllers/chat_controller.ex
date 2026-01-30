defmodule PodiumApiWeb.ChatController do
  use PodiumApiWeb, :controller

  def history(conn, _params) do
    json(conn, %{history: PodiumApi.ChatServer.get_history()})
  end

  def chat(conn, %{"message" => message}) when is_binary(message) do
    PodiumApi.ChatServer.add_message("User: " <> message)

    response = PodiumApi.AIService.generate_response(message)

    PodiumApi.ChatServer.add_message("AI: " <> response)

    json(conn, %{reply: response})
  end

  def chat(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "missing or invalid 'message'"})
  end
end
