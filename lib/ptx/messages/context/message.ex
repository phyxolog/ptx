defmodule Ptx.Messages.Context.Message do
  @moduledoc """
  The Message context.
  """

  defmacro __using__(_) do
    quote do
      alias Ptx.Repo
      alias Ptx.Messages.Message
      require OK

      @doc """
      Mark message as read.
      """
      def read_message(message, fun) do
        if !message.readed do
          ## First off, update message.
          {:ok, message} = update_message(message, %{
            readed: true,
            first_readed_at: NaiveDateTime.utc_now()
          })

          ## Then, call function where we will call a broadcast
          fun.({:first_time, message})

          ## Message as result
          message
        else
          fun.({:once_again, message})
        end
      end

      @doc """
      Returns recipient. If message have > 1 recipients - return nil,
      because we don't know, who of them really readed message.
      """
      def get_message_recipient(%Message{recipients: recipients})
        when length(recipients) == 1, do: hd(recipients)
      def get_message_recipient(_message), do: nil

      def fetch_message(opts) do
        Message
        |> where(^opts)
        |> limit(1)
        |> Repo.one()
        |> OK.required(:not_found)
      end

      @doc """
      Returns the list of messages.

      ## Examples

          iex> list_messages()
          [%Message{}, ...]

      """
      def list_messages do
        Repo.all(Message)
      end

      @doc """
      Gets a single message.

      Raises `Ecto.NoResultsError` if the Message does not exist.

      ## Examples

          iex> get_message!(123)
          %Message{}

          iex> get_message!(456)
          ** (Ecto.NoResultsError)

      """
      def get_message!(id), do: Repo.get!(Message, id)

      def get_message(id) do
        Message
        |> where(id: ^id)
        |> limit(1)
        |> Repo.one()
        |> OK.required(:not_found)
      end

      @doc """
      Creates a message.

      ## Examples

          iex> create_message(%{field: value})
          {:ok, %Message{}}

          iex> create_message(%{field: bad_value})
          {:error, %Ecto.Changeset{}}

      """
      def create_message(attrs \\ %{}) do
        %Message{}
        |> Message.changeset(attrs)
        |> Repo.insert()
      end

      @doc """
      Similar to create_message/1, but change sender_id to user id.
      """
      def create_message(attrs, user) do
        attrs
        |> Map.put("sender_id", user.id)
        |> create_message()
      end

      @doc """
      Updates a message.

      ## Examples

          iex> update_message(message, %{field: new_value})
          {:ok, %Message{}}

          iex> update_message(message, %{field: bad_value})
          {:error, %Ecto.Changeset{}}

      """
      def update_message(%Message{} = message, attrs) do
        message
        |> Message.changeset(attrs)
        |> Repo.update()
      end

      @doc """
      Deletes a Message.

      ## Examples

          iex> delete_message(message)
          {:ok, %Message{}}

          iex> delete_message(message)
          {:error, %Ecto.Changeset{}}

      """
      def delete_message(%Message{} = message) do
        Repo.delete(message)
      end

      @doc """
      Returns an `%Ecto.Changeset{}` for tracking message changes.

      ## Examples

          iex> change_message(message)
          %Ecto.Changeset{source: %Message{}}

      """
      def change_message(%Message{} = message) do
        Message.changeset(message, %{})
      end
    end
  end
end
