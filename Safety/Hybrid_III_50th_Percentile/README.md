# Hybrid III 50th Percentile

This is the 50th percentile frontal impact dummy

Dummy file to be included in model:

      Hybrid_III_50TH_0000.rad

With /SET modelling to use with Altair Hyperworks 2025.1 and above

      SET_Modelling/Hybrid_III_50TH_0000.rad

![image](/Safety/Hybrid_III_50th_Percentile/Images/h350.png)
<figcaption align = "center"><b>Figure 1. HIII 50th Dummy model </b></figcaption>

## Recommendation

This model is intended for educational and training purposes. The kinematics and mass distribution are fairly accurate, leading to realistic loading of the occupant environment (such as seat structure, restraint systems, instrument panel, etc.).
This model was developed for kinematic assessment only. To predict occupant injury risk, it is recommended to use commercial version of Radioss and safety models available from Altair and his partners, please contact Altair: [https://altair.com/fe-dummy-models]( https://altair.com/fe-dummy-models).

## Options and Keywords used

• Units used: kg, mm, ms  
• /SHELL, /SH3N, /BRICK, /TETRA4, /SPRING, /BEAM, /TRUSS elements
• Contact interface (/INTER/TYPE7,/INTER/TYPE11,/INTER/TYPE19)  
• Visco Elastic material (/MAT/LAW34, /MAT/LAW35)  
• Linear elastic material (/MAT/LAW1 (ELAST))  
• General solid property set (/PROP/TYPE14) and shell property (/PROP/TYPE1)
• Added mass (/ADMAS)  
• Accelerometer (/ACCEL)  
• Rigid body (/RBODY)

## Model Statistics

| Item                 | Count         |
| -------------------- |:-------------:|
| Input Version        | 2023          |
| BRICK / TETRA4       | 19311 / 25124 |
| SH3N / SHELL         | 7870 / 6619   |
| SPRING / TRUSS       | 55 / 47 / 186 |
| NODES                | 40401         |
| Time Step (µs)       | .84           |
| Total Mass (kg)      | 77.96         |

## Sled case example

Fontal impact with belted Dummy

Example files are:

      example_h350_sled_0000.rad
      example_h350_sled_belt_0000.inc
      example_h350_sled_0001.rad

![H350th Sled animation](/Safety/Hybrid_III_50th_Percentile/Images/H350_SLED.gif)
