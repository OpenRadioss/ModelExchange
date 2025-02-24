# Hybrid III 05th Percentile

This is the 5th percentile frontal impact dummy

Dummy file to be included in model:

      Hybrid_III_05TH_0000.rad

![image](/Safety/Hybrid_III_05th_Percentile/Images/h305.png)
<figcaption align = "center"><b>Figure 1. HIII 05th Dummy model </b></figcaption>

## Recommendation

This model is intended for educational and training purposes. The kinematics and mass distribution are fairly accurate, leading to realistic loading of the occupant environment (such as seat structure, restraint systems, instrument panel, etc.).
This model was developed for kinematic assessment only. To predict occupant injury risk, it is recommended to use commercial version of Radioss and safety models available from Altair and his partners, please contact Altair: [https://altair.com/fe-dummy-models]( https://altair.com/fe-dummy-models).

## Options and Keywords used

• Units used: kg, mm, ms  
• /SHELL /SH3N, /BRICK, /SPRING, /TRUSS elements
• Contact interface (/INTER/TYPE7,/INTER/TYPE11,/INTER/TYPE19)  
• Visco Hyperelastic material (/MAT/LAW42, /MAT/LAW35)  
• Linear elastic material (/MAT/LAW1 (ELAST))  
• General solid property set (/PROP/TYPE14) and shell property (/PROP/TYPE1)
• Added mass (/ADMAS)  
• Accelerometer (/ACCEL)  
• Rigid body (/RBODY)

## Model Statistics

| Item                 | Count         |
| -------------------- |:-------------:|
| Input Version        | 2023          |
| BRICK                | 2001          |
| SH3N / SHELL         | 7 / 3276      |
| SPRING / TRUSS       | 38 / 84       |
| NODES                | 6426          |
| Time Step (µs)       | .98           |
| Total Mass (kg)      | 49.3          |

## Sled case example

Belted Dummy

Example files are:

      example_h305_sled_0000.rad
      example_h305_sled_0001.rad

![H305th Sled animation](/Safety/Hybrid_III_05th_Percentile/Images/H305_SLED.gif)
