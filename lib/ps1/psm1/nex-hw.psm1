
Function Get-NxCim()
{
	param (
		[switch]$Os = $false,
		[switch]$Cpu = $false,
		[switch]$Bios = $false,
		[switch]$Memory = $false,
		[switch]$Computer = $false,
		[switch]$Process = $false,
		[switch]$Service = $false,
		[switch]$Adapter = $false,
		[switch]$Disk = $false,
		[switch]$Usb = $false,
		[switch]$PnP = $false,
		[switch]$PnPResource = $false,
		[switch]$Pci = $false,
		[switch]$Temperature = $false,
		[switch]$Fan = $false,
		[switch]$Heat = $false,
		[switch]$Infrared = $false,
		[switch]$NetRdma = $false,
		[switch]$Keyboard = $false,
		[switch]$Video = $false,
		[switch]$Mother = $false
	)

	Function Out-NxCim() {
		param (
			[Parameter(Position = 0)]
			[string]$Check,
			[Parameter(Position = 1)]
			[string]$Name
		)
		if ($Check -eq $true) {
			Write-Host -Foreground Blue -NoNewLine "`n`n$Name"
			Get-CimInstance -ClassName $Name | Format-List -Property * | Out-Host -P
		}
	}

	Out-NxCim $Os "Win32_OperatingSystem"
	Out-NxCim $Computer "Win32_ComputerSystem"
	Out-NxCim $Process "Win32_Process"
	Out-NxCim $Service "Win32_Service"
	Out-NxCim $Cpu "Win32_Processor"
	Out-NxCim $Bios "Win32_BIOS"
	Out-NxCim $Memory "Win32_PhysicalMemory"
	Out-NxCim $Adapter "Win32_NetworkAdapter"
	Out-NxCim $Video "Win32_VideoController"
	Out-NxCim $Disk "Win32_DiskDrive"
	Out-NxCim $Mother "Win32_MotherboardDevice"
	Out-NxCim $Usb "Win32_USBHub"
	Out-NxCim $PnP "Win32_PnPEntity"
	Out-NxCim $Keyboard "Win32_Keyboard"
	Out-NxCim $PnPResource "Win32_PnPAllocatedResource"
	Out-NxCim $Pci "Win32_PCIController"
	Out-NxCim $Temperature "Win32_TemperatureProbe"
	Out-NxCim $Fan "Win32_Fan"
	Out-NxCim $Heat "Win32_HeatPipe"
	Out-NxCim $Infrared "Win32_InfraredDevice"
	Out-NxCim $NetRdma "MSFT_NetAdapterRdma"
}

Function Get-KeyCode()
{
	$last = $null
	Write-Host "Hold the keys you want to test, then press others. Press 'Ctrl-C' to end the test."
	while ($true) {
		$k = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		"{0} ({1})" -f $k.Character, $k.VirtualKeyCode
		if ($k.VirtualKeyCode -eq $last) {
			"Chatter detected: $($k.VirtualKeyCode)"
		}
		$last = $k.VirtualKeyCode
	}
}

