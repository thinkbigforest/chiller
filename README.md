## Chiller fault simulation
A chiller model in modelica
## Library description
Modelon (version="2.6"), VaporCycle (version="1.5"), Modelica (version="3.2.2")
For Dymola versions 2018
Complier Visual studio 2010
## License
Copyright © 2004-2017, MODELON AB The use of this software component is regulated by the licensing conditions for the Modelon Library. This copyright notice must, unaltered, accompany all components that are derived from, copied from, or by other means have their origin from the Modelon Library. 
## Development and contribution
This is an example of a chiller system experiment using R-134a as the working fluid. A vapor compression cycle with water as the auxiliary fluid in the condenser and evaporator transfers heat from a low temperature heat source to a high temperature radiator. The superheat of the evaporator is controlled by the expansion valve. During the simulation, transients were applied to the liquid-fluid boundary conditions of the two heat exchangers.
![Image text](Screenshots/T1.jpg) 
## Fault simulation 
According to the characteristics and performance of the built chiller model, the faults involved in this study mainly include: reduced evaporator water flow, condenser fouling, and reduced condenser water flow. The time setting of the performance degradation pro-cess limited by the performance simulation of the computer is shortened, and the perfor-mance degradation process of the chiller is expressed in hours.
## reduced condenser water flow
The most direct result of the reduction in the flow of condenser water is that the heat exchange efficiency of the condenser is reduced, the outlet temperature of the condenser water will increase, and the temperature difference will become larger. As the condensing pressure increases due to the decrease in flow, the power of the compressor will also in-crease and the COP will decrease when other parameters of the compressor remain un-changed. If the failure is allowed to deepen, it will further increase power consumption, increase energy waste, and even cause equipment damage.
## reduced evaporator water flow
The most direct result of the reduction in the flow of evaporator water is that the heat exchange efficiency of the evaporator is reduced, the evaporation rate of the refrigerant is slowed down, and the cooling power of the evaporator is reduced. As the flow rate de-creases, the evaporating pressure becomes smaller, and the outlet temperature of the evaporator water also decreases. When the variation of the compressor power is smaller than the decrease of the condenser power of the evaporator, the COP will also decrease. The result of its failure is that a large amount of cooling capacity is wasted and the cooling efficiency is reduced.
## condenser fouling
The condenser fouling affects the heat exchange effect, resulting in an increase in the condensing temperature of the unit, which in turn leads to a decrease in the cooling ca-pacity and an increase in the power consumption of the unit. resistance, increasing the energy consumption of the circulating water pump.


