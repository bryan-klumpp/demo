#https://www.google.com/search?q=Error%3A+Could+not+find+the+%27%40angular-devkit%2Fbuild-angular%3Akarma%27+builder%27s+node+package.&oq=Error%3A+Could+not+find+the+%27%40angular-devkit%2Fbuild-angular%3Akarma%27+builder%27s+node+package.&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBBzMxMGowajmoAgCwAgE&sourceid=chrome&ie=UTF-8

rm -rf node_modules
    rm package-lock.json
    npm cache clean --force
    npm install

        npm uninstall @angular-devkit/build-angular
    npm install @angular-devkit/build-angular@latest

#if it persists...
        ng update @angular/cli @angular/core --allow-dirty --force

        #if legaciy issues still...
            npm install --legacy-peer-deps