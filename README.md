# music-tools
a bunch of scripts I use to organize my music stuff

## sample-sorter

This is a small script that should take care of my sample library. 
You have to define a folder to search samples.
It will go in there and try to analyze the path of the sample.
The output is a directory tree containing well organized categories containing hard links
to the samples.

This script takes very long for big sample libraries.

## project-organizer

Is a bunch of scripts to organize my projects.

a project looks like this

    project-name
        ├── info         <- (optional) documentation about project
        ├── start.sh     <- script that starts the project (daw, synths, jack-snapshot)
        └── example.mp3  <- (optional) hearing example

* `project.rb` is the script to navigate and start the projects, which have a structure like that.
* `create_project` is a project where the `start.sh` creates a new project
* `example` belongs to `create_project` and should be put in `projects-folder/.example`
