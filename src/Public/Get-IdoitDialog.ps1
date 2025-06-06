function Get-IdoitDialog {
    <#
    .SYNOPSIS
        Get the dialog for a specific category and property from i-doit.

    .DESCRIPTION
        This function retrieves the dialog for a specific category and property.
        It returns a list of options available for the specified category and property.

    .PARAMETER Category
        The category name (title) for which the dialog is requested.
        Example: 'C__CATG__CPU'

    .PARAMETER Property
        The property name (title) for which the dialog is requested.
        Example: 'manufacturer'

    .PARAMETER params
        A hashtable containing the parameters for the dialog.
        The hashtable should contain at least the keys 'category' and 'property'.
        Example: @{ category='C__CATG__CPU'; property='manufacturer' }

    .EXAMPLE
        Get-IdoitDialog -params @{ category='C__CATG__CPU'; property='manufacturer' }
        Retrieves the dialog options for the CPU category and manufacturer property.

    .NOTES
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default')]
        [ValidateNotNullOrEmpty()]
        [string] $Category,        # category id, e.g. 'C__CATG__CPU'

        [Parameter(Mandatory = $true, ParameterSetName = 'Default')]
        [ValidateNotNullOrEmpty()]
        [string] $Property,        # property id, e.g. 'manufacturer'


        [Parameter(Mandatory = $true, ParameterSetName = 'ByParams')]
        [ValidateNotNullOrEmpty()]
        [hashtable] $params             # parameters for the dialog, e.g. @{ category='C__CATG__CPU'; property='manufacturer' }
    )

    begin {

    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Default') {
            $params = @{
                category  = $Category
                property  = $Property
            }
        }
        $apiResult = Invoke-IdoIt -Endpoint 'cmdb.dialog' -Params $params
        foreach ($dialog in $apiResult) {
            $dialog | Add-Member -MemberType NoteProperty -Name 'ParentId' -Value $Id -Force
            $dialog.PSObject.TypeNames.Insert(0, 'Idoit.IdoitDialogItem')
            Write-Output $dialog
        }
    }

    end {

    }
}