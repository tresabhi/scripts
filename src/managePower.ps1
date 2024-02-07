$QRes = 'C:\Program Files\QRes\QRes.exe'

$HighRefreshRate = 165
$LowRefreshRate = 60

$BatterSaverThreshold = 20

$HighPowerPlan = '7ccda3ca-bcb1-4b50-b303-c44682ab3312'
$LowPowerPlan = '381b4222-f694-41f0-9685-ff5bb260df2e'
$GPUID = 'PCI\VEN_10DE&DEV_24DD&SUBSYS_88FD103C&REV_A1\4&33EB62B0&0&0008'

If ((Get-WmiObject win32_battery).BatteryStatus -eq 2) {
  # running on ac power

  & $QRes /r:$HighRefreshRate
  
  powercfg /S $HighPowerPlan
  powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD $BatterSaverThreshold
  powercfg /setactive scheme_current
  
  Enable-PnpDevice -InstanceID $GPUID -Confirm:$false
}
else {
  # running on battery

  & $QRes /r:$LowRefreshRate

  powercfg /S $LowPowerPlan
  powercfg /setdcvalueindex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD 100
  powercfg /setactive scheme_current
  
  # WARNING: ONLY DISABLE THE GPU IF YOU HAVE DUAL INTEGRATED AND DISCRETE GRAPHICS
  Disable-PnpDevice -InstanceID $GPUID -Confirm:$false
}