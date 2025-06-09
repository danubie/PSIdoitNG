---
external help file: PSIdoitNG-help.xml
Module Name: PSIdoitNG
online version:
schema: 2.0.0
---

# Connect-IdoIt

## SYNOPSIS
Connect-to Idoit API.

## SYNTAX

### UserPasswordApiKey
```
Connect-IdoIt -Uri <String> -Username <String> -Password <SecureString> -ApiKey <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### PSCredential
```
Connect-IdoIt -Uri <String> -Credential <PSCredential> -ApiKey <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Connect-to Idoit API.
This function is used to connect to the Idoit API and authenticate the user.

## EXAMPLES

### EXAMPLE 1
```
Connect-IdoIt -Uri 'https://test.uri' -Credential $credential -ApiKey 'TestApiKey'
This will connect to the Idoit API using the provided Uri and Credential. The result of the login will be returned.
```

### EXAMPLE 2
```
Connect-IdoIt -Uri 'https://test.uri' -Username 'TestUser' -Password (ConvertTo-SecureString 'TestPassword' -AsPlainText -Force) -ApiKey 'TestApiKey'
This will connect to the Idoit API using the provided Uri, Username, Password and ApiKey. The result of the login will be returned.
```

## PARAMETERS

### -Uri
The Uri to the idoit JSON-RPC API.
should be like http\[s\]://your.i-doit.host/src/jsonrpc.php

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
User with appropiate permissions to access the cmdb.

```yaml
Type: PSCredential
Parameter Sets: PSCredential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
The username to connect to the Idoit API.

```yaml
Type: String
Parameter Sets: UserPasswordApiKey
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password to connect to the Idoit API.
The password is passed as a SecureString.

```yaml
Type: SecureString
Parameter Sets: UserPasswordApiKey
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
This is the apikey you define in idoit unter Settings-\> Interface-\> JSON-RPC API to access the api

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
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

## RELATED LINKS
