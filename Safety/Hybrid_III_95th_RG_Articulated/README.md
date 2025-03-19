# Rigid Articulated Hybrid III 95th Percentile

This is the Rigid 95th percentile frontal impact dummy

Dummy file to be included in model:

      RG_Articulated_Hybrid_III_95TH_0000.rad

![image](/Safety/Hybrid_III_95th_RG_Articulated/Images/RGID_H3_95th.png)
<figcaption align = "center"><b>Figure 1. Rigid HIII 95th percentile </b></figcaption>

## Recommendation

This model is intended for educational and training purposes.
This model was developed for kinematic assessment only. To predict occupant injury risk, it is recommended to use commercial version of Radioss and safety models available from Altair and his partners, please contact Altair: [https://altair.com/fe-dummy-models]( https://altair.com/fe-dummy-models).

## Options and Keywords used

• Units used: kg, mm, ms  
• /SHELL, /SH3N, /SPRING, /BEAM elements
• Void material (/MAT/VOID)  
• Linear elasto plastic material (/MAT/LAW2)  
• General shell (/PROP/TYPE1), Beam (/PROP/BEAM) properties
• Added mass (/ADMAS)  
• Accelerometer (/ACCEL)  
• Rigid body (/RBODY)

## Model Statistics

| Item                 | Count         |
| -------------------- |:-------------:|
| Input Version        | 2023          |
| SH3N / SHELL         | 203 / 4841    |
| SPRING / BEAM        | 32 / 124      |
| NODES                | 5493          |
| Time Step (µs)       | .964          |
| Total Mass (kg)      | 107.4         |

## Sled case example

Fontal impact with belted Dummy

Example files are:

      example_H395_sled_0000.rad
      example_H395_sled_0000.rad

![Sled animation](/Safety/Hybrid_III_95th_RG_Articulated/Images/anims.gif)
<figcaption align = "center"><b>Figure 2. Sled test example with Rigid Articulated Hybrid III 95th Percentile</b></figcaption>
