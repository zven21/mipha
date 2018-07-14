alias Mipha.{
  Repo,
  Accounts,
  Topics
}

alias Accounts.{User, Location, Company, Team}
alias Topics.{Topic, Node}

# Gen three locations
beijing = Repo.insert! %Location{name: "北京"}
hangzhou = Repo.insert! %Location{name: "杭州"}

helijia = Repo.insert! %Company{
  name: "河狸家",
  location: beijing
}

qhwa = User.register_changeset(%User{}, %{
  username: "qhwa",
  email: "qhwa@mipha.com",
  password: "123123123",
  is_admin: true,
  bio: Faker.Lorem.sentence(10),
  website: Faker.Internet.domain_name,
  github_handle: "qhwa",
  location_id: beijing.id,
  company_id: helijia.id
}) |> Repo.insert!

zven = User.register_changeset(%User{}, %{
  username: "zven",
  email: "zven@mipha.com",
  password: "123123123",
  bio: Faker.Lorem.sentence(10),
  website: Faker.Internet.domain_name,
  github_handle: "zven21",
  location_id: beijing.id,
  company_id: helijia.id
}) |> Repo.insert!

bencode = User.register_changeset(%User{}, %{
  username: "bencode",
  email: "bencode@mipha.com",
  password: "123123123",
  bio: Faker.Lorem.sentence(10),
  website: Faker.Internet.domain_name,
  github_handle: "bencode",
  location_id: hangzhou.id
}) |> Repo.insert!

# Gen teams helijia_web
Repo.insert! %Team{
  name: "helijia-web",
  summary: Faker.Lorem.sentence(10),
  owner: zven,
  github_handle: "helijia-web",
  avatar: Faker.Avatar.image_url,
  users: [qhwa, zven, bencode]
}

for parent_node <- ~w(ruby elixir erlang) do
  node = Repo.insert! %Node{
    name: parent_node,
    summary: Faker.Lorem.sentence(10),
    position: 1..10 |> Enum.random
  }
  for idx <- 1..5 do
    Repo.insert! %Node{
      name: "#{node.name}-node#{idx}",
      summary: Faker.Lorem.sentence(10),
      parent: node,
      position: 1..10 |> Enum.random
    }
  end
end

for _ <- 1..10 do
  sample_user = Repo.all(User) |> Enum.random
  sample_node = Repo.all(Node.is_child) |> Enum.random

  Repo.insert! %Topic{
    title: Faker.Lorem.sentence(10),
    body: Faker.Lorem.sentence(10),
    last_reply_user: sample_user,
    node: sample_node,
    type: Enum.random(~w(normal featured educational job)),
    user: Repo.all(User) |> Enum.random
  }
end