function New-IdoitObject {
    <#
    .SYNOPSIS
    Create a new i-doit object.

    .DESCRIPTION
    This function creates a new object in i-doit with the specified name, type, category, purpose, status, and description.
    It checks if an object with the same name already exists, and if so, it throws an error unless the `-AllowDuplicates` switch is set.

    .PARAMETER Name
    The name of the object to create. This is a mandatory parameter. Alias: Title

    .PARAMETER ObjectType
    The type of the object to create.

    .PARAMETER Category
    An array of categories to assign to the object. This is optional.

    .PARAMETER Purpose
    The purpose of the object. Valid entries can be found in the i-doit documentation.

    .PARAMETER Status
    The status of the object. Valid entries can be found in the i-doit documentation.

    .PARAMETER Description
    A description for the object. This is optional.

    .PARAMETER AllowDuplicates
    A switch to allow creating an object with the same name as an existing object. If this switch is not set, the function will throw an error if an object with the same name already exists.

    .EXAMPLE
    New-IdoitObject -Name "New Server" -ObjectType "C__OBJTYPE__SERVER" -Category "C__CATG__GLOBAL" -Purpose "In production" -Status 'C__CMDB_STATUS__IN_OPERATION' -Description "This is a new server object."
    This command creates a new server object in i-doit with the specified name, type, category, purpose, status, and description.

    .NOTES
    The function is intended to create *new* object of a specific type.
    If you want to create an object with the same name as an existing object, use the `-AllowDuplicates` switch.
    If you want to update an existing object, use the `Set-IdoitObject` function instead.

    #>
    [CmdletBinding(SupportsShouldProcess = $True)]
    param (
        [Parameter( Mandatory = $True, ValueFromPipelineByPropertyName = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias( 'Title' )]
        [string] $Name,

        [Parameter( Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [string] $ObjectType,

        [Parameter( ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [hashtable] $Category = @{},

        [Parameter( ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [string] $Purpose,

        [Parameter( ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [Alias( 'cmdb_status')]
        [string] $Status,

        [Parameter( ValueFromPipelineByPropertyName = $True)]
        [ValidateNotNullOrEmpty()]
        [string] $Description,

        [Parameter( ValueFromPipelineByPropertyName = $True)]
        [Switch] $AllowDuplicates
    )

    begin {

    }

    process {
        # by default, an object of this type and name should not exist
        if (-not $AllowDuplicates) {
            $obj = Search-IdoItObject -Conditions @{"property" = "C__CATG__GLOBAL-title"; "comparison" = "="; "value" = $Name} -ErrorAction SilentlyContinue
            if ($null -ne $obj) {
                Write-Error "An object with the name '$Name' already exists (Id=$($obj.ObjId)). Use -AllowDuplicates to create a new object with the same name."
                return
            }
        }
        $params = @{
            title        = $Name
            type  = $ObjectType
        }
        # Prepare the categories the way the API expects them (PSCUstomObject, each category is a property, each value in a property is an array of PSCustomObjects)
        if ($Category.Keys.Count -gt 0) {
            $allKeys = [string[]]$Category.Keys
            foreach ($catNameKey in $allKeys) {
                $Category[$catNameKey] = @($Category[$catNameKey])
            }
            $params.categories = [PSCustomObject]$Category
        }
        if ('' -ne $Purpose) {
            $params.purpose = $Purpose
        }
        if ('' -ne $Status) {
            $params.status = $Status
        }
        if ('' -ne $Description) {
            $params.description = $Description
        }
        if ($PSCmdlet.ShouldProcess("Creating object '$Name' of type '$ObjectType'")) {
            # check the creation of the object itself
            $apiResult = Invoke-IdoIt -Method 'cmdb.object.create' -Params $params
            if ($apiResult.Success) {
                Add-Member -InputObject $apiResult -MemberType NoteProperty -Name 'ObjId' -Value $apiResult.id -Force
            }
            # each cat created should return an array of [int]. If it is a string, this is the error message
            if ($null -ne $apiResult.categories) {
                foreach ($catResult in $apiResult.categories.PSObject.Properties) {
                    for ($i = 0; $i -lt $catResult.Value.Count; $i++) {
                        if ($catResult.Value[$i] -is [int] -or $catResult.Value[$i] -is [int64]) {
                            Write-Verbose "Category '$($catResult.Name)' created with Id: $($catResult.Value[$i])"
                        } else {
                            Write-Error "Error creating category '$($catResult.Name)': $($catResult.Value[$i])"
                        }
                    }
                }
            }
            Write-Verbose "Created object with Id: $($apiResult.id)"
            $apiResult.categories.PSObject.Properties | ForEach-Object {
                Write-Verbose "Category: $($_.Name)"
                Write-Verbose "Category properties: $($_.Value)"
            }
            Write-Output $apiResult
        }
    }

    end {

    }
}