run Bezier.pde to start project in Processing
Use the two dropdown list to choose data and mode

Mode:
move  : click and drag to move a control point. 
             click on edge to add new control point
    If the click is not near any existing create new curve
    when adding new curve:  
        press number key to define degree
        click positions for next point until satisfied
        press ENTER to add the curve (if enough points for the degree), DELETE to discard
        
delete : click to delete a control point
3D view : switch to 3D view

Keyboard operation:

r  : reset to blank
p : toggle control polygon 
b : toggle bezier curve 
c : toggle control points
a : display all three above
n : display none of the three

w : write the current curves to folder "BsplineData/fitting_result/"

SHIFT : switch between 2D/3D view

in 3D view:
i   : zoom in
o  : zoom out
LEFT/RIGHT  : rotate around Y
UP/DOWN     : move along Y
