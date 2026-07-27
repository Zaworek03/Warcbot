<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Cyclic#1">
    <Task Name="MotionCtrl" Source="Programs.Motion.MotionCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4">
    <Task Name="Program2" Source="Programs.camera.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PositionIn" Source="Programs.Motion.PositionInfo.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SaveGame" Source="Programs.SaveGame.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="AlarmHisto" Source="Programs.AlarmHistory.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisVariabl" Source="Programs.VisVariable.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="GameStats" Source="Programs.GameStats.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CheckVisio" Source="Programs.CheckVision.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MainProgra" Source="Programs.MainProgram.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FolderMng" Source="Programs.FolderMng.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Alarms" Source="Programs.Alarms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#5" />
  <TaskClass Name="Cyclic#6" />
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="McAcpSys" Source="" Memory="UserROM" Language="Binary" />
  </DataObjects>
  <NcDataObjects>
    <NcDataObject Name="McDriveLog" Source="" Memory="UserROM" Language="Binary" />
  </NcDataObjects>
  <Binaries>
    <BinaryObject Name="mvLoader" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="mvConfig" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="McProfGen" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="McAcpSim" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="FWRules" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="McAcpDrv" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="udbdef" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TCData" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="Config_3" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Config_1" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Config_2" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="McPathXT" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="McMechSys" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="BRRole" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="User" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Settings" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Role" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arconfig" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="mCoWebSc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="AxisFeat" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Hierarchy" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asfw" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="ashwd" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="ashwac" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="MechSys" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="GroupConf" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Config" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="sysconf" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="GroupFeat" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="iomap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="UaCsConfig" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="AxisConf" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="viComp" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Settings_1" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Config_4" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="viApp" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Engineer2" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
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
    <LibraryObject Name="MpAlarmX" Source="Libraries.MpAlarmX.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpServer" Source="Libraries.MpServer.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpRecipe" Source="Libraries.MpRecipe.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpFile" Source="Libraries.MpFile.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIecCon" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="UaCoal" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ArSvcReg" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIOAcc" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsETH" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsHW" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsArProf" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="UaCore" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="UaCoalPrv" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ArCert" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="brsystem" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsMem" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ArUser" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIoTrc" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpUserX" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpAudit" Source="Libraries.MpAudit.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpReport" Source="Libraries.MpReport.lby" Memory="UserROM" Language="Binary" Debugging="true" />
  </Libraries>
</SwConfiguration>