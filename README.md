The Gor.js Project Template

## Why?
Have you ever asked yourself what is the best way to structure your Node.js+Ember.js project?

## So...
Gor.js is a project template that provides structure, tooling and stencils for Node.js+Ember.js-based projects.

Gor.js can help you kickstart your next project, adding Bootstrap, Express and Mongoose to the mix (but these can easily be replaced).

## Is it production-ready?
Not really. Gor.js is still mostly work-in-progress.

## Never mind, I'm in...
You'll need to have Node.js installed and a MongoDB server running.

Begin by cloning Gor.js to generate your project root folder:

	git clone https://github.com/markingstone/gor.js myproj

You can also just download and extract a zipball.

Now, `cd` to `myproj` and initialize your app:

    make init prefix=MyApp title="Hello World"
    make all

Let's see if everything is in order. Run the Gor.js node server:

    node source/app.node/server.js

Point your browser to `localhost:9999`. You should see a blank Bootstrap page with your application title.

Let's try to generate a simple scaffold:

    make scaffold for=unicorn
    make all

After refreshing the page you should see a new menu item and the scaffold default table.

## How everything works?

Let take a closer look at the Gor.js structure and machinery.

### Project Structure

The Gor.js template structure was meant to be both developer-friendly and technically aesthetic. The top-level folders are:

	[myproj]
		[source]
		[public]
		[vendor]
        [stencils]
        Makefile

Stuff you write and maintain on a usual basis goes into `source`. This is where you should `cd` and `vim` in. Working inside `source` will eliminate the clutter away from tools such as Command-T without forcing you to define ignore masks etc..

Stuff you want to let your http server see goes into `public`. Gor.js will automatically generate your index.html and app.js files (more on this later..)

External libraries and toolkits goes into `vendor`. This is where you'll `git submodule add` your external dependencies. Gor.js will put _Ember.js_ _Bootstrap_ and _JQuery_ in there once you `make init` your project.

The `stencils` folder holds template files that Gor.js will use to help you kickstart views, controllers, templates and other pieces of code.

And last but not least, the Gor.js `Makefile`. You can use its recipes to perform various tasks such as stenciling pieces of code or building your public assets. 

### Some more detail...

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
            Makefile.inc


Some clarifications:

* `source/app.ember` - Your Ember.js client-side code goes in here.

* `source/app.ember/layouts/application.html` - The index.html base file. Running `make html` will use this file to generate the full `index.html`.

* `source/app.ember/app.js` - The base app.js file. This is _not_ the final app.js file. Running `make app.js` will generate the full app.js.

* `source/app.node` - Node.js server side code

* `source/app.node/handlers` - Express REST API handlers

* `source/app.node/schema` - Mongoose schema files for your model

* `source/app.node/server.js` - The Gor.js server. You can use `node source/app.node/server.js` to run it or use your favorite node runner (for example, _always_).

### Generating index.html and app.js

To generate your index.html and app.js files, use:

    make html
    make app.js

or simply:

    make all

### Stenciling

You can use the Makefile stenciling recipes to generate code for your app. To generate the complete set of assets for a single resource use:

    make scaffold for=book

Gor.js will then invoke a set of stencil recipes that will generate a controller, a model, a set of views, menu item and an Express REST API handlers. Running `make scaffold` is equivalent to running:

    make stencil model=book
    make stencil view=book
    make stencil controller=book
    make stencil api=book
    make stencil test=book

Don't forget to regenerate your assets:

    make all

You should feel comfortable changing the template files based on your needs and style. For instance, you may want to use a more DRY method for accessing your API server, or perhaps use ember-data or ember-rest.


### Handlebars Templates and Ember Views

When regenerating your assets, the Gor.js Makefile concatenates your Handlebars templates and builds the complete `index.html` file. When doing so Gor.js follows the convention of naming these templates by joining the leaf folder name with the template base filename. So for example, if you have the following templates:

    [myproj]
        [source]
            [app.ember]
                [templates]
                    [unicorns]
                        form.hb.html
                        list.hb.html
                    [dragons]
                        list.hb.html
                        item.hb.html

The templates for Ember.js will be rendered as:

    <script type="text/x-handlebars" data-template-name="unicorns-form">
        ...
    </script>

    <script type="text/x-handlebars" data-template-name="unicorns-list">
        ...
    </script>

    <script type="text/x-handlebars" data-template-name="dragons-list">
        ...
    </script>

    <script type="text/x-handlebars" data-template-name="dragons-item">
        ...
    </script>

## Vim shortcuts

When working with Vim, you can create a nice shortcut to save and rebuild your assets after you change one of your Ember.js related source files:

    :map ,w :w\|:silent !cd ..; make all<cr>\|redraw!<cr>

Now, instead of using :w use ,w to save and rebuild your assets.

## TBD
* Makefile vs Javascript
* Integrate with ember-data?
* Authentication boilerplate?
* (your own ideas...)
