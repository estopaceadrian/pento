defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_default_values()
      |> assign_answer()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..5 do %>
        <.link href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <button
      class="bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white py-2 px-4 border border-blue-500 hover:border-transparent rounded"
      type="button"
      phx-click="reset"
    >
      Reset
    </button>
    """
  end

  defp assign_default_values(socket) do
    assigns = %{
      score: 0,
      message: "Make a guess:"
    }

    assign(socket, assigns)
  end

  defp assign_answer(socket) do
    assign(socket, answer: get_answer())
  end

  def handle_event("reset", _params, socket) do
    socket =
      socket
      |> assign_default_values()
      |> assign_answer()

    {:noreply, socket}
  end

  def handle_event("guess", %{"number" => guess}, %{assigns: assigns} = socket) do
    guess_num = String.to_integer(guess)
    correct? = guess_num == assigns.answer

    {updated_score, updated_message, updated_answer} =
      result(correct?, assigns.score, guess_num, assigns.answer)

    assigns = %{
      message: updated_message,
      score: updated_score,
      answer: updated_answer
    }

    {:noreply, assign(socket, assigns)}
  end

  defp result(correct?, score, guess, answer)
       when is_boolean(correct?) and is_number(score) and is_number(guess) and is_number(answer) do
    if correct?,
      do: {score + 1, "Your guess #{guess}. Correct.", get_answer()},
      else: {score - 1, "Your guess #{guess}. Wrong.", answer}
  end

  defp result(_correct?, score, _guess, answer),
    do: {score, "Type is incorrect", answer}

  defp get_answer(), do: Enum.random(1..5)
end
