function ConvertTo-PesterTestObject {
    <#
    .SYNOPSIS
    Helps with converting given objects to their string representation.
    Main use is to convert enties from $Global:IdoitApiTrace to a string representation

    .DESCRIPTION
     Helps with converting given objects to their string representation.

    .PARAMETER Objects
    Objects to convert to string representation.

    .PARAMETER IncludeProperties
    Properties to include in the string representation.

    .PARAMETER ExcludeProperties
    Properties to exclude from the string representation.

    .PARAMETER OutputType
    Type of the output object. Options are: Hashtable, Ordered, PSCustomObject. If not specified, the output type is hashtable (string)

    .PARAMETER NumbersAsString
    If specified, numbers are converted to strings. Default is number are presented in their (unquoted) numerica form

    .PARAMETER QuotePropertyNames
    If specified, all property names are quoted. Default: property names are quoted only if they contain spaces.

    .PARAMETER DateTimeFormat
    Format for DateTime values. Default: 'yyyy-MM-dd HH:mm:ss'

    .PARAMETER Depth
    Depth of the object to convert.

    .PARAMETER Delimiter
    Delimiter for the output string. Default: `n (new line).
    Options are: `n (new line), ' ' (space)

    .EXAMPLE
    Get-Process -Name "PowerShell" | ConvertFrom-ObjectToString -IncludeProperties 'ProcessName', 'Id', 'Handles'

    OUTPUT:
    @{
        'Handles' = '543'
        'Id' = '8092'
        'ProcessName' = 'powershell'
    }

    @{
        'Handles' = '636'
        'Id' = '11360'
        'ProcessName' = 'powershell'
    }

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory)]
        [Array] $Objects,
        [string[]] $IncludeProperties,
        [string[]] $ExcludeProperties,
        [ValidateSet('Hashtable', 'Ordered', 'PSCustomObject')]
        [string] $OutputType = 'Hashtable',
        [switch] $NumbersAsString,
        [switch] $QuotePropertyNames,
        [string] $DateTimeFormat = 'yyyy-MM-dd HH:mm:ss',
        [int] $Depth,
        [ValidateSet('`n', ' ')]
        [string] $Delimiter = "`n"
    )
    begin {
        if ($OutputType -eq 'Hashtable') {
            $Type = ''
        } elseif ($OutputType -eq 'Ordered') {
            $Type = '[Ordered] '
        } else {
            $Type = '[PSCustomObject] '
        }
    }
    process {
        filter IsNumeric() {
            return $_ -is [byte] -or $_ -is [int16] -or $_ -is [int32] -or $_ -is [int64]  `
                -or $_ -is [sbyte] -or $_ -is [uint16] -or $_ -is [uint32] -or $_ -is [uint64] `
                -or $_ -is [float] -or $_ -is [double] -or $_ -is [decimal]
        }
        function GetFormattedPair () {
            # returns 'key' = <valuestring> or just <valuestring> if key is empty
            # valuestring is either $null, '<string>', or number
            param (
                [string] $Key,
                [object] $Value
            )
            if ($key -eq '') {
                $left = ''
            } elseif ($key -match '\s' -or $QuotePropertyNames) {
                $left = "'$Key' = "
            } else {
                $left = "$Key = "
            }
            if ($null -eq $value) {
                "$left`$null"
            } elseif ($Value -is [System.Collections.IList]) {
                $arrayStrings = foreach ($element in $Object.$Key) {
                    GetFormattedPair -Key '' -Value $element
                }
                "$left@(" + ($arrayStrings -join ",$Delimiter)$Delimiter)")

            } elseif ($Value -is [System.Collections.IDictionary]) {
                if ($IncludeProperties -and $Key -notin $IncludeProperties) {
                    return
                }
                if ($Key -in $ExcludeProperties) {
                    return
                }
                $propertyString = foreach ($Key in $Value.Keys) {
                    GetFormattedPair -Key $key -Value $Value[$key]
                }
                "$left@{" + ($propertyString -join '; ') + "}"
            } elseif ($value -is [DateTime]) {
                "$left'$($Value.ToString($DateTimeFormat))'"
            } elseif ($Value -is [boolean]) {
                # boolean values are not quoted
                "$left`$$($Value.ToString().ToLowerInvariant())"
            } elseif (($value | IsNumeric) -and -not $NumbersAsString) {
                "$left$($Value)"
            } else {
                $value = $Value -replace "'","''"       # escape single quotes for PowerShell strings
                "$left'$($value)'"
            }
        }

        $outerResult = foreach ($Object in $Objects) {
            Write-Verbose "Processing $($Object.GetType().FullName); $Object"
            if ($Object -is [System.ValueType] -or $Object -is [string] -or $Object -is [char] -or $Object -is [bool] -or $Object -is [DateTime]) {
                $result = "$(GetFormattedPair -Key '' -Value $Object)"
                Write-Output $result
                Write-Verbose "   Result from ValueType: $result"
                continue
            }

            if ($Object -is [System.Collections.IDictionary]) {
                $tempObj = [PSCustomObject] $Object
                $splatType = @{}
                if ($Object.GetType() -eq 'OrderedDictionary') {
                    $splatType.OutputType = 'Ordered'
                }
                $result = ConvertTo-PesterTestObject -Objects $tempObj @PSBoundParameters -Depth $Depth @splatType  # Depth is the same, because just converting the object
                Write-Output $result
                Write-Verbose "   Result from IDictionary: $result"
                continue
            }
            if ($Object -is [Object]) {
                $objResult = foreach ($Key in $Object.PSObject.Properties.Name) {
                    if ($IncludeProperties -and $Key -notin $IncludeProperties) {
                        continue
                    }
                    if ($Key -in $ExcludeProperties) {
                        continue
                    }
                    if ($null -eq $Object.$key) {
                        Write-Verbose "   Skipping empty property: $Key"
                        continue
                    }
                    if ($Object.$Key -is [System.ValueType] -or $Object.$Key -is [string] -or $Object.$Key -is [char] -or $Object.$Key -is [bool] -or $Object.$Key -is [DateTime]) {
                        $result = "$(GetFormattedPair -Key $Key -Value $Object.$Key)"
                        Write-Output "$result"
                        Write-Verbose "   Result from ValueType2 in Object: $result"
                        continue
                    }
                    if ($Object.$Key -is [System.Collections.IList]) {      # e.g. ordered dictionary
                        $arrayStrings = foreach ($arrElement in $Object.$Key) {
                            $result = ConvertTo-PesterTestObject @PSBoundParameters -Objects $arrElement -Depth ($Depth - 1)
                            $result
                        }
                        $result = "$Key=@($Delimiter$($arrayStrings -join ", $Delimiter") $Delimiter)"
                        Write-Output "$result"
                        Write-Verbose "   Result from IList in Object: $result"
                        continue
                    }
                    If ($Object.$Key -is [System.Collections.IDictionary]) {
                        $dictResult = ConvertTo-PesterTestObject @PSBoundParameters -Objects $Object.$Key -Depth ($Depth - 1)
                        $result = "$Key = $dictResult"
                        $result
                        Write-Verbose "   Result from dict in Object: $result"
                        continue
                    }
                    $result = ConvertTo-PesterTestObject @PSBoundParameters -Objects $Object.$Key -Depth ($Depth - 1)
                    $result = "$Key=$result"
                    Write-Output "$result"
                    Write-Verbose "   Result from Objectresults in Object: $result"
                }
                $result = "$Type@{$Delimiter$($objResult -join "";$Delimiter"")$Delimiter}"
                Write-Output $result
                if ($null -ne $objResult) {
                    Write-Verbose "   Result from Object3 $($objResult.GetType()): [$result]"
                }
            } else {
                Write-Error "Would not expect this type of object: $($Object.GetType().FullName)"
            }
        }
        if ($outerResult -is [array]) {
            $outerResult = "@($Delimiter$($outerResult -join $Delimiter)$Delimiter)"
        }
        $outerResult
        Write-Verbose "OuterResult: $outerResult"
    }
}

# $Global:IdoitApiTrace[0] | ConvertTo-PesterTestObject -Depth 10 -OutputType PSCustomObject
# $Global:IdoitApiTrace[0] | ConvertTo-PesterTestObject -Depth 10 -OutputType PSCustomObject -Delimiter " "

# @{
#     arr1 = @(
#         [ordered]@{
#             x=1;
#             arr2=@(
#                 @{y='huhu'};
#                 @{a=2;b=3}
#             )
#         }
#     )
# }      | ConvertTo-PesterTestObject -OutputType PSCustomObject -Depth 10

# TODO: In diesem Beispiel wird arr2 als Arry von PSCustomObject dargestellt, sollte aber als Array von Hashtable dargestellt werden
# [PSCustomObject]@{
#     arr1 = @(
#         [PSCustomobject]@{
#             x=1;
#             arr2=@(
#                 @{y='huhu'};
#                 @{a=2;b=3}
#             )
#         }
#     )
# }      | ConvertTo-PesterTestObject -OutputType PSCustomObject -Depth 10 -Verbose | scb -PassThru

# [pscustomobject]@{x=1;y='huhu';z=[ordered]@{a=2;b=3}}  | ConvertTo-PesterTestObject -OutputType PSCustomObject

# [ordered]@{x=1;y='huhu';z=@{a=2;b=3}} | ConvertTo-PesterTestObject

# @{x=1;y='huhu';z=@{a=2;b=3}}  | gm

# $Global:IdoitApiTrace[-1] | ConvertTo-PesterTestObject -Depth 10 -OutputType PSCustomObject | scb -PassThru


# $test = @(
#     [PSCustomObject]@{
#         id             = 1
#         objID          = 540
#         quantity       = $null
#         title          = [PScustomObject]@{id=1; title='DDRAM'; const=$null; title_lang='DDRAM'}
#         manufacturer   = [PScustomObject]@{id=1; title='Kingston'; const=$null; title_lang='Kingston'}
#         capacity       = [PScustomObject]@{title=64}
#         description    = ''
#     }
#     [PSCustomObject]@{
#         id             = 2
#         objID          = 540
#         quantity       = $null
#         title          = [PScustomObject]@{id=1; title='DDRAM'; const=$null; title_lang='DDRAM'}
#         manufacturer   = [PScustomObject]@{id=1; title='Kingston'; const=$null; title_lang='Kingston'}
#         capacity       = [PScustomObject]@{title=64}
#         description    = ''
#     }
# )
# ConvertTo-PesterTestObject -Objects $test -OutputType PSCustomObject -Depth 10 -Verbose | scb -PassThru