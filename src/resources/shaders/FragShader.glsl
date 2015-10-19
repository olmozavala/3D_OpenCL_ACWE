#version 400

//This one makes the interpolation 'smooth' it can be 'flat' or 'noperspective'
// but it needs to be the same as in the vertex shader
smooth in vec4 theColor;
smooth in vec3 textCoord; //This is the texture coordinate

uniform mat4 perspectiveMatrix;
uniform mat4 modelMatrix;
uniform int dispSegmentation;
uniform int drawPlanes;
uniform float decay;

//This part is for the textures
uniform sampler3D imgSampler;// Used to specify how to apply texture
uniform sampler3D segSampler;// Used to specify how to apply texture

layout (location = 0 ) out vec4 outputColor;

void main()
{
    vec3 currTextCoord = textCoord;
    vec4 textColor = vec4(0);

    float count = 100;
    float gamma = 4;

    float th= .001;//Threshold to detect when the coordinates are out of bounds

    //Directions are: (+R-L,+Near-Far,+Down-Up) but are been swapped below
    vec3 dir = vec3(0,0,-1/(count));
    mat4 swapMat= mat4(
            1.0, 0.0, 0.0, 0.0, // first column 
            0.0, 0.0, -1.0, 0.0, // second column
            0.0, 1.0, 0.0, 0.0, // third column
            0.0, 0.0, 0.0, 0.0);

    mat4 tempMat = swapMat * modelMatrix;

    vec4 finDir = tempMat * vec4(dir,1);

    vec3 maxCoords = vec3(1+th,1+th,1+th);
    vec3 minCoords=  vec3(-th,-th,-th);

    dir= finDir.xyz;
    float bthreshold = .5;// This is the threshold of the distance in the SDF to be displayed in red

    //In this case we are displaying four orthogona planes to visualize the 3D data
    if(drawPlanes == 1){
        textColor = texture(imgSampler, textCoord);
        outputColor = vec4(textColor.r, textColor.r, textColor.r, .5);
        // Move if outside the loop
        if(dispSegmentation == 1){
            vec4 mixVal = vec4(.5,.5, .5, .5); 
            textColor = texture(segSampler, currTextCoord);
            if( textColor.r >= -bthreshold && textColor.r <= bthreshold ){ // This is if we want just a red line in the contour
                    outputColor = mix(outputColor,vec4(0, 1, 0, 1),mixVal);
            }else{
                if(textColor.r <= bthreshold ){
                    outputColor = mix(outputColor,vec4(1, 0, 0, 1),mixVal);
                }
            }
        }
    }else{//In this case we are using the ray casting algorithm to display the results
        outputColor = vec4(0,0,0, .4);

        vec4 mixVal = vec4(.05,0.05, 0.05, 0); //How are we mixing the values 
        int firstNonTransparent= 0;
        
        //Iterate in the direction of the ray until we are outside the cube
        for(int i = 1; i < count; i++){
            //Update the coordinate of the texture incrementing the step of the vector.
            currTextCoord = currTextCoord + dir;

            //If we are out of bounds then we don't add anything
            if( any(greaterThan(currTextCoord, maxCoords)) ||
                 any(lessThan(currTextCoord, minCoords)) ){
                //break;
            }else{
                //Verify we are not out of bounds
                textColor = texture(imgSampler, currTextCoord);
                //if( (firstNonTransparent==0) && textColor.r > 0){
                if( textColor.r > 0){
                    firstNonTransparent = i;
                }
                if(firstNonTransparent > 0){
                    textColor.r = textColor.r*(decay/(i+2-firstNonTransparent));
                    outputColor = outputColor + vec4(textColor.r, textColor.r, textColor.r, 0);
                }
                // Move if outside the loop
                if(dispSegmentation == 1){
                    textColor = texture(segSampler, currTextCoord);
                    //if( (textColor.r <= bthreshold) && (textColor.r <= bthreshold)){
                    if( (textColor.r <= bthreshold) ){
                        outputColor = mix(outputColor,vec4(1, 0, 0, 0),mixVal);
                    }
                }
            }
        }
    }
}

