if node['php']['ius'] != false and platform?("redhat", "centos", "fedora", "amazon", "scientific")
  include_recipe "yum::ius"
end

if node['php']['ius'] == "5.4"
  centos_packages = %w{ php54 php54-devel php54-cli php54-pear }
elsif node['php']['ius'] == "5.3"
  centos_packages = %w{ php53u php53u-devel php53u-cli php53u-pear }
else
  centos_packages = %w{ php php-devel php-cli php-pear }
end

bash "update_php_sources" do
   cwd "/"
   code <<-EOH
        sudo apt-get -y install -y python-software-properties;
        sudo add-apt-repository ppa:ondrej/php5;
        sudo apt-get update -y;
        sudo apt-get install php5 php5-cli php5-dev php5-common php-pear -y;
     EOH
end

#pkgs.each do |pkg|
#  package pkg do
#    action :install
#  end
#end

template "#{node['php']['conf_dir']}/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :params => node['php']
  )
end
