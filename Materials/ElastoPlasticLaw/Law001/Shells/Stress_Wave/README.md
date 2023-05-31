
# Purpose and Results

/MAT/LAW1: Elastoc Material Law using the Hook's law Model - Shell (4-node) elements

This is the most basic material model: Hooke's law
It exists in any solver and represents the starting poing of any nonlinear model.

Should be used with care in nonlinear applications, since large deformation can lead to very high stresses, 
where material behavior can become unstable.
In case of doubt, use an elasto-plastic material law, like LAW2 (Johnson-Cook model).

Application is for parts, which do NOT undergo large stresses and strains/deformations. 
Only acting as "kinetic energy container".

Purpose of this model is to be have an example of only few elements, showing the stress propagetion in an explicite analysis.

![image](/Materials/ElastoPlasticLaw/Law001/Shells/Stress_Wave/Images/Stress_wave.png)
<figcaption align = "center"><b>Figure 1. Von Mises stress [GPa] propagaion through a 1000 mm beam.</b></figcaption>

![image](/Materials/ElastoPlasticLaw/Law001/Shells/Stress_Wave/Images/Stress_wave.gif)
<figcaption align = "center"><b>Animation 1. Von Mises stress [GPa] propagaion through a 1000 mm beam.</b></figcaption>
