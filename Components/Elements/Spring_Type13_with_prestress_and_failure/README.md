# Modeling of simple pre-tensed spring type13

This example shows a simple way to model pretension of a 1-d element: Spring Type13

Figure 1 shows the model set-up.

![image](/Elements/Spring_Type13_with_prestress_and_failure/Images/Model.png)
<figcaption align = "center"><b>Figure 1. Model set-up</b></figcaption>

The main point is in the defined tension curve, which as a non-zero value for force at 0 displacement.

![image](/Elements/Spring_Type13_with_prestress_and_failure/Images/Pretension_Function.png)
<figcaption align = "center"><b>Figure 2. Force-Displacement curve in the property definition of the spring type13.</b></figcaption>

The applied imposed displacement to the upper plate is defined to start moving after 5 ms of time up to 20 ms.
Failure of the spring occurs after its elongation of 4mm.

![image](/Elements/Spring_Type13_with_prestress_and_failure/Images/Results_animtion.gif)
<figcaption align = "center"><b>Figure 3. Results animation.</b></figcaption>

Another possible way is to use /PROP/TYPE32 spring.

&nbsp;

