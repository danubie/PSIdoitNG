Function Get-IdoitCategoryInfo {
    <#
        .SYNOPSIS
        Get-IdoitCategoryInfo

        .DESCRIPTION
        Get-IdoItCategoryInfo lets you discover all available category properties for a given category id.
        The list corresponds to the properties you will receive for each returned object after calling the cmdb.category.read method.

        .PARAMETER Category
        Look for category info by category name. This is the most common way to get category info.

        .PARAMETER CatgId
        Look for category info by category id of a global category.

        .PARAMETER CatsId
        Look for category info by category id of a s(?) category.

        .EXAMPLE
        PS>Get-IdoitCategoryInfo -Category 'C__CATG__CPU'
        Gives you detailed Info about every possible categaory value of this object.
        E.g. for 'C__CATG__CPU' you get title, manifacturer, type, frequency, cores, etc.
        ... cores: @{title=CPU cores; check=; info=; data=; ui=}
                   @{
                        title = 'CPU cores';
                        check = @{ mandatory = 'False' };
                        info  = @{ primary_field = 'False'; type = 'int'; backward = 'False'; title = 'LC__CMDB__CATG__CPU_CORES'; description = 'CPU cores' };
                        data  = @{ type = 'int'; readonly = 'False'; index = 'False'; field = 'isys_catg_cpu_list__cores' };
                        ui    = @{ type = 'text'; params  = @{ p_strPlaceholder = 0; default = 0; p_strClass = 'input-mini' }; default = 1; id = 'C__CATG__CPU_CORES' }
                    };

        .NOTES
        One more example of the incosistency of the i-doit API:
        Searching by category name does return the name as well. Searching for the same category by id does not return the name.
    #>
        Param (
            [Parameter(Mandatory = $True, ParameterSetName="Category")]
            [String]$Category,

            [Parameter(Mandatory = $True, ParameterSetName="CatgId")]
            [int]$CatgId,

            [Parameter(Mandatory = $True, ParameterSetName="CatsId")]
            [int]$CatsId
        )

        $params = @{}
        Switch ($PSCmdlet.ParameterSetName) {
            "Category" { $params.Add("category", $Category); break }
            "CatgId" { $params.Add("catgID",$CatgId); break }
            "CatsId" { $params.Add("catsID",$CatsId); break }
        }

        $result = Invoke-IdoIt -Method "cmdb.category_info.read" -Params $params -ErrorAction Stop
        $result.PSObject.Typenames.Add('Idoit.CategoryInfo')
        $result | Add-Member -MemberType NoteProperty -Name Category -Value $Category -Force
        return $result
    }