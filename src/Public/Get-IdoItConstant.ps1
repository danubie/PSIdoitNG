Function Get-IdoItConstant {
    <#
        .SYNOPSIS
        Get-IdoItConstant

        .DESCRIPTION
        It retrieve all constants from the API (objTypes, categories, global and specific categories).

        .OUTPUTS
        Returns a list Type of constant, name and value.

        .EXAMPLE
        Get-IdoItConstant
        Returns all the constants.

        .NOTES
    #>
        [CmdletBinding()]
        $params = @{}

        $result = Invoke-IdoIt -Method "idoit.constants" -Params $params
        # one of the things, which are wierd in this API
        # result is an object having a property by type of constant
        # e.g. $result.objectTypes, $result.Categories.G, $result.Categories.S, recordStates, ...
        # Each of this properties is set up as a object having a property by contstant name
        # and a value of the text (or title?) of that constant

        Convert-PropertyToArray -InputObject $result.objectTypes | Select-Object @{ name='Type'; Expression={'ObjectType'} }, Name, Value
        Convert-PropertyToArray -InputObject $result.recordStates | Select-Object @{ name='Type'; Expression={'RecordState'} }, Name, Value
        Convert-PropertyToArray -InputObject $result.Categories.G | Select-Object @{ name='Type'; Expression={'GlobalCategory'} }, Name, Value
        Convert-PropertyToArray -InputObject $result.Categories.S | Select-Object @{ name='Type'; Expression={'SpecificCategory'} }, Name, Value
        Convert-PropertyToArray -InputObject $result.Categories.g_custom | Select-Object @{ name='Type'; Expression={'CustomCategory'} }, Name, Value
        Convert-PropertyToArray -InputObject $result.relationTypes | Select-Object @{ name='Type'; Expression={'RelationType'} }, Name, Value
        Convert-PropertyToArray -InputObject $result.staticObjects | Select-Object @{ name='Type'; Expression={'StaticObject'} }, Name, Value
    }