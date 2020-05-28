//filled with chemical b, adding chemical a
//black = chemical a present in vast quantities
/*
Algorithm: 
2 dimensional array tracks each cell 
each cell has chemical a and b
new value of a is equal to some function with input a_0 and b_0
apply convolution to each cell, or a 3 x 3 matrix
new pixel created by weights of surrounding pixels using the formula
*/

var grid; 
var next; 

function setup(){
    createCanvas(400, 400); 
    pixelDensity(1); 
    grid = []; 
    next = []; 
    for (var x = 0; x < width; x++){
        grid[x] = []; 
        next[x] = []; 
        for(var y = 0; y < height; y++){
            grid[x][y] = {a: random(1), b: random(1)}; 
            next[x][y] = {a: 0, b: 0}
        }
    }
}

function draw(){
    background(51); 

    loadPixels(); 
    for (var x = 0; x < width; x++){
        for(var y = 0; y < height; y++){
            var c = color(255, 0, 100); 
            var pix = (x + y * width)*4
            pixels[pix + 0] = floor(grid[x][y].a*255);  
            pixels[pix + 1] = 0; 
            pixels[pix + 2] = floor(grid[x][y].b*255); 
            pixels[pix + 3] = 255; 
        }
    }
    updatePixels(); 
}
