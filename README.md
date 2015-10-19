OenCL Active Contours Without edges
====

This is an OpenCL implementation that computes the 2D Active Contours Without Edges. 
The algorithm is from the paper "Active Contours Without Edges"
from Chan and Vase.

# Clone
This project uses a couple of wrappers and utilities that are available
at the OZlib repository and it also uses the Signed Distance Function
repo. In order for these submodules to be added to your cloned folder 
you need to: 

Do your normal cloning:

    git clone git@github.com:olmozavala/2D_OpenCL_ACWE.git

Then you cd into the folder and add the submodules with:
    
    git submodule update --init --recursive

# Build
This code has been tested with different flavors of Ubuntu and Nvidia cards. 
It uses the FreeImage library for image manipulation, premake4
to build the submodules projects, and OpenGL and GLEW to display the results.
In ubuntu these libraries can be installed with:

    sudo apt-get install premake4 libfreeimage3 libfreeimage-dev freeglut-dev libglew-dev
    
Verify that the path of OPENCL in the 'Project.pro' file
and the premake4.lua file inside the SDF repo
corresponds to the location of your opencl installation. In my case
it is set to '/usr/local/cuda'.

First  compile the submodules with:

    sh submodules_compile.sh

Then compile the code with:

    make clean
    qmake Project.pro
    make
    make config=release ---> If you don't want debugging text

Or using the bash scripts:

    sh compile.sh

# Run
Run the program with:

     ./dist/RunActiveContoursQt 

Or with the script file

    sh run.sh


# Options
This program have some options that didn't make to the top menus and 
are very important:

    'I' -> To start and stop iterations of the algorithm (once the ROI has been selected) 
    'B' -> To alternate between using all or one of the image channesl
    'S' -> Selects a new image. 

# Update submodules
If something gets updated into one of the repositories, you can
pull the changes by cd into the folder and doing normal pull.

    cd 2D_OpenCL_SDF
    git pull origin master
