
# Purpose and Results

/MAT/LAW1: Elastoc Material Law using the Hook's law Model at one 4 noded shell elemenet 10x10mm, 1mm thickness, uniaxial tension.

This is the most basic fem model: Hooke's law
It exists in any solver and represents the starting poing of any nonlinear model.

Should be used with care in nonlinear applications, since large deformation can lead to very high stresses, 
where material behavior can become unstable.
In case of doubt, use an elasto-plastic material law, like LAW2 (Johnson-Cook model).

It contains out of 4 nodes, forming 1 shell element (10x10mm) und uniaxial-tension loading condition.


![image](Images/Stress_Strain_one_element_uniax_tension.png)
<figcaption align = "center"><b>Figure 1. (left) Von Mises stress (upper left) and Strain (lower left) vs. Time plot /MAT/LAW1</b></figcaption>
