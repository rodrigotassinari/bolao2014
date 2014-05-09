set :stage, :production

set :ssh_options, {forward_agent: true, port: Integer(ENV.fetch('CAP_SSH_PORT', 22))}

server ENV['CAP_SERVER'], user: ENV['CAP_USER'], roles: %w{app web db}
