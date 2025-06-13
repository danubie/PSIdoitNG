function Get-IdoitObject {
    <#
      .SYNOPSIS
      Get-IdoitObject returns an object from the i-doit API or $null.

      .DESCRIPTION
      Get-IdoitObject returns an object or $null.

      .EXAMPLE
      Get-IdoitObject -ObjId 540

      .PARAMETER ObjId
       The id of the object you want to retrieve from the i-doit API.
      #>
    [cmdletBinding(ConfirmImpact = 'Low')]
    [OutputType([Object])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        # [Alias('Id')]
        [int] $ObjId
    )

    process {
        $apiResult = Invoke-Idoit -Method 'cmdb.object.read' -Params @{ id = $ObjId }
        if ($null -eq $apiResult.id) {          # is it a null array?
            Write-Error -Message "Object not found Id=$ObjId"
            return
        }
        $apiResult.PSObject.TypeNames.Insert(0, 'Idoit.Object')
        $apiResult | Add-Member -MemberType NoteProperty -Name 'ObjId' -Value $ObjId -Force
        $apiResult | Add-Member -MemberType NoteProperty -Name 'TypeId' -Value $apiResult.objecttype -Force
        $apiResult
    }
}

