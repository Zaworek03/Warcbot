<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4">
    <Task Name="Program" Source="Programs.Motion.Program.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Program1" Source="Programs.Program.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Program2" Source="Programs.camera.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#5" />
  <TaskClass Name="Cyclic#6" />
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <Libraries>
    <LibraryObject Name="McBase" Source="Libraries.McBase.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpRobotics" Source="Libraries.MpRobotics.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="McAxGroup" Source="Libraries.McAxGroup.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="McPathGen" Source="Libraries.McPathGen.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpAxis" Source="Libraries.MpAxis.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="runtime" Source="Libraries.runtime.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="CoTrace" Source="Libraries.CoTrace.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="McAxis" Source="Libraries.McAxis.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="McAcpAx" Source="Libraries.McAcpAx.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="McAcpPar" Source="Libraries.McAcpPar.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsZip" Source="Libraries.AsZip.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="FileIO" Source="Libraries.FileIO.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="sys_lib" Source="Libraries.sys_lib.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsBrStr" Source="Libraries.AsBrStr.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpBase" Source="Libraries.MpBase.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="McProgInt" Source="Libraries.McProgInt.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="astime" Source="Libraries.astime.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ViBase" Source="Libraries.ViBase.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsARCfg" Source="Libraries.AsARCfg.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="powerlnk" Source="Libraries.powerlnk.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsEPL" Source="Libraries.AsEPL.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIO" Source="Libraries.AsIO.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsTCP" Source="Libraries.AsTCP.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="DataObj" Source="Libraries.DataObj.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ArSsl" Source="Libraries.ArSsl.lby" Memory="UserROM" Language="Binary" Debugging="true" />
  </Libraries>
</SwConfiguration>