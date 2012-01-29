# Install dependencies

node['packages'].each do |pkg,ver|
  package pkg do
    action :install
    version ver unless ver.empty?
  end
end

node['gems'].each do |gem,ver|
  gem_package gem do
    action :install
    version ver unless ver.empty?
  end
end

# Prepare deploy directory #

%w{ log pids system bundle }.each do |dir|
  directory "#{node['deploy_to']}/shared/#{dir}" do
    recursive true
  end
end

# Prepare to authenticate with Github #

cookbook_file "#{node['deploy_to']}/id_deploy"

template "#{node['deploy_to']}/deploy-ssh-wrapper" do
  mode "0755"
  variables :node => node
end

# Deploy application #

include_recipe 'git'

deploy_revision node['id'] do
  repository node['repository']
  deploy_to  node['deploy_to']
  ssh_wrapper "#{node['deploy_to']}/deploy-ssh-wrapper"
  action :force_deploy
  shallow_clone true
  symlink_before_migrate({})
  before_migrate do
    directory "#{release_path}/vendor"
    link "#{release_path}/vendor/bundle" do
      to "#{node['deploy_to']}/shared/bundle"
    end
    execute "bundle install --deployment" do
      cwd release_path
    end
  end
end

# Configure Nginx #

include_recipe 'nginx'

file "#{node[:nginx][:dir]}/sites-enabled/default" do
  action :delete
end

template "#{node[:nginx][:dir]}/sites-enabled/#{node['id']}" do
  source "nginx.conf.erb"
  variables :node => node
  notifies :restart, resources(:service => "nginx")
end

# Configure Unicorn #

unicorn_config "/etc/unicorn/#{node['id']}.rb" do
  listen({ 8080 => { :tcp_nodelay => true, :backlog => 100 } })
  working_directory ::File.join(node['deploy_to'], 'current')
  worker_timeout    60
  preload_app       false
  worker_processes  [node[:cpu][:total].to_i * 4, 8].min
end

template "upstart.conf" do
  path    "/etc/init/#{node['id']}.conf"
  source  "upstart.conf.erb"
  mode    0644
  variables :node => node
end

service node['id'] do
  provider Chef::Provider::Service::Upstart
  action :restart
end
