set :stage, :production

server "smalltaskers.com", user: "ec2-user", roles: %w{app db web}

role :app, %w{ec2-user@smalltaskers.com}
role :web, %w{ec2-user@smalltaskers.com}
role :db,  %w{ec2-user@smalltaskers.com}

set :ssh_options, {
  forward_agent: true,
  auth_methods: ["publickey"],
  keys: [`ls $HOME/.ssh/smalltaskers.pem`.chomp]
}