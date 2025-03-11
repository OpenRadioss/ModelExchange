# EuroSID II Dummy Model

This is the EuroSID II 50th Percentile Side impact dummy

Dummy file to be included in model:

      EuroSID_II_0000.rad

![image](/Safety/EuroSID_II/Images/EuroSID_II.png)
<figcaption align = "center"><b>Figure 1. EuroSID II Dummy model </b></figcaption>

## Recommendation

This model is intended for educational and training purposes. The kinematics and mass distribution are fairly accurate, leading to realistic loading of the occupant environment (such as seat structure, restraint systems, instrument panel, etc.).
This model was developed for kinematic assessment only. To predict occupant injury risk, it is recommended to use commercial version of Radioss and safety models available from Altair and his partners, please contact Altair: [https://altair.com/fe-dummy-models]( https://altair.com/fe-dummy-models).

## Options and Keywords used

• Units used: kg, mm, ms  
• /SHELL /SH3N, /BRICK, /SPRING, /TRUSS elements
• Contact interface (/INTER/TYPE7,/INTER/TYPE10,/INTER/TYPE19)  
• Visco Hyperelastic material (/MAT/LAW42, /MAT/LAW35)  
• Linear elastic material (/MAT/LAW1 (ELAST), /MAT/LAW2)  
• General solid property set (/PROP/TYPE14) and shell property (/PROP/TYPE1)
• Added mass (/ADMAS)  
• Accelerometer (/ACCEL)  
• Rigid body (/RBODY)

## Model Statistics

| Item                 | Count         |
| -------------------- |:-------------:|
| Input Version        | 2023          |
| BRICK                | 7606          |
| SH3N / SHELL         | 477 / 8997    |
| SPRING / TRUSS       | 72 / 105      |
| NODES                | 16296         |
| Time Step (µs)       | .71           |
| Total Mass (kg)      | 87.6          |

## Sled case example

Belted Dummy

Example files are:

      example_es2_sled_0000.rad
      example_es2_sled_0001.rad

![ES2 Sled animation](/Safety/EuroSID_II/Images/EuroSID_II_sled.gif)
