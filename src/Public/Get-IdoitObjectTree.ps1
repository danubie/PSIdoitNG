function Get-IdoitObjectTree {
    <#
    .SYNOPSIS
    Retrieves the full object tree for a given i-doit object ID.

    .DESCRIPTION
    This cmdlet retrieves the object tree for a specified i-doit object ID, including its categories and properties.
    It excludes categories specified in the `ExcludeCategory` parameter.

    If you have installed the module "PwshSpectreConsole" you can get a nice view of the results by using:
    Format-SpectreJson -Data (Get-IdoitObjectTree -id 37) -Depth 5

    .PARAMETER Id
    The ID of the i-doit object for which to retrieve the tree.

    .PARAMETER ExcludeCategory
    An array of category constants to exclude from the results. Default is 'C__CATG__LOGBOOK'.

    .PARAMETER IncludeEmptyCategories
    A switch to include empty categories in the output.

    .EXAMPLE
    Get-IdoitObjectTree -Id 37
    Id Title           ObjectType Categories
    -- -----           ---------- ----------
    37 This Title              53 {@{Category=C__CATG__OVERVIEW; Properties=}, @{Category=C__CATG__RELATION; Properties=System.Object[]}, @{Category=C__CATG__M...

    .EXAMPLE
    PSIdoitNG> Get-IdoitObjectTree -Id 37 | Select-Object -Expanded Categories
    --------                           ----------
    C__CATG__OVERVIEW                  @{id=4; objID=37}
    C__CATG__RELATION                  {@{id=15; objID=53; object1=; object2=; relation_type=; weighting=; itservice=; description=}, @{id=63; objID=156; objec...
    C__CATG__MAIL_ADDRESSES            @{id=353; objID=37; title=thisTitle@somewhere; primary_mail=thisTitle@somewhere; primary=; descrip...
    C__CATG__GLOBAL                    @{id=37; objID=37; title=thisTitle; status=; created=2024-10-09 12:56:39; created_by=SomeBody; changed=2025-05-...
    C__CATS__PERSON                    @{id=11; objID=37; title=thisTitle@somewhere; salutation=; first_name=First; last_name=Last; academic_de...

    PSIdoitNG> $x.Categories[3].Properties
    id          : 37
    objID       : 37
    title       : This Title
    status      : @{id=2; title=Normal; const=; title_lang=LC__CMDB__RECORD_STATUS__NORMAL}
    created     : 2024-10-09 12:56:39
    created_by  : SomeBody
    changed     : 2025-05-27 23:10:18
    changed_by  : automation
    purpose     :
    category    :
    sysid       : SYSID_1733071461
    cmdb_status : @{id=6; title=in operation; const=C__CMDB_STATUS__IN_OPERATION; title_lang=LC__CMDB_STATUS__IN_OPERATION}
    type        : @{id=53; title=Persons; const=C__OBJTYPE__PERSON; title_lang=LC__CONTACT__TREE__PERSON}
    tag         :
    description :

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int] $Id,

        [string[]] $ExcludeCategory = 'C__CATG__LOGBOOK',

        [switch] $IncludeEmptyCategories
    )

    begin {

    }

    process {
        $obj = Get-IdoitObject -ObjId $Id
        if ($null -eq $obj) {
            Write-Error "Object with ID $Id not found."
            return
        }
        $catList = Get-IdoItObjectTypeCategory -Type $obj.objecttype
        if ($null -eq $catList) {
            Write-Error "No categories found for object with ID $Id."
            return
        }
        $result = [PSCustomObject]@{
            Id = $Id
            Title = $obj.title
            ObjectType = $obj.objecttype
            Categories = @()
        }
        foreach ($category in $catList) {
            if ($category.const -in $ExcludeCategory) {
                continue
            }
            $catValues = Get-IdoItCategory -ObjId $Id -Category $category.const -ErrorAction Stop
            # an logically empty result contains objId, id plus the category const added by Get-IdoitCategory
            if ( $null -eq $catValues -and -not $IncludeEmptyCategories ) {
                continue
            }
            # $catValues | ft -GroupBy RefCategory -AutoSize -Wrap
            $result.Categories += [PSCustomObject]@{
                Category = $category.const
                Properties = $catValues
            }
        }
        $result
    }

    end {

    }
}
