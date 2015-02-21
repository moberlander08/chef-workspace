#!/bin/bash
curl -L https://www.opscode.com/chef/install.sh | bash
chef-solo -c solo.rb -j terrepets.json
