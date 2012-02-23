The Gor.js Project Template

## Why?
Have you ever asked yourself what is the best way to structure your Node.js+Ember.js project?

## So...
Gor.js is a project template that provides structure, tooling and stencils for Node.js+Ember.js-based projects.

Gor.js can help you kickstart your next project, adding Bootstrap, Express and Mongoose to the mix (but these can easily be replaced).

## Is it production-ready?
Well, probably not yet..

## Never mind, I'm in...
Begin by cloning Gor.js to generate your project root folder:

	git clone https://github.com/markingstone/gor.js myproj

Now, `cd` to `myproj` and initialize your app:

    make init prefix=MyApp title="Hello World"
    make all

Let's see if everything is in order. Run the Gor.js node server:

    node system/server.js

Point your browser to `localhost:9999`. You should see a blank Bootstrap page with your application title.

Let's try to generate a simple scaffold:

    make scaffold for=book
    make all

After refreshing the page you should see a new menu item and the scaffold default table.

## How everything works?

Let start digging into the Gor.js structure and machinery.

### Project Structure

The Gor.js template structure was meant to be both developer-friendly and technically aesthetic. The top-level folders are:

	[myproj]
		[source]
		[public]
		[vendor]
        [stencils]

Stuff you write and maintain on a usual basis goes into `source`. This is where you should `cd` and `vim` in. Working inside `source` will eliminate the clutter away from tools such as Command-T without forcing you to define ignore masks etc..

Stuff you want to let your http server see goes into `public`. Gor.js will automatically generate your index.html and app.js files (more on this later..)

External libraries and toolkits goes into `vendor`. This is where you'll `git submodule add` your external dependencies. Gor.js will put _Ember.js_ _Bootstrap_ and _JQuery_ in once you `make init` your project.

Last but not least, the `stencils` folder holds template files that Gor.js will use to help you kickstart views, controllers, templates and other pieces of code.

### Deeper into the rabbit hole... 

Let's examine what goes under `myproj/source`:

	[myproj]
		[source]
            [app.ember]
                [controllers]
                [layouts]
                    application.html
                [libs]
                [models]
                [templates]
                [views]
                app.js
            [app.node]
                [handlers]
                [schema]
                server.js
            [tests.mocha]
            Makefile

When working inside `myproj/source` you can use the Gor.js Makefile to perform various tasks such as generating stencils code or building your public assets.

Some clarifications though:

`source/app.ember` - Ember.js client-side code

`source/app.ember/layouts/application.html` - the index.html base file. Running `make html` will use this file to generate the full `index.html`.

`source/app.ember/app.js` - the boilerplate app.js file. This is _not_ the final app.js file. Running `make app.js` will generate the full app.js.

`source/app.node` - Node.js server side code

`source/app.node/handlers` - Express.js REST API handlers

`source/app.node/schema` - Mongoose schema files for your model

`source/app.node/server.js` - The Gor.js server. You can use `node app.node/server.js` to run or use your favorite node runner (for example, _always_) to run.

### Generating index.html and app.js

To generate your index.html and app.js files, use:

    make html
    make app.js

or simply:

    make all

### Stenciling

You can use the Makefile stenciling recipes to generate boilerplate code for your app. To generate the complete set of assets for a single resource use:

    make scaffold for=book

Gor.js will then invoke a set of stencil recipes that will generate a controller, a model, a set of views, menu item and a node express.js api handlers. Running `make scaffold` is equivalent to running:

    make stencil model=book
    make stencil view=book
    make stencil controller=book
    make stencil api=book
    make stencil test=book

Don't forget to regenerate your assets:

    make all


## Vim shortcuts

When working with Vim, you can create a nice shortcut to save and rebuild your assets after you change one of your Ember.js related source files:

    :map ,w :w\|:silent !make all<cr>\|redraw!<cr>

Now, instead of using :w use ,w to save and rebuild your assets.

