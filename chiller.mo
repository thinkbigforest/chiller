within ;
package Chiller
  model ChillerWithWater "R-134a "
    extends Modelon.Icons.Experiment;
    extends VaporCycle.Experiments.SubComponents.ExperimentLiquidFluid;
    extends VaporCycle.Experiments.SubComponents.ExperimentWorkingFluid(
        redeclare package WorkingFluid =
          VaporCycle.Media.Hydrofluorocarbons.R134aShort);

    VaporCycle.Experiments.SubComponents.SummaryRecords.VaporCompressionCycle summary(
      P_compressor=compressor.summary.shaftPower,
      p_high=compressor.summary.p_dis,
      p_low=compressor.summary.p_suc,
      h_evap_out=evaporator.summary.h_out,
      h_evap_in=evaporator.summary.h_in,
      h_cond_out=condenser.summary.h_out,
      h_cond_in=condenser.summary.h_in,
      m_flow=expansionValve.summary.m_flow,
      dp_evap=evaporator.summary.dp,
      dp_cond=condenser.summary.dp,
      T_evap_in_sec=evaporator.summary.T_in_sec,
      T_evap_out_sec=evaporator.summary.T_out_sec,
      T_cond_in_sec=condenser.summary.T_in_sec,
      T_cond_out_sec=condenser.summary.T_out_sec,
      P_evaporator=evaporator.summary.Qflow,
      P_condenser=-condenser.summary.Qflow,
      recLevel=receiver.summary.relativeLevel,
      recQuality=receiver.summary.quality,
      subcooling=condenser.summary.dT_sat,
      superheat=evaporator.summary.dT_sat,
      COP=summary.P_condenser/max(1e-5, summary.P_compressor),
      M=aggregateTwoPhaseProperties.M,
      V=aggregateTwoPhaseProperties.V)
      annotation (Placement(transformation(extent={{-120,96},{-98,118}})));
    VaporCycle.Experiments.SubComponents.InitializationData.VaporCompressionCycleInit
      init(
      redeclare package WorkingFluid = WorkingFluid,
      T_sc=12,
      T_sh=4,
      p_receiver=receiver.summary.p_in,
      M_receiver=receiver.summary.M,
      V_receiver=receiver.summary.V,
      V_workingFluid=summary.V,
      charge=summary.specificCharge,
      phi_evap_sec=0.5,
      medium_cond=2,
      medium_evap=2,
      initType=1,
      charge_init=512,
      compSpeed=120,
      mflow_start=0.05,
      p_high=2450000,
      dp_high=10000,
      p_suction=600000,
      dp_low=10,
      dp_pipe=2000,
      mflow_cond_sec=0.5,
      T_cond_sec=305.15,
      mflow_evap_sec=0.25,
      T_evap_sec=285.15)
      annotation (Placement(transformation(extent={{-180,96},{-162,114}})));
    VaporCycle.HeatExchangers.LiquidTwoPhase.Examples.Chiller condenser(
      T_in_sec_start=init.T_cond_sec,
      mflow_sec_start=init.mflow_cond_sec,
      p_in_start=init.p_cond_in,
      p_out_start=init.p_cond_out,
      h_in_start=init.h_cond_in,
      h_out_start=init.h_cond_out,
      mflow_start=init.mflow_start,
      redeclare package WorkingFluid = WorkingFluid,
      hx_type=1,
      n=5,
      redeclare model Friction =
          VaporCycle.Pipes.SubComponents.FlowResistance.TwoPhase.DensityProfileFriction
          (
          h0_in=300e3,
          h0_out=130e3,
          p0_in=2400000,
          p0_out=2390000,
          mflow0=0.06),
      redeclare model HeatTransfer_sec =
          VaporCycle.Pipes.SubComponents.HeatTransfer.SinglePhase.DittusBoelterAdjustable,
      Ah_liq=2,
      A_wfl=5e-4,
      Ah_wfl=2,
      L_liq=1.5,
      L_wfl=1.5,
      T_out_sec_start=init.T_cond_sec + 30,
      wt_start=0.5,
      redeclare model HeatTransfer =
          VaporCycle.Pipes.SubComponents.HeatTransfer.TwoPhase.CondensationShah,
      initOpt=Modelon.ThermoFluid.Choices.InitOptions.initialValues,
      p_in_sec_start=110000,
      p_out_sec_start=100000,
      wallThickness=0.001)
      annotation (Placement(transformation(extent={{-118,42},{-138,62}})));

    VaporCycle.HeatExchangers.LiquidTwoPhase.Examples.Chiller evaporator(
      redeclare package WorkingFluid = WorkingFluid,
      T_in_sec_start=init.T_evap_sec,
      mflow_sec_start=init.mflow_evap_sec,
      p_in_start=init.p_evap_in,
      p_out_start=init.p_evap_out,
      h_in_start=init.h_cond_out,
      h_out_start=init.h_suction,
      mflow_start=init.mflow_start,
      n=5,
      redeclare model HeatTransfer =
          VaporCycle.Pipes.SubComponents.HeatTransfer.TwoPhase.EvaporationGungorWinterton,
      T_out_sec_start=init.T_evap_sec - 10,
      initOpt=Modelon.ThermoFluid.Choices.InitOptions.initialValues,
      redeclare model Friction =
          VaporCycle.Pipes.SubComponents.FlowResistance.TwoPhase.DensityProfileFriction
          (
          h0_in=140e3,
          h0_out=270e3,
          mflow0=0.06,
          p0_in=405000,
          p0_out=400000),
      L_liq=1.5,
      L_wfl=1.5,
      Ah_liq=3,
      Ah_wfl=1,
      redeclare model HeatTransfer_sec =
          VaporCycle.Pipes.SubComponents.HeatTransfer.SinglePhase.ConstantCoefficient
          (alpha=5000),
      wallThickness=0.005)
      annotation (Placement(transformation(extent={{-186,-46},{-166,-66}})));

    VaporCycle.Compressors.FixedDisplacementTableBased compressor(
      redeclare package Medium = WorkingFluid,
      initOpt=Modelon.ThermoFluid.Choices.InitOptions.initialValues,
      initFromEnthalpy=true,
      p_start=init.p_suction,
      h_start=init.h_suction,
      tableOnFile=false,
      etaMechMap=[0.0,1,10; 10,0.97,0.97; 20,0.97,0.97],
      volEffMap=[0.0,1,10; 10,0.95,0.95; 20,0.95,0.95],
      etaIsMap=[0.0,1,10; 10,0.7,0.7; 20,0.7,0.7],
      V_MaxDisplacement=2e-5) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-102,0})));
    VaporCycle.Pipes.PipeAdiabatic pipe1(
      redeclare package Medium = WorkingFluid,
      n=1,
      n_channels=1,
      L=0.5,
      D=0.02,
      initFromEnthalpy=true,
      m_flow_start=init.mflow_start,
      redeclare model Friction =
          VaporCycle.Pipes.SubComponents.FlowResistance.TwoPhase.SimpleFromDensity
          (mflow0=init.mflow_start),
      initOpt=Modelon.ThermoFluid.Choices.InitOptions.steadyState,
      h_in_start=init.h_cond_in,
      h_out_start=init.h_cond_in,
      p_in_start=init.p_high,
      p_out_start=init.p_high - init.dp_pipe) annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-102,30})));
    VaporCycle.Pipes.PipeAdiabatic pipe2(
      redeclare package Medium = WorkingFluid,
      n=1,
      n_channels=1,
      L=0.3,
      D=0.008,
      initFromEnthalpy=true,
      m_flow_start=init.mflow_start,
      redeclare model Friction =
          VaporCycle.Pipes.SubComponents.FlowResistance.TwoPhase.SimpleFromDensity
          (mflow0=init.mflow_start),
      initOpt=Modelon.ThermoFluid.Choices.InitOptions.steadyState,
      p_in_start=init.p_cond_out,
      p_out_start=init.p_cond_out - init.dp_pipe,
      h_in_start=init.h_cond_out,
      h_out_start=init.h_cond_out,
      dp_smooth=100)
      annotation (Placement(transformation(extent={{-150,36},{-170,56}})));
    VaporCycle.Tanks.LiquidReceiver receiver(
      redeclare package Medium = WorkingFluid,
      H_suction=0.01,
      desiccant=false,
      initFromEnthalpy=true,
      zeta=200,
      staticHead=false,
      p_start=init.p_cond_out - init.dp_pipe,
      h_start=init.h_cond_out,
      initOpt=Modelon.ThermoFluid.Choices.InitOptions.steadyState,
      D=1.13,
      H=1)
      annotation (Placement(transformation(extent={{-170,26},{-190,46}})));
    VaporCycle.Pipes.PipeAdiabatic pipe3(
      redeclare package Medium = WorkingFluid,
      n=1,
      n_channels=1,
      L=0.3,
      initFromEnthalpy=true,
      m_flow_start=init.mflow_start,
      redeclare model Friction =
          VaporCycle.Pipes.SubComponents.FlowResistance.TwoPhase.SimpleFromDensity
          (mflow0=init.mflow_start),
      initOpt=Modelon.ThermoFluid.Choices.InitOptions.steadyState,
      p_in_start=init.p_cond_out - init.dp_pipe - 0.1*init.dp_pipe,
      p_out_start=init.p_cond_out - 2*init.dp_pipe,
      h_in_start=init.h_cond_out,
      h_out_start=init.h_cond_out,
      D=0.008) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-190,0})));

    VaporCycle.Valves.SimpleTXV expansionValve(
      redeclare package Medium = WorkingFluid,
      initOpt=Modelon.ThermoFluid.Choices.InitOptions.initialValues,
      mflow_start=init.mflow_start,
      yMax=0.12,
      yMin=0.001,
      p_start=init.p_cond_out - 2.1*init.dp_pipe,
      h_start=init.h_cond_out,
      V=1e-06) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-190,-32})));
    VaporCycle.Sources.LiquidFlowSource liqIn_cond(
      use_T_in=true,
      flowDefinition=Modelon.ThermoFluid.Choices.FlowDefinition.m_flow,
      use_flow_in=true,
      redeclare package Medium = Liquid)
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-150,76})));
    VaporCycle.Sources.LiquidPressureSource liqOut_cond(
      N=1,
      redeclare package Medium = Liquid,
      p=101300) annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=0,
          origin={-100,78})));
    VaporCycle.Sources.LiquidPressureSource liqOut_evap(
      N=1,
      redeclare package Medium = Liquid,
      p=101300) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-194,-106})));
    VaporCycle.Sources.LiquidFlowSource liqIn_evap(
      use_T_in=true,
      use_flow_in=true,
      flowDefinition=Modelon.ThermoFluid.Choices.FlowDefinition.m_flow,
      temperatureUnit=Modelon.ThermoFluid.Choices.RealTemperatureUnit.K,
      redeclare package Medium = Liquid)
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=-90,
          origin={-142,-70})));
    VaporCycle.Sources.Speed rps
      annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          rotation=180,
          origin={-144,0})));
    Modelica.Blocks.Sources.Ramp T_cond(
      duration=0,
      startTime=100,
      offset=init.T_cond_sec,
      height=0)
      annotation (Placement(transformation(extent={{5,-5},{-5,5}},
          rotation=0,
          origin={-15,29})));
    Modelica.Blocks.Sources.Ramp mflow_cond(
      offset=init.mflow_cond_sec,
      duration(displayUnit="s") = 0,
      startTime(displayUnit="s") = 100,
      height=0)
      annotation (Placement(transformation(extent={{-10,104},{-20,114}})));
    Modelica.Blocks.Sources.Ramp T_evap(
      offset=init.T_evap_sec,
      duration(displayUnit="d") = 86400,
      startTime(displayUnit="d") = 345600,
      height=0)
      annotation (Placement(transformation(extent={{-10,-24},{-20,-14}})));
    Modelica.Blocks.Sources.Ramp mflow_evap(
      offset=init.mflow_evap_sec,
      duration(displayUnit="d") = 1728000,
      startTime(displayUnit="d") = 5184000,
      height=0)
      annotation (Placement(transformation(extent={{-10,-112},{-20,-102}})));
    Modelica.Blocks.Sources.Ramp speed(
      offset=init.compSpeed,
      duration(displayUnit="s") = 100,
      startTime(displayUnit="s") = 100,
      height=0)
      annotation (Placement(transformation(extent={{6,-6},{-6,6}},
          rotation=180,
          origin={-172,0})));

    VaporCycle.Pipes.PipeAdiabatic pipe4(
      redeclare package Medium = WorkingFluid,
      n=1,
      n_channels=1,
      L=0.4,
      D=0.015,
      initFromEnthalpy=true,
      m_flow_start=init.mflow_start,
      redeclare model Friction =
          VaporCycle.Pipes.SubComponents.FlowResistance.TwoPhase.SimpleFromDensity
          (dp0=10000, mflow0=init.mflow_start),
      initOpt=Modelon.ThermoFluid.Choices.InitOptions.steadyState,
      p_in_start=init.p_suction + init.dp_pipe,
      p_out_start=init.p_suction,
      h_in_start=init.h_suction,
      h_out_start=init.h_suction) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-102,-40})));
  protected
    parameter Modelica.SIunits.Time startTime(fixed=false);
  public
    VaporCycle.Sensors.SuperHeatSensor superHeatSensor(redeclare package Medium =
          WorkingFluid)
      annotation (Placement(transformation(extent={{-134,-60},{-114,-40}})));
    inner VaporCycle.AggregateTwoPhaseProperties aggregateTwoPhaseProperties
      annotation (Placement(transformation(extent={{-152,96},{-132,116}})));
    VaporCycle.Utilities.Visualizers.pH_Diagrams.pH_R134a pH_R134a(x={summary.h_cond_in,
          summary.h_cond_out,summary.h_evap_in,summary.h_evap_out,summary.h_cond_in},
        y=Modelica.Math.log({condenser.summary.p_in,condenser.summary.p_out,
          evaporator.summary.p_in,evaporator.summary.p_out,condenser.summary.p_in}))
      annotation (Placement(transformation(extent={{-4,-56},{218,118}})));
    Modelica.Blocks.Math.Add3 add3_1
      annotation (Placement(transformation(extent={{-52,86},{-72,106}})));
    Modelica.Blocks.Math.Add3 add3_2
      annotation (Placement(transformation(extent={{-52,54},{-72,74}})));
    Modelica.Blocks.Math.Add3 add3_3
      annotation (Placement(transformation(extent={{-54,-50},{-74,-30}})));
    Modelica.Blocks.Math.Add3 add3_4
      annotation (Placement(transformation(extent={{-54,-84},{-74,-64}})));
    Modelica.Blocks.Sources.Sine sine(amplitude=0.12, freqHz=0.01)
      annotation (Placement(transformation(extent={{-10,90},{-20,100}})));
    Modelica.Blocks.Sources.Sine sine1(amplitude=0.05, freqHz=0.01)
      annotation (Placement(transformation(extent={{-10,40},{-20,50}})));
    Modelica.Blocks.Sources.Sine sine2(amplitude=0.51, freqHz=0.01)
      annotation (Placement(transformation(extent={{-10,-42},{-20,-32}})));
    Modelica.Blocks.Sources.Sine sine3(amplitude=1.12, freqHz=0.01)
      annotation (Placement(transformation(extent={{-10,-96},{-20,-86}})));
    Modelica.Blocks.Sources.SawTooth sawTooth(
      period=2,
      nperiod=1,
      startTime=3450,
      amplitude=1.89)
      annotation (Placement(transformation(extent={{-10,58},{-20,68}})));
    Modelica.Blocks.Sources.SawTooth sawTooth1(
      period=2,
      nperiod=1,
      startTime=3450,
      amplitude=1.89)
      annotation (Placement(transformation(extent={{-10,74},{-20,84}})));
    Modelica.Blocks.Sources.SawTooth sawTooth2(
      period=2,
      nperiod=1,
      startTime=3450,
      amplitude=1.89)
      annotation (Placement(transformation(extent={{-10,-60},{-20,-50}})));
    Modelica.Blocks.Sources.SawTooth sawTooth3(
      period=2,
      nperiod=1,
      startTime=3450,
      amplitude=1.89)
      annotation (Placement(transformation(extent={{-10,-78},{-20,-68}})));
  initial equation
    startTime=time;
  equation
    when sample(startTime,Modelica.Constants.inf) and init.initType==1 then
      reinit(receiver.separator.volume.h,init.h_receiver);
    end when;
    connect(compressor.flange, rps.flange) annotation (Line(
        points={{-111,4.44089e-016},{-116,4.44089e-016},{-116,-1.33227e-015},{
            -134,-1.33227e-015}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(pipe4.portB, compressor.portA) annotation (Line(
        points={{-102,-30},{-102,-10}},
        color={0,190,0},
        smooth=Smooth.None));
    connect(compressor.portB, pipe1.portA)
                                          annotation (Line(
        points={{-102,10},{-102,20}},
        color={0,190,0},
        smooth=Smooth.None));
    connect(pipe1.portB, condenser.portA)
                                         annotation (Line(
        points={{-102,40},{-102,46},{-118,46}},
        color={0,190,0},
        smooth=Smooth.None));
    connect(condenser.portB,pipe2. portA) annotation (Line(
        points={{-138,46},{-150,46}},
        color={0,190,0},
        smooth=Smooth.None));
    connect(pipe2.portB, receiver.portA) annotation (Line(
        points={{-170,46},{-176,46}},
        color={0,190,0},
        smooth=Smooth.None));
    connect(receiver.portB,pipe3. portA) annotation (Line(
        points={{-184,46},{-190,46},{-190,10}},
        color={0,190,0},
        smooth=Smooth.None));
    connect(pipe3.portB, expansionValve.portA) annotation (Line(
        points={{-190,-10},{-190,-24}},
        color={0,190,0},
        smooth=Smooth.None));
    connect(expansionValve.portB, evaporator.portA) annotation (Line(
        points={{-190,-40},{-190,-50},{-186,-50}},
        color={0,190,0},
        smooth=Smooth.None));

    connect(rps.inPort, speed.y) annotation (Line(
        points={{-156,1.55431e-015},{-156,-8.88178e-016},{-165.4,-8.88178e-016}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(liqIn_cond.port, condenser.portA_sec) annotation (Line(
        points={{-150.4,68},{-138,68},{-138,58}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(condenser.portB_sec,liqOut_cond. port[1]) annotation (Line(
        points={{-118,58},{-116,58},{-116,78},{-108,78}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(liqOut_evap.port[1], evaporator.portB_sec) annotation (Line(
        points={{-186,-106},{-186,-62}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.portA_sec,liqIn_evap. port) annotation (Line(
        points={{-166,-62},{-141.6,-62}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(evaporator.portB, superHeatSensor.portA) annotation (Line(
        points={{-166,-50},{-134,-50}},
        color={0,190,0},
        smooth=Smooth.None));
    connect(superHeatSensor.portB, pipe4.portA) annotation (Line(
        points={{-114,-50},{-102,-50}},
        color={0,190,0},
        smooth=Smooth.None));
    connect(expansionValve.DeltaT_SH, superHeatSensor.y) annotation (Line(
        points={{-182.5,-28.5},{-124,-28.5},{-124,-41}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(add3_1.y, liqIn_cond.m_flow_in) annotation (Line(points={{-73,96},{
            -78,96},{-78,86},{-155,86},{-155,80.8}}, color={0,0,127}));
    connect(mflow_cond.y, add3_1.u1) annotation (Line(points={{-20.5,109},{-30,
            109},{-30,104},{-50,104}}, color={0,0,127}));
    connect(add3_2.y, liqIn_cond.T_in) annotation (Line(points={{-73,64},{-76,
            64},{-76,66},{-160,66},{-160,76},{-157,76}}, color={0,0,127}));
    connect(T_cond.y, add3_2.u3) annotation (Line(points={{-20.5,29},{-50,29},{
            -50,56}}, color={0,0,127}));
    connect(add3_3.y, liqIn_evap.T_in) annotation (Line(points={{-75,-40},{-82,
            -40},{-82,-70},{-135,-70}}, color={0,0,127}));
    connect(T_evap.y, add3_3.u1) annotation (Line(points={{-20.5,-19},{-52,-19},
            {-52,-32}}, color={0,0,127}));
    connect(add3_4.y, liqIn_evap.m_flow_in) annotation (Line(points={{-75,-74},
            {-78,-74},{-78,-74.8},{-137,-74.8}}, color={0,0,127}));
    connect(mflow_evap.y, add3_4.u3) annotation (Line(points={{-20.5,-107},{-52,
            -107},{-52,-82}}, color={0,0,127}));
    connect(sine.y, add3_1.u2) annotation (Line(points={{-20.5,95},{-28,95},{
            -28,96},{-50,96}}, color={0,0,127}));
    connect(sine1.y, add3_2.u2) annotation (Line(points={{-20.5,45},{-40,45},{
            -40,64},{-50,64}}, color={0,0,127}));
    connect(sine2.y, add3_3.u2) annotation (Line(points={{-20.5,-37},{-20.5,-40},
            {-52,-40}}, color={0,0,127}));
    connect(sine3.y, add3_4.u2) annotation (Line(points={{-20.5,-91},{-40,-91},
            {-40,-74},{-52,-74}}, color={0,0,127}));
    connect(sawTooth.y, add3_2.u1) annotation (Line(points={{-20.5,63},{-34,63},
            {-34,72},{-50,72}}, color={0,0,127}));
    connect(sawTooth1.y, add3_1.u3) annotation (Line(points={{-20.5,79},{-50,79},
            {-50,88}}, color={0,0,127}));
    connect(sawTooth2.y, add3_3.u3) annotation (Line(points={{-20.5,-55},{-30,
            -55},{-30,-48},{-52,-48}}, color={0,0,127}));
    connect(sawTooth3.y, add3_4.u1) annotation (Line(points={{-20.5,-73},{-32,
            -73},{-32,-66},{-52,-66}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
              -120},{220,120}})),            Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-200,-120},{220,120}})),
      experiment(StopTime=10800, Tolerance=1e-006),
      __Dymola_experimentSetupOutput(equdistant=false),
      Documentation(revisions="<html>
<hr><p><font color=\"#E72614\"><b>Copyright &copy; 2004-2017, MODELON AB</b></font> <font color=\"#AFAFAF\">The use of this software component is regulated by the licensing conditions for the Vapor Cycle Library. This copyright notice must, unaltered, accompany all components that are derived from, copied from, or by other means have their origin from the Vapor Cycle Library. </font>
</html>",   info="<html>
<p><span style=\"font-family: Times New Roman; font-size: 16pt;\">这是使用 R-134a 作为工作流体的热泵系统实验示例。 在冷凝器和蒸发器中以水为辅助流体的蒸汽压缩循环将热量从低温热源传输到高温散热器。 蒸发器的过热由膨胀阀控制。 在模拟过程中，瞬态被应用于两个热交换器的液体流体边界条件。</span></p>
<p><span style=\"font-family: Times New Roman; font-size: 16pt;\">绘制以下变量以检查边界条件变化的影响：</span></p>
<p><span style=\"font-family: Times New Roman; font-size: 16pt; background-color: #f5f5f5;\">蒸发器出口过热：summary.superheat</span></p>
<p><span style=\"font-family: Times New Roman; font-size: 16pt; background-color: #f5f5f5;\">冷凝器出口过冷：summary.subcooling</span></p>
<p><span style=\"font-family: Times New Roman; font-size: 16pt; background-color: #f5f5f5;\">冷凝器出水温度汇总。T_cond_out_sec</span></p>
<p><span style=\"font-family: Times New Roman; font-size: 16pt; background-color: #f5f5f5;\">性能系数：summary.COP</span></p>
<p><span style=\"font-family: Times New Roman; font-size: 16pt; background-color: #f5f5f5;\">吸入和排出压力：summary.p_high 和summary.p_low</span></p>
<p><span style=\"font-family: Times New Roman; font-size: 16pt; background-color: #f5f5f5;\">制冷剂质量流量：summary.m_flow </span></p>
</html>"));
  end ChillerWithWater;

  annotation (uses(
      Modelon(version="2.6"),
      VaporCycle(version="1.5"),
      Modelica(version="3.2.2")));
end Chiller;
