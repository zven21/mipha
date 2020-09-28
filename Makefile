# code helper
iex:
	iex --erl "-kernel shell_history enabled" -S mix
serve:
	iex --erl "-kernel shell_history enabled" -S mix phx.server
credo:
	mix credo --strict
coveralls:
	mix coveralls

# docker helper
start.pg:
	docker-compose -f docker/docker-compose.yml up -d