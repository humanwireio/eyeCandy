# what is it
###imagine…
You're in a room with thirty other people.
Your phone is in your hand and your browser is open to a website, as is every other person's. The exact page (selected from a root directory page) determines what part of a complex visual on the wall you are controlling. If you leave that page the pattern you were controlling before disappears and will be replaced by a new pattern once you navigate to a new page.

You can try it out right now on your computer!

####donate

If you like what you see here, help me fund this puppy

####types of interaction

Because processing and node have libraries galore, it's easy to add almost any type of interaction.

By default we use [jquery-kontrol](http://anthonyterrien.com/kontrol/) for xypads, sliders, knobs but any library that can be dropped in will work (think webcams, accelerometers, etc.)

# how it works
The website you are accessing is being run on a node.js server, which in turn is sending open sound control (OSC) messages to a processing sketch telling it when y-axesou visit pages and interact with elements of the site. In response the processing sketch produces sweet visuals based on this  information like this!

Because the OSC server (processing) can receive messages from anyone

# dependencies
Install these guys first:

* node
  * node modules?
* processing (v?)
  * osc lib
  * other libs?
  * processing-java command line (installable from tools menu in processing gui)
* screen (optional, can just run webserver in the background using &)

# how to use
These directions assume both the node.js webserver server and processing are running on the same machine. 

* check the ip address (you'll need that soon) `ifconfig`
* clone the repo using
`git clone https://github.com/humanwireio/eyeCandy/`
* start the node server
```
cd eyeCandy/webserver;
screen -d -m node server.js
```

* start processing
```
cd ../viz;
processing projectorPlatform.pde
```

Done setting up now lets use it!

* Go to the ip address of the computer running the node server in a browser on any device capable of pinging that computer (probably on the local network).
* As you navigate the pages you should see the image change in processing. 


# contributing and bugs
Feel free to make pull requests or drop a line to [humanwire.io@gmail.com](mailto://humanwire.io@gmail.com) regarding this code. I plan to work on standardizing the osc addresses to work for any patch, cleaning up the folder structure, and creating a config file and parser. I'll also be updating some webcam code to create an example of a patch generated from a cam.


# credits
* web-osc node example
* [mathographics](http://www.amazon.com/Mathographics-Robert-Dixon/dp/B00AK2VKNO/ref=sr_1_1?ie=UTF8&qid=1408638440&sr=8-1&keywords=mathographics)
