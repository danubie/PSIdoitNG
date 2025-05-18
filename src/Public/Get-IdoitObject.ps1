function Get-IdoitObject {
    <#
      .SYNOPSIS
      Get-IdoitObject returns an object from the i-doit API or $null.

      .DESCRIPTION
      Get-IdoitObject returns an object or $null.

      .EXAMPLE
      Get-IdoitObject -Id 540

      .PARAMETER Id
       The id of the object you want to retrieve from the i-doit API.
      #>
    [cmdletBinding(ConfirmImpact = 'Low')]
    [OutputType([Object])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [int] $Id
    )

    process {
        $apiResult = Invoke-Idoit -Method 'cmdb.object.read' -Params @{ id = $Id }
        if ($null -ne $apiResult) {
            $apiResult.PSObject.TypeNames.Insert(0, 'Idoit.Object')
        }
        else {
            Write-Error -Message "Object not found Id=$Id"
        }
        $apiResult
    }
}

