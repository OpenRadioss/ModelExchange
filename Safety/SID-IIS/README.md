# SID2S

This is the sid-IIs lateral impact dummy

Dummy file to be included in model:

      SID2S_0000.rad

With /SET modelling to use with Altair Hyperworks 2025.1 and above

      SET_Modelling/SID2S_0000.rad

![image](/Safety/SID-IIS/Images/SID2S.png)
<figcaption align = "center"><b>Figure 1. SID2S Dummy model </b></figcaption>

## Recommendation

This model is intended for educational and training purposes. The kinematics and mass distribution are fairly accurate, leading to realistic loading of the occupant environment (such as seat structure, restraint systems, instrument panel, etc.).
This model was developed for kinematic assessment only. To predict occupant injury risk, it is recommended to use commercial version of Radioss and safety models available from Altair and his partners, please contact Altair: [https://altair.com/fe-dummy-models]( https://altair.com/fe-dummy-models).

## Options and Keywords used

• Units used: kg, mm, ms  
• /SHELL /SH3N, /BRICK, /SPRING, /TRUSS /CYL_JOINT elements
• Contact interface (/INTER/TYPE7,/INTER/TYPE19)  
• Visco Hyperelastic material (/MAT/LAW42, /MAT/LAW35)  
• Visco elastic material (/MAT/LAW34)  
• Linear elastic material (/MAT/LAW1 (ELAST), /MAT/LAW2)  
• Void material (/MAT/LAW0 (VOID)) 
• General solid property set (/PROP/TYPE14) and shell property (/PROP/TYPE1)
• Added mass (/ADMAS)  
• Accelerometer (/ACCEL)  
• Rigid body (/RBODY)

## Model Statistics

| Item                 | Count         |
| -------------------- |:-------------:|
| Input Version        | 2023          |
| BRICK                | 16210         |
| SH3N / SHELL         | 220 / 15510   |
| SPRING / TRUSS       | 95 / 125      |
| NODES                | 35939         |
| Time Step (µs)       | .9            |
| Total Mass (kg)      | 44.09         |

## Sled case example

Belted Dummy

Example files are:

      example_sid2s_sled_0000.rad
      example_sid2s_sled_0001.rad

![SID2S Sled animation](/Safety/SID-IIS/Images/SID2S_SLED.gif)
