<# 
.NAME
VDGDownloder

.Description
This Tool will download All VDG Regional Airports and Airfields (MSFS)
Support Microsoft Store And Steam

.NOTES
Author: Amir Shnurman
Date Created: 9.1.2022
tested with windowss powershell 5.1
    
#>


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()


Function Get-PSScriptPath {

<#

.SYNOPSIS
Returns the current filepath of the .ps1 or compiled .exe with Win-PS2EXE.

.DESCRIPTION
This will return the path of the file. This will work when the .ps1 file is
converted with Win-PS2EXE

.NOTES
Author: Ste
Date Created: 2021.05.03
Tested with PowerShell 5.1 and 7.1.
Posted here: https://stackoverflow.com/q/60121313/8262102

.PARAMETER None
NA

.INPUTS
None. You cannot pipe objects to Get-PSScriptPath.

.OUTPUTS
Returns the current filepath of the .ps1 or compiled .exe with Win-PS2EXE.

.EXAMPLE (When run from a .ps1 file)
PS> Get-PSScriptPath
PS> C:\Users\Desktop\temp.ps1

.EXAMPLE (When run from a compiled .exe file with Win-PS2EXE.
PS> Get-PSScriptPath
PS> C:\Users\Desktop\temp.exe

#>

if ([System.IO.Path]::GetExtension($PSCommandPath) -eq '.ps1') {
  $psScriptPath = $PSCommandPath
  } else {
    # This enables the script to be compiles and get the directory of it.
    $psScriptPath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
  }
  return $psScriptPath
}

$Location = Get-PSScriptPath
$Location =  Split-Path -Path $Location


function Start-Download
{
    Param(
        $DownloadLinkParam,$downloadHAsh
    )
    $CommunityFolder = $TextBoxPath.Text


   
        write-host "Start Downlod"
      #  foreach ($templine in $downloads)
      #  {
            Write-Host "Download $DownloadLinkParam"
            Invoke-WebRequest -Uri $DownloadLinkParam -OutFile "c:\temp\vdgtemp\temp.rar" 
        


                            ##########################if (Test-Path "$CommunityFolder\barrodoy-airport-roshpina-llib")
                            ##########################{
                            ##########################    Remove-Item "$CommunityFolder\barrodoy-airport-roshpina-llib" -Recurse -Force
                            ##########################}
                           ####################### Invoke-WebRequest -Uri $DownloadLink -OutFile "c:\temp\vdgtemp\llib.rar" 
                            
                            $rarResult = Start-Process "$Location\unrar.exe" -ArgumentList "x","c:\temp\vdgtemp\temp.rar","$CommunityFolder" -Wait
                            #Start-Sleep -Seconds 15
                            
                
                         
                         $hash = (Get-FileHash -Path  "c:\temp\vdgtemp\temp.rar").hash 
                         #   $hash = (Get-DirHash -Path "$CommunityFolder\676").hash
                            if ($hash -eq $downloadHAsh)
                            {
                                Write-Host "file transfered complete" -ForegroundColor Green
                                Add-Content -Value "$DownloadLinkParam" -Path "$Location\GOODresults.txt" 
                            }
                            else
                            {
                                Write-Host "NOT GOOD !!!!!!  $hash " -ForegroundColor Red
                                Add-Content -Value "$DownloadLinkParam" -Path "$Location\BADresults.txt" 
                                ##Write-Host $hash
                            }

       # }
    
    Remove-Item -Path "c:\temp\vdgtemp\temp.rar" -Force
}

function Download-Zip
{
    Param(
        $DownloadLinkParam,$downloadHAsh
    )
  #  $CommunityFolder = $TextBoxPath.Text


   
        write-host "Start Downlod ZIP"
            Write-Host "Download $DownloadLinkParam"
            Invoke-WebRequest -Uri $DownloadLinkParam -OutFile "c:\temp\vdgtemp\temp.zip" 
                                                   
            $hash = (Get-FileHash -Path  "c:\temp\vdgtemp\temp.zip").hash 
            #   $hash = (Get-DirHash -Path "$CommunityFolder\676").hash
               if ($hash -eq $downloadHAsh)
               {
                                Write-Host "file transfered complete" -ForegroundColor Green
                                Add-Content -Value "$DownloadLinkParam" -Path "$Location\GOODresults.txt" 
                                
                                if ($downloadHAsh -eq "3F4B2C3EDA16AB3CA5291635EF579E37AB2A70EF67F23DF024E7A131C2421EA2")
                                {Expand-Archive -Path "C:\Temp\vdgtemp\temp.zip" -DestinationPath "$CommunityFolder\Herzlia_photo" -Force}
                                elseif ($downloadHAsh -eq '54B85B4836587F9595BA9BFABD64CD5D31490CF2B0BB9536D9D51147AE2747CC')
                                {Expand-Archive -Path "C:\Temp\vdgtemp\temp.zip" -DestinationPath "$CommunityFolder\barrodoy-haifa-4-photo" -Force}
                                else {Expand-Archive -Path "C:\Temp\vdgtemp\temp.zip" -DestinationPath $CommunityFolder -Force}
                                
               }
               else
               {
                   Write-Host "NOT GOOD !!!!!!  $hash " -ForegroundColor Red
                   Add-Content -Value "$DownloadLinkParam" -Path "$Location\BADresults.txt" 
                   ##Write-Host $hash
               }

      
    
   
            
            Remove-Item -Path "c:\temp\vdgtemp\temp.zip" -Force
}

function get-google
{
 param(
      [string]$GoogleFileId,
      [string]$FileDestination)
      
   
     
       Write-Host "Start Download "

      Invoke-WebRequest -Uri "https://drive.google.com/uc?export=download&id=$GoogleFileId" -OutFile "_tmp.txt" -SessionVariable googleDriveSession
      
      # Get confirmation code from _tmp.txt
      $searchString = Select-String -Path "_tmp.txt" -Pattern "confirm="
      $searchString -match "confirm=(?<content>.*)&amp;id="
      $confirmCode = $matches['content']
      
      # Delete _tmp.txt
      Remove-Item "_tmp.txt"
      
      # Download the real file
      Invoke-WebRequest -Uri "https://drive.google.com/uc?export=download&confirm=${confirmCode}&id=$GoogleFileId" -OutFile $FileDestination -WebSession $googleDriveSession
      #Start-BitsTransfer -Priority Foreground -Source "https://drive.google.com/uc?export=download&confirm=${confirmCode}&id=$GoogleFileId" -Destination E:\Temp\VDGCommunity\2222.zip -Dynamic
}


Function Delete-Community
{
    $FoldersToDelete = @(
"1barrodoy-llha-photo"
"Ashalim Photo"
"barnniv-jadeidi-makr"
"barrodoy-airport-herzlia-llhz"
"barrodoy-airport-meggido-llmg"
"barrodoy-airport-roshpina-llib"
"barrodoy-haifa-1-airport-llha"
"barrodoy-haifa-3-objects"
"barrodoy-haifa-4-photo"
"barrodoy-israelobjectslibrary"
"barrodoy-llar"
"barrodoy-lldm"
"barrodoy-lley"
"barrodoy-llrs"
"br-israelcelltowers"
"eilat"
"einvered-airport"
"Gvulot"
"Herzlia_photo"
"JM Photo"
"Kadshai Photoreal"
"LL1A - Hatzerim Northwest"
"LL62 2.0"
"llbs-4xgdi"
"ller"
"llet"
"LLEV Photo"
"LLIB_Photo"
"LLMG_Photo"
"LLMR Photo"
"llmr-airfield"
"LLMZ-1-Airport"
"LLMZ-2-AirportPhoto"
"LLNV"
"LLSM Shomrat"
"LLSM Shomrat-photo"
"nivtesler-kadshai"
"nivtesler-llks"
"nivtesler-llsd"
"nivtesler-shomrat"
"nivtesler-teladashim"
"pik-airport"
"Tel Adashim Photo"
"Adashim"
)
    
    foreach ($line in $foldersToDelete)
    {
        if (Test-Path "$CommunityFolder\$line")
        {
            Write-host "Deleting Old $line Folder"
            Remove-Item "$CommunityFolder\$line" -Force -Recurse
        }
    }


    Start-Sleep -Seconds 2
}




function Amir
{
param ($amlink,$amdest)

                            
$ParamList = @{

    Link = $amlink

    Destination = $amdest

}

$PowerShell = [powershell]::Create()

[void]$PowerShell.AddScript({

    Param ($Link, $Destination)

    Invoke-WebRequest -Uri $Link -OutFile $Destination
    

}).AddParameters($ParamList)

#Invoke the command




$PowerShell.Invoke()


$PowerShell.Dispose()



}

#region Logic

$SteamUserCFG = "$env:APPDATA\Microsoft Flight Simulator\UserCfg.opt"
$WIndowsStoreUserCFG = "$env:LOCALAPPDATA\Packages\Microsoft.FlightSimulator_8wekyb3d8bbwe\LocalCache\UserCfg.opt"
Remove-Item "$Location\GoodResults.txt" -Force -ErrorAction SilentlyContinue
Remove-Item "$Location\BadResults.txt" -Force -ErrorAction SilentlyContinue
#$DownloadLink = "https://vdgsim.com/site/downloads/MSFS/barrodoy-airport-roshpina-llib-26.10.21.rar"
#$downloads = get-content "C:\Users\amirs\OneDrive\MSFS 2020\VDG DOwnloader\DownloadsLinksTEST.txt"
$downloads = get-content "$Location\LinksToDownload2022.txt"
#$HT = @{}
#foreach ($line in $downloads)
#{
#    $HT.Add($line.Split(',')[0], $line.Split(',')[1])
#}



if (!(Test-Path c:\temp\vdgtemp))
{
    New-Item -ItemType Directory -Path c:\temp\vdgtemp -Force
}
Remove-Item C:\temp\vdgtemp\* -force -ErrorAction SilentlyContinue
 


if (Test-Path $SteamUserCFG)
{
    Write-Host "Steam User"
    $UserConfigFile = Get-Content $SteamUserCFG
}
elseif (Test-Path $WIndowsStoreUserCFG)
{
    Write-Host "WindowsStore User"
    $UserConfigFile = Get-Content $WIndowsStoreUserCFG
}
else
{
    $UserConfigFile = $null   
}


foreach ($line in $UserConfigFile)
{
    if ($line.StartsWith("InstalledPackagesPath"))
    {
        $CommunityFolder =  $line.Split(" ")[1].trim('"')
        $CommunityFolder += "\Community"
    }
}

#############################################################################################$DiskSpace = $null
#############################################################################################
#############################################################################################Get-Volume
#############################################################################################
#############################################################################################if(((Get-Volume -DriveLetter C).SizeRemaining / 1Gb) -lt 4)
#############################################################################################{
#############################################################################################     Write-Host "ERROR: Extremely Low Disk Space" -ForegroundColor White -BackgroundColor Red
#############################################################################################     $DiskSpace = "Error"
#############################################################################################}
#############################################################################################elseif (((Get-Volume -DriveLetter C).SizeRemaining / 1Gb) -lt 8)
#############################################################################################{
#############################################################################################    Write-Host "Warning: Low Disk Space" -ForegroundColor Black -BackgroundColor Yellow
#############################################################################################    $DiskSpace = "WARNING"
#############################################################################################}


##########################################################################################    Delete this  ###############################################
#$CommunityFolder = "C:\Temp\VDGCommunity"
################################################################################################################

#endregion

  


####


function Load-Form
{

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(1250,780)
$Form.text                       = "VDG Download"
$Form.TopMost                    = $True

$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.location            = New-Object System.Drawing.Point(75,48)
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$PictureBox1.Size = '300,300'

$PictureBox1.Image = [System.Convert]::FromBase64String('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')

$PictureBoxDownloading = New-Object System.Windows.Forms.PictureBox
$PictureBoxDownloading.Location = New-Object System.Drawing.Point(550,490)
$PictureBoxDownloading.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$PictureBoxDownloading.Size = "150,150"

$PictureBoxDownloading.Image = [System.Convert]::FromBase64String('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')


$MessagesLABEL =  New-Object System.Windows.Forms.Label
$MessagesLABEL.AutoSize = $True
$MessagesLABEL.Location = New-Object System.Drawing.Point(410,50)
#$MessagesLABEL.Text = "amir Shnurman test"
$MessagesLABEL.Visible = $false
$MessagesLABEL.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',16,[System.Drawing.FontStyle]::Regular)
$MessagesLABEL.ForeColor = 'RED'

$MessageWelcome = New-Object System.Windows.Forms.Label
$MessageWelcome.Location = New-Object System.Drawing.Point(410,50)
$MessageWelcome.AutoSize = $True
$MessageWelcome.Visible = $True
$MessageWelcome.ForeColor = 'Black'
$MessageWelcome.Text = "# VDGDownloader
Download All VDG Regional Airports and Airfields (MSFS)

This Tool Downloads VDG Regional Airports and Airfields for MSFS 2020 Users.
platfom suported are Windows Store And Steam.

The tool locate the Community folder Automaticlly and extract the Downloaded Content into that folder.

**************** please make a backup copy of your Community Foder   **************

The Tool deletes old content by itself and upgrade it.

Please Run The Tool from Command Line (CMD) So you can See the Progress And Messages on the fly.

"


$ButtonCancel                         = New-Object system.Windows.Forms.Button
$ButtonCancel.text                    = "Cancel"
$ButtonCancel.width                   = 90
$ButtonCancel.height                  = 30
$ButtonCancel.location                = New-Object System.Drawing.Point(253,714)
$ButtonCancel.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$ButtonCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$ButtonStart                         = New-Object system.Windows.Forms.Button
$ButtonStart.text                    = "Start"
$ButtonStart.width                   = 90
$ButtonStart.height                  = 30
$ButtonStart.location                = New-Object System.Drawing.Point(523,714)
$ButtonStart.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$ButtonStart.Add_Click({

                            $CommunityFolder = $TextBoxPath.Text
                            $ButtonStart.Enabled = $false
                            Delete-Community
                            $ProgressBar.Visible = $true
                            $MessageWelcome.Visible = $false
                            


                            Download-Zip -DownloadLinkParam "https://vdgsim.com/site/downloads/MSFS/LLER/ller_v2_G3c_J.zip" -downloadHAsh "66CED7BA8B7F6A21EB3FCCC5824651A55DE3412A2E62419EAFEC8C5F1A28A0ED"
                            $ProgressBar.Value = 2
                            Download-Zip -DownloadLinkParam "https://vdgsim.com/site/downloads/MSFS/LLET/llet_vLHo3.zip" -downloadHAsh "5CAFD8887EB8E7B6DB0B7CE5CA61B7042BC74E1B473E857AF52D3C80FBDC4FBB"
                            $ProgressBar.Value = 4
                          #  Amir -amlink "https://speed.hetzner.de/1GB.bin" -amdest "C:\Temp\vdgtemp\1.tmp"

                         # Start-BitsTransfer "https://speed.hetzner.de/1GB.bin" -Asynchronous -Priority Foreground -Destination C:\Temp\vdgtemp\1.tmp
                           foreach ($tempLine in $downloads)
                                {
                                        Start-Download -DownloadLinkParam $templine.Split(',')[0] -downloadHAsh $templine.Split(',')[1]
                                        $ProgressBar.Value += 1
                                        #$ProgressBar1.Value += 2.9
                                }

                        #    Download-Zip -DownloadLinkParam "https://testvdg.blob.core.windows.net/vdgdownloader/Herzlia_photo.zip" -downloadHAsh "3F4B2C3EDA16AB3CA5291635EF579E37AB2A70EF67F23DF024E7A131C2421EA2"

                         #   Download-Zip -DownloadLinkParam "https://testvdg.blob.core.windows.net/vdgdownloader/barrodoy-haifa-4-photo.zip" -downloadHAsh '54B85B4836587F9595BA9BFABD64CD5D31490CF2B0BB9536D9D51147AE2747CC'

                            $ProgressBar.value = 50
                            $ButtonCancel.Text = "Close"

                            if (Test-Path "$Location\BADresults.txt")
                            {
                               $MessagesLABEL.Text = "There is error(s) Downloading, `n Please Look at `n `n $("$Location\Badresults.txt") `n `n for details"
                               $MessagesLABEL.ForeColor = 'RED'
                               $MessagesLABEL.Visible = $true
                            }
                            else
                            {
                                $MessagesLABEL.Text = "Downloading `n Complete `n Successfully "
                                $MessagesLABEL.ForeColor = 'Green'
                                $MessagesLABEL.Visible = $true
                            }

                 

                            
                       })


$RadioButtonWindowsStore         = New-Object system.Windows.Forms.RadioButton
$RadioButtonWindowsStore.text    = "WindowsStore"
$RadioButtonWindowsStore.AutoSize  = $true
$RadioButtonWindowsStore.width   = 104
$RadioButtonWindowsStore.height  = 20
$RadioButtonWindowsStore.location  = New-Object System.Drawing.Point(419,67)
$RadioButtonWindowsStore.Font    = New-Object System.Drawing.Font('Microsoft Sans Serif',12)
$RadioButtonWindowsStore.Add_Click({write-host "WindowsStore Pressed"})

$RadioButtonSteam                = New-Object system.Windows.Forms.RadioButton
$RadioButtonSteam.text           = "Steam"
$RadioButtonSteam.AutoSize       = $true
$RadioButtonSteam.width          = 104
$RadioButtonSteam.height         = 20
$RadioButtonSteam.location       = New-Object System.Drawing.Point(616,65)
$RadioButtonSteam.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',12)
$RadioButtonSteam.Add_Click({write-host "Steam Pressed"})

$TextBoxPath                     = New-Object system.Windows.Forms.TextBox
$TextBoxPath.multiline           = $false
$TextBoxPath.width               = 700
$TextBoxPath.height              = 20
$TextBoxPath.location            = New-Object System.Drawing.Point(72,511)
$TextBoxPath.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',14)
$TextBoxPath.Text = $CommunityFolder.Trim('"')
$TextBoxPath.Enabled = $false

$CommunityLabel                  = New-Object system.Windows.Forms.Label
$CommunityLabel.text             = "Community Folder Path:"
$CommunityLabel.AutoSize         = $true
$CommunityLabel.width            = 25
$CommunityLabel.height           = 10
$CommunityLabel.location         = New-Object System.Drawing.Point(72,481)
$CommunityLabel.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$CheckBoxCustomCommunity                       = New-Object system.Windows.Forms.CheckBox
$CheckBoxCustomCommunity.text                  = "Custom Community Folder"
$CheckBoxCustomCommunity.AutoSize              = $false
$CheckBoxCustomCommunity.width                 = 350
$CheckBoxCustomCommunity.height                = 20
$CheckBoxCustomCommunity.location              = New-Object System.Drawing.Point(72,550)
$CheckBoxCustomCommunity.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$CheckBoxCustomCommunity.Add_Click({
                                        if ($CheckBoxCustomCommunity.Checked)
                                        {
                                            $TextBoxPath.Enabled = $True
                                        }
                                        else
                                        {
                                            $TextBoxPath.Enabled = $false
                                        }
                                   })


$DataGridView1                   = New-Object system.Windows.Forms.DataGridView
$DataGridView1.width             = 300
$DataGridView1.height            = 250
$DataGridView1.location          = New-Object System.Drawing.Point(401,287)
$DataGridView1.ColumnCount = 2
$DataGridView1.ColumnHeadersVisible = $True
$DataGridView1.Columns[0].Name = "Link"


    $ProgressBar = New-Object System.Windows.Forms.ProgressBar
    $ProgressBar.Location = New-Object System.Drawing.Point(223,609)
    $ProgressBar.Size = New-Object System.Drawing.Size(460, 40)
    $ProgressBar.Minimum = 1
    $ProgressBar.Maximum = 50
    ##$ProgressBar.Style = "Marquee"
    #$ProgressBar.MarqueeAnimationSpeed = 20
    $ProgressBar.Visible = $false
    #$ProgressBar.Left = "Amir"



$Form.controls.AddRange(@($MessageWelcome,$PictureBox1,$ButtonCancel,$ButtonStart,$ProgressBar,$TextBoxPath,$CommunityLabel,$CheckBoxCustomCommunity,$MessagesLABEL))
if ($DiskSpace -eq "Error")
{
    $MessagesLABEL.Text = "Low Disk Space On C Drive"
    $ButtonStart.Enabled = $false
    $MessagesLABEL.BackColor ="RED"

}
elseif ($DiskSpace -eq "WARNING")
{
    $MessagesLABEL.Text = 'Low Disk Space On C Drive'
    $ButtonStart.Enabled = $True
    $MessagesLABEL.BackColor ="Yellow"
}




$Form.ShowDialog()

}


Load-Form

#Load-Form

