---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Invoke-IdoIt

## SYNOPSIS
Invoke-IdoIt API request to the i-doit RPC Endpoint

## SYNTAX

```
Invoke-IdoIt [-Endpoint] <String> [[-Params] <Hashtable>] [[-Headers] <Hashtable>] [[-Uri] <String>]
 [[-Version] <String>] [[-ApiKey] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function is calling the IdoIt API.
The result is returned as a PSObject.

## EXAMPLES

### EXAMPLE 1
```
$result = -Method "idoit.logout" -Params @{}
```

## PARAMETERS

### -Endpoint
This parameter the method yout want to call at the RPC Endpoint (see https://kb.i-doit.com/de/i-doit-add-ons/api/index.html).
From my personal point of view, at the time of writing the documentation is not very good.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Method

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Params
Hashtable creating request body with the methods parameters (https://kb.i-doit.com/de/i-doit-add-ons/api/index.html).
The following additional parameters are inserted into the request body: ApiKey, Request id, Version

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @{}
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headers
Optional parameter if default headers should be overwritten (e.g.
when logging into a new session).

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @{"Content-Type" = "application/json"; "X-RPC-Auth-Session" = $Script:IdoItParams["Connection"].SessionId}
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri
The Uri if the API Endpoint.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:IdoItParams["Connection"].Uri
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
The version of the API.
Default is 2.0

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 2.0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
The API key to be used.
Default is the one used in Connect.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: $Script:IdoItParams["Connection"].ApiKey
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
To trace the API calls, set the global variable $Global:IdoitApiTrace to @().
For every API call, a new entry is added to the array.
The entry contains the following properties:
    Endpoint: The endpoint called
    Request: The request body
    Response: The response body (if response was successful)
    Time: The time of the call
    Exception: The exception thrown (if any)

## RELATED LINKS
