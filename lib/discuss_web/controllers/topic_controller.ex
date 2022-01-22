defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias DiscussWeb.Topic
  alias Discuss.Repo

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  @spec create(any, any) :: nil
  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset %Topic{}, topic
    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def index(conn, _params) do
    render conn, "index.html", topics: Repo.all Topic
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render conn, "edit.html", topic: topic, changeset: changeset
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)
    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset
    end
  end
end
