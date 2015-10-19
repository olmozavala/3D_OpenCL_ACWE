OenCL Active Contours Without edges
====

This is an OpenCL implementation that computes the 3D Active Contours Without Edges. 
The algorithm is from the paper "Active Contours Without Edges"
from Chan and Vase.

This work uses NiFTI images as input 3D data. The NiFTI images are
heavily used in the medical imaging field, specifically for breast DCE-MRI and fMRI data.
You can find a test image in the images folder. 

# Clone
This project uses a couple of wrappers and utilities that are available
at the OZlib repository and it also uses the Signed Distance Function
repo. In order for these submodules to be added to your cloned folder 
you need to: 

Do your normal cloning:

    git clone git@github.com:olmozavala/3D_OpenCL_ACWE.git

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

    up,down         Moves the ROI in the vertical direction (transverse plane). 
    left,right      Moves the ROI in the horizontal direction (coronal plane).
    Ctrl+up,        Moves the ROI in the Z direction (coronal plane).
    Ctrl+down
    I           Starts and stops the iteration of the segmentation algorithm.
    J           Toggles the visualization of the segmented region.
    P           Toggles the visualization scheme between orthogonal planes and ray casting.
    Q           Quits the application.
    S           Open the image selection dialog.
    T           Display the time taken to compute the last segmentation in the terminal.
    c,C         Moves the position of the transverse plane.
    x,X         Moves the position of the sagital plane.
    z,Z         Moves the position of the coronal plane.
    +,-         Increases and reduces the size of the ROI.
    1,2,3       Aligns the camera to the coronal, transverse, and sagital planes respectively.
                It also resets the position of the orthogonal planes to the center.
    9,0         Increases and reduces the brightness of the ray casting visualization scheme
            by 2%.

# Update submodules
If something gets updated into one of the repositories, you can
pull the changes by cd into the folder and doing normal pull.

    cd 3D_OpenCL_SDF
    git pull origin master
