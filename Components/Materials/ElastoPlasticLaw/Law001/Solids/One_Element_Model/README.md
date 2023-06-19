
# Purpose and Results

/MAT/LAW1: Elastoc Material Law using the Hook's law Model - Solids (Hexa) elements

This is the most basic material model: Hooke's law
It exists in any solver and represents the starting poing of any nonlinear model.

Should be used with care in nonlinear applications, since large deformation can lead to very high stresses, 
where material behavior can become unstable.
In case of doubt, use an elasto-plastic material law, like LAW2 (Johnson-Cook model).

Application is for parts, which do NOT undergo large stresses and strains/deformations. 
Only acting as "kinetic energy container".

Purpose of this model is to be have an example of only few solid elements, which can be used for validation of 
some new developments. The load cases are uniaxial-tension and uniaxial-compression.

Model consists out of 4 hexahedron (8-noded) elements:
2 elements of the size: 10x10 mm (tension and compression)
2 elements of the size: 5x5 mm (tension and compression)


![image](/Materials/ElastoPlasticLaw/Law001/Solids/One_Element_Model/Images/LAW_01_One_element.png)
<figcaption align = "center"><b>Figure 1. (left) Von Mises stress [GPa] (right) Strain [-] /MAT/LAW1</b></figcaption>

![image](/Materials/ElastoPlasticLaw/Law001/Solids/One_Element_Model/Images/Anim_LAW01.gif)
<figcaption align = "center"><b>Animation 1. (left) Von Mises stress [GPa] (right) Strain [-] /MAT/LAW1</b></figcaption>
