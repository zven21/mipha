alias Mipha.{
  Repo,
  Accounts,
  Topics,
  Replies
}

alias Accounts.{User, Location}
alias Topics.{Topic, Node}
alias Replies.Reply

# Gen three locations
beijing = Repo.insert! %Location{name: "北京"}
hangzhou = Repo.insert! %Location{name: "杭州"}

qhwa = User.register_changeset(%User{}, %{
  username: "qhwa",
  email: "qhwa@mipha.com",
  password: "123123123",
  avatar: Faker.Avatar.image_url,
  is_admin: true,
  bio: Faker.Lorem.sentence(10),
  website: Faker.Internet.domain_name,
  github_handle: "qhwa",
  location_id: beijing.id

}) |> Repo.insert!

zven = User.register_changeset(%User{}, %{
  username: "zven",
  email: "zven@mipha.com",
  password: "123123123",
  avatar: Faker.Avatar.image_url,
  bio: Faker.Lorem.sentence(10),
  website: Faker.Internet.domain_name,
  github_handle: "zven21",
  location_id: beijing.id
}) |> Repo.insert!

dayu = User.register_changeset(%User{}, %{
  username: "bencode",
  email: "bencode@mipha.com",
  password: "123123123",
  avatar: Faker.Avatar.image_url,
  bio: Faker.Lorem.sentence(10),
  website: Faker.Internet.domain_name,
  github_handle: "bencode",
  location_id: hangzhou.id
}) |> Repo.insert!

for parent_node <- ~w(ruby elixir) do
  node = Repo.insert! %Node{
    name: parent_node,
    summary: Faker.Lorem.sentence(10),
    position: 1..10 |> Enum.random
  }
  for idx <- 1..10 do
    Repo.insert! %Node{
      name: "#{node.name}-node#{idx}",
      summary: Faker.Lorem.sentence(10),
      parent: node,
      position: 1..10 |> Enum.random
    }
  end
end

for _ <- 1..50 do
  sample_user = Repo.all(User) |> Enum.random
  sample_node = Repo.all(Node.is_child) |> Enum.random

  Repo.insert! %Topic{
    title: Faker.Lorem.sentence(10),
    body: Faker.Lorem.sentence(10),
    last_reply_user: sample_user,
    node: sample_node,
    reply_count: 1..50 |> Enum.random,
    visit_count: 1..50 |> Enum.random,
    user: Repo.all(User) |> Enum.random,
    replies: [
      %Reply{
        content: Faker.Lorem.paragraph(3),
        user: Repo.all(User) |> Enum.random
      }
    ]
  }
end