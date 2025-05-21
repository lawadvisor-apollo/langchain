defmodule LangChain.Utils.VertexConfig do
  @moduledoc """
  Configuration for Google Vertex.

  ## Examples

  You'll need to manually include the google api_key and endpoint in the request.

      api_key = Goth.fetch!(GCP.Goth).token
      endpoint = "https://us-west2-aiplatform.googleapis.com/v1/projects/chat-project/locations/us-west2"

      ChatAnthropic.new!(%{
        vertex: %{
          endpoint: endpoint,
          api_key: api_key
        },
        model: "publishers/anthropic/models/claude-3-5-sonnet-v2"
      })

  """
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  @primary_key false
  embedded_schema do
    field :api_key, :any, virtual: true
    field :endpoint, :string
    field :anthropic_version, :string, default: "vertex-2023-10-16"
  end

  @type t :: %VertexConfig{}

  @create_fields [:api_key, :endpoint, :anthropic_version]
  @required_fields @create_fields

  def changeset(vertex, attrs) do
    vertex
    |> cast(attrs, @create_fields)
    |> validate_required(@required_fields)
  end

  def url(%VertexConfig{endpoint: endpoint}, model: model, stream: stream) do
    "#{endpoint}/#{model}:#{action(stream: stream)}"
  end

  defp action(stream: true), do: "streamPredict"
  defp action(stream: false), do: "rawPredict"
end
