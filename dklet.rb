#!/usr/bin/env rundklet
add_note <<~Note
  docker nodejs
  https://github.com/nodejs/docker-node
  https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md
Note

register :appname, 'nodejs10'

write_dockerfile <<~Desc
  FROM node:10.13-alpine
  LABEL <%=image_labels%>
  ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
  ENV PATH=$PATH:/home/node/.npm-global/bin 
  WORKDIR /src
Desc

task :main do
  system_run <<~Desc
    #{dkrun_cmd(named: true)} -d \
      -p 3000 \
      -v #{script_path}:/src \
      #{docker_image} node server.js
  Desc
  # -u node ?
end

custom_commands do
  desc 'hi', 'say hi'
  def hi
    system_run <<~Desc
      curl #{host_with_port_for(3000)}
    Desc
  end

  desc 'nodesh', 'interactive mode with node loaded'
  def nodesh
    container_run "node"
  end
  map 'cli' => 'nodesh'

  desc 'test', 'test inline'
  def test
    container_run <<~Desc
      cat <<-Script | node
        console.log("Hi Nodejs")
      Script
    Desc
  end

  desc 'npm_version', ''
  def npm_version
    container_run "npm version"
  end

  desc 'es6', 'ES6 support table'
  def es6
    puts <<~Desc
      https://nodejs.org/en/docs/es6/
      https://fhinkel.rocks/six-speed/
      https://node.green/
    Desc
  end

  desc 'v8opts', ''
  def v8opts
    # node --v8-options | grep "in progress"
    container_run "node --v8-options"
  end

  #list all dependencies and respective versions that ship with a specific binary through the process global object. In case of the V8 engine, type the following in your terminal to retrieve its version:
  desc 'deps', ''
  def deps
    container_run "node -p process.versions"
    # https://nodejs.org/en/docs/meta/topics/dependencies/
  end

  desc '', 'show json module read json data'
  def jsonmodule
    container_run <<~Desc
      node jsonmodule.js
    Desc
  end

  desc '', ''
  def module_private
    container_run <<~Desc
      cd try/module-private
      node module2.js
    Desc
  end
end

__END__

node --help
node --check
node -i / --interactive
node -r / --require
node -e / -p

NODE_PATH  #module search path
NODE_ENV=production

brew install node@10

# YARN: node package management
brew install yarn
yarn global add webpack
#export PATH="$PATH:`yarn global bin`"


ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin # optionally if you want to run npm global bin without specifying path


ENV YARN_VERSION 1.5.1
RUN apk add --no-cache --virtual .build-deps-yarn curl \
    && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -snf /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz \
    && apk del .build-deps-yarn

docker run \
  -e "NODE_ENV=production" \
  -u "node" \
  -m "300M" --memory-swap "1G" \
  -w "/home/node/app" \
  --name "my-nodejs-app" \
  node [script]
