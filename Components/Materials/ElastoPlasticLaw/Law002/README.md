
# Results

/MAT/LAW2: Elasto-plastic Material Law using the Johnson-Cook Model

The stress versus plastic strain law is: (Equation 10)
![image](Images/equation10.png)

If the material parameters b and n are not available, then OpenRadioss can use /MAT/LAW2, Iflag = 1. In this case, the UTS (Ultimate tensile strength, engineering value) and engineering strain at UTS are entered. These values can often be found online, in literature or from a material supplier. OpenRadioss will then calculate the b and n parameters used in the Equation (Equation 10).

Normally if a real test stress-strain curve exists, the test data should be used in /MAT/LAW36 (PLAS_TAB). However, in this example, you will assume that the test curve is not available and use /MAT/LAW2 with Iflag = 1 to see how well using the simplified data input compares to the actual test curve.

![image](Images/equation12.png)

Since the simulation calculates true stress and true strain for the elements, the engineering stress-strain curve from the simulation must be calculated. Similar to the test, the engineering stress can be calculated by using the Engineering nominal stress equation (Equation 1) and the rigid body force and original area. The engineering strain can be calculated by using total Engineering Strain equation (Equation 2) and the displacement between the two measurement nodes and the original distance. In the model, the displacement of node 616 is measure with respect to the displacement of node 102 by using a local moving system placed at node 102. This allows the displacement between the two nodes to be output as the displacement of node 616.

Comparing the simulation results of the stress-strain curve show a perfect agreement with respect to the maximum stress value of the tested curve. The initial behavior of the simulation curve before the necking point shows differences to the test curve (Figure 6) and the stress value is slightly higher. This can be improved by using /MAT/LAW36 and inputting the stress-strain curve test data.

![image](Images/figure6.png)
<figcaption align = "center"><b>Figure 1. Comparison of Results using /MAT/LAW2 and the real-world-test.</b></figcaption>
