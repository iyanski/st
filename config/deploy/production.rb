set :stage, :production

server "smalltaskers.net", user: "ec2-user", roles: %w{app db web}

role :app, %w{ec2-user@smalltaskers.net}
role :web, %w{ec2-user@smalltaskers.net}
role :db,  %w{ec2-user@smalltaskers.net}

set :ssh_options, {
  forward_agent: true,
  auth_methods: ["publickey"],
  keys: [`ls $HOME/.ssh/smalltaskers.pem`.chomp]
}