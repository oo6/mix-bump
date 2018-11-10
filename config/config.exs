# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :mix_bump,
  command_adapter: MixBump.Command.Shell

import_config "#{Mix.env()}.exs"
