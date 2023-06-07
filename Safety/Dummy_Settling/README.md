# Quasi-static loading analysis on a dummy, settling on a seat before crash analysis, using OpenRadioss

The topic of this study concerns quasi-static load treatment of dummy settling using the automatic dynamic relaxation approach: (/ADYREL),

Figure 1 shows the model set-up.

![image](/Safety/Dummy_Settling/Images/Picture1.png)
<figcaption align = "center"><b>Figure 1. Model set-up</b></figcaption>

# Options and Keywords used

•	Units used: Mg, mm, s  
•	/SHELL, /BRICK, /BEAM elements  
•	Quasi-static analysis by explicit, automatic dynamic relaxation (/ADYREL)  
•	Contact interface (/INTER/TYPE7)  
•	Hyperfoam material (/MAT/LAW62)  
•	Linear elastic material (/MAT/LAW1 (ELAST))  
•	General solid property set (/PROP/TYPE14) and shell property (/PROP/TYPE1)  
•	Void material (/MAT/VOID) property (/PROP/VOID)  
•	Added mass (/ADMAS)  
•	Boundary conditions (/BCS)  
•	Gravity (/GRAV)  
•	Rigid body (/RBODY)

# Description of the Physical Problem

The model consists of two subsets:

•	a dummy with only the external surface defined as a rigid body.  
•	a seat comprised of six parts (foam seat back, foam seat cushion, seat back brace, seat bottom brace, seat legs and the floor).

![image](/Safety/Dummy_Settling/Images/Picture2.png)
<figcaption align = "center"><b>Figure 2. Left: Model mesh (perspective view - shaded display); Right: model mesh (profile view - edges display).</b></figcaption><br/><br/>  

The goal is to settle the dummy on the seat using a quasi-static approach to obtain static equilibrium.  
For this exercise, the dummy’s limbs are already positioned at the desired position before the gravity load is applied. 

![image](/Safety/Dummy_Settling/Images/Picture3.png)
<figcaption align = "center"><b>Figure 3. Setup of the Rigid Bodies.</b></figcaption><br/><br/>  

The seat structure and the floor are defined in a rigid body. Only the seat cushion parts are deformable during simulation.
The main node coordinates, and skew are extracted from the pelvis part of the dummy rigid body.
Gravity is applied to all nodes of the model. A function defines gravity acceleration in the Z- direction versus time. The gravity is activated by using the /GRAV keyword in the starter file (*_0000.rad).

![image](/Safety/Dummy_Settling/Images/Picture4.png)
<figcaption align = "center"><b>Figure 4. Input gravity function (-9810 mm/s-2) at selected nodes (yellow).</b></figcaption><br/><br/>

The main node of the seat and floor rigid body is clamped. 
The main node of the dummy model rigid body is free to translate along X and Z axis and rotate around Y axis.

![image](/Safety/Dummy_Settling/Images/Picture5.png)
<figcaption align = "center"><b>Figure 5. Boundary conditions on the rigid bodies’ main nodes. </b></figcaption><br/><br/>

# Material properties

Material for seat support - both the legs and the floor are made of steel with the following properties (/MAT/LAW1):  
•	E (Young’s modulus): 210000 MPa  
•	nu (Poisson’s ratio): 0.3  
•	RhoI (Density): 7.8E-9 ton/mm³  

The seat cushion is made of foam which can be described using the hyperfoam model (/MAT/LAW62).  
•	RhoI (Density): 7.8E-9 ton/mm³  
•	nu (Poisson’s ratio): 0 (foam behavior)  
•	muI , alphaI (ground shear modulus): (.02,2) ,(0.01,-2)  

The dummy model parts are void material (/MAT/VOID).  
The material properties are used to compute the contact stiffness only:  
•	E (Young’s modulus): 2070 MPa  
•	nu (Poisson’s ratio): 0.28  
•	RhoI (Density): 5E-11 ton/mm³  

# Element properties

The seat cushion is meshed with 70 brick elements defined by general /PROP/TYPE14 solid property.  
•	Isolid = 24 (HEPH)  
•	Ismstr, Icpre and Iframe are set to -1, the recommended value.  
•	The other parameters are set to default (0)  

The seat structure and the floor are modeled with shell elements defined in the rigid body  
•	Shell properties used are default value for all parameters (0)  
•	Seat back thickness: 2 mm  
•	Floor thickness: 1 mm  

The seat legs have the following characteristics:  
•	Area: 2580 mm2  
•	Inertia:  IXX = 554975 mm4; IYY = 554975 mm4; IZZ = 937908 mm4  
•	Void property is used for the dummy’s components. The Dummy thickness of 1mm is used to compute the contact stiffness.  

# Contact interfaces

•	Seat foams define the Main surface, Dummy parts define the Secondary nodes  
•	Dummy parts define the Main surface, Seat foams define the Secondary nodes (symmetrical contact)  
•	The floor defines the Main surface, dummy feet define the Secondary nodes  

![image](/Safety/Dummy_Settling/Images/Picture6.png)
<figcaption align = "center"><b>Figure 6. Contacts Modeling with TYPE7 Symmetrical Interface and foot-floor interface </b></figcaption><br/><br/>

The contact interfaces use the following parameters:  
•	Contact gap 		5 mm  
•	Coulomb friction	0.3  
•	Stiffness flag		4, minimum stiffness between main and secondary  
•	Minimum stiffness	1000 N/mm (usually value for automotive crash analysis)  
•	Friction formulation	2 (stiffness)  
Refer to the Radioss Theory Manual and Starter Input for further information about the definition of the TYPE7 interface.

# Automatic Dynamic Relaxation Method

Quasi-static treatment of gravity loading up to equilibrium using explicit solver:  

A quasi-static simulation using a dynamic resolution method needs to minimize the dynamic effects in order  
to converge towards static equilibrium. This usually describes the pre-loading case prior to dynamic analysis.  
Thus, the quasi-static solution of gravity loading on the model is the steady state part of the transient response.  
To reduce the dynamic effect, the following option are used in the engine file:  

•	Dynamic relaxation (/ADYREL)  
-- o	Dynamic relaxation with auto-defined adaptive damping.   
-- o	Radioss solver automatically defines the period to damp. There is no parameter to set.  
Detailed information about the different formulations are available in the Theory manual.

# Results

Curves and Animations  
![image](/Safety/Dummy_Settling/Images/Picture7.png)
<figcaption align = "center"><b>Figure 7. the results of displacement in Z- direction of the dummy. </b></figcaption><br/><br/>

# Conclusion

This model with automatic dynamic relaxation (/ADYREL), converges quickly on a quasi static equilibrium (after around 0.4s)

&nbsp;

