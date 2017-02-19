function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Drive,

        [ValidateSet("AutoManagePagingFile","CustomSize","SystemManagedSize","NoPagingFile")]
        [System.String]
        $Type,

        [System.Int64]
        $InitialSize,

        [System.Int64]
        $MaximumSize
    )

    $returnValue = @{
    Drive = [string]::Empty
    Type = [string]::Empty
    InitialSize = 0
    MaximumSize = 0
    }

    [bool]$isSystemManaged = (Get-CimInstance -ClassName Win32_ComputerSystem).AutomaticManagedPagefile
    
    if($isSystemManaged)
    {
        $returnValue.Type = 'AutoManagePagingFile'
        return $returnValue
    }
    
    $driveItem = [System.IO.DriveInfo]$Drive
    $virtualMemoryInstance = Get-CimInstance -ClassName Win32_PageFileSetting | 
        Where-Object {([System.IO.DriveInfo](Split-Path -Name $PSItem.Name)).Name -eq $driveItem.Name}
    
    if(-not $virtualMemoryInstance)
    {
        $returnValue.Type = 'NoPagingFile'
        return $returnValue
    }

    if($virtualMemoryInstance.InitialSize -eq 0 -and $virtualMemoryInstance.MaximumSize -eq 0)
    {
        $returnValue.Type = 'SystemManagedSize'
    }
    else
    {
        $returnValue.Type = "CustomSize"
    }

    $returnValue.InitialSize = $virtualMemoryInstance.InitialSize
    $returnVAlue.MaximumSize = $virtualMemoryInstance.MaximumSize

    $returnValue
    
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Drive,

        [ValidateSet("AutoManagePagingFile","CustomSize","SystemManagedSize","NoPagingFile")]
        [System.String]
        $Type,

        [System.Int64]
        $InitialSize,

        [System.Int64]
        $MaximumSize
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."

    #Include this line if the resource requires a system reboot.
    #$global:DSCMachineStatus = 1


}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Drive,

        [ValidateSet("AutoManagePagingFile","CustomSize","SystemManagedSize","NoPagingFile")]
        [System.String]
        $Type,

        [System.Int64]
        $InitialSize,

        [System.Int64]
        $MaximumSize
    )

    #Write-Verbose "Use this cmdlet to deliver information about command processing."

    #Write-Debug "Use this cmdlet to write debug information while troubleshooting."


    <#
    $result = [System.Boolean]
    
    $result
    #>
}


Export-ModuleMember -Function *-TargetResource

