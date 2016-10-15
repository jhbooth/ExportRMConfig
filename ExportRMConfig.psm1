<#
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Created on:   	2016-04-19 1:29 PM
	 Created by:
	 Organization:
	 Filename:     	ExportRMConfig.psm1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

Set-Variable -Name SchemaChangesFile -Value (Join-Path -Path $env:TEMP -ChildPath 'RMConfigSchemaChanges.xml') -Scope Script
Set-Variable -Name PolicyChangesFile -Value (Join-Path -Path $env:TEMP -ChildPath 'RMConfigPolicyChanges.xml') -Scope Script
Set-Variable -Name PortalChangesFile -Value (Join-Path -Path $env:TEMP -ChildPath 'RMConfigPortalChanges.xml') -Scope Script

<#
	.SYNOPSIS
		A brief description of the Get-RMConfigSchemaChanges function.

	.DESCRIPTION
		A detailed description of the Get-RMConfigSchemaChanges function.

	.PARAMETER Source
		The description of a the Source parameter.

	.PARAMETER Target
		The description of a the Target parameter.

	.EXAMPLE
		PS C:\> Get-RMConfigSchemaChanges -Source 'One value' -Target 32
		'This is the output'
		This example shows how to call the Get-RMConfigSchemaChanges function with named parameters.

	.EXAMPLE
		PS C:\> Get-RMConfigSchemaChanges 'One value' 32
		'This is the output'
		This example shows how to call the Get-RMConfigSchemaChanges function with positional parameters.

	.OUTPUTS
		System.String

	.NOTES
		For more information about advanced functions, call Get-Help with any
		of the topics in the links listed below.

	.INPUTS
		System.String,System.Int32

	.LINK
		about_modules

	.LINK
		about_functions_advanced

	.LINK
		about_comment_based_help

	.LINK
		about_functions_advanced_parameters

	.LINK
		about_functions_advanced_methods
#>
function Get-RMConfigSchemaChange
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		$Source,
		[Parameter(Mandatory = $true,
				   Position = 1)]
		$Target
	)

	begin
	{
		$anchorMap = @{ ObjectTypeDescription = "Name"; AttributeTypeDescription = "Name"; BindingDescription = "BoundObjectType BoundAttributeType"; }

		if (Test-Path -Path $Source)
		{
			$sourceSchema = ConvertTo-FIMResource -File (Resolve-Path -Path $Source)
		}
		else
		{
			Write-Error -Message "$Source does not exist" -ErrorAction Stop
		}

		if (Test-Path -Path $Target)
		{
			$targetSchema = ConvertTo-FIMResource -File (Resolve-Path -Path $Target)
		}
		else
		{
			Write-Error -Message "$Target does not exist" -ErrorAction Stop
		}
	}
	end
	{
		$joinedSchema = Join-FIMConfig -Source $sourceSchema -Target $targetSchema -Join $anchorMap -DefaultJoin DisplayName
		$changes = $joinedSchema | Compare-FIMConfig
		$changes | ConvertFrom-FIMResource -File $SchemaChangesFile
		Write-Output ($changes | Where-Object -Property 'State' -Value 'Resolve' -NE)
	}
}
Export-ModuleMember -Function Get-RMConfigSchemaChange

<#
	.SYNOPSIS
		A brief description of the Get-RMConfigPolicyChange function.

	.DESCRIPTION
		A detailed description of the Get-RMConfigPolicyChange function.

	.PARAMETER Source
		A description of the Source parameter.

	.PARAMETER Target
		A description of the Target parameter.

	.EXAMPLE
		PS C:\> Get-RMConfigPolicyChange -Source $value1 -Target $value2

	.NOTES
		Additional information about the function.
#>
function Get-RMConfigPolicyChange
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$Source,
		[Parameter(Mandatory = $true)]
		$Target
	)
	begin
	{
		$anchorMap = @{
			ObjectTypeDescription = "Name";
			AttributeTypeDescription = "Name";
			BindingDescription = "BoundObjectType BoundAttributeType";
			ActivityInformationConfiguration = "ActivityName";
			'Function' = "FunctionName";
		}

		if (Test-Path -Path $Source)
		{
			$sourcePolicy = ConvertTo-FIMResource -File (Resolve-Path -Path $Source)
		}
		else
		{
			Write-Error -Message "$Source does not exist" -ErrorAction Stop
		}

		if (Test-Path -Path $Target)
		{
			$targetPolicy = ConvertTo-FIMResource -File (Resolve-Path -Path $Target)
		}
		else
		{
			Write-Error -Message "$Target does not exist" -ErrorAction Stop
		}
	}
	end
	{
		$joinedPolicy = Join-FIMConfig -Source $sourcePolicy -Target $targetPolicy -Join $anchorMap -DefaultJoin DisplayName
		$changes = $joinedPolicy | Compare-FIMConfig
		$changes | ConvertFrom-FIMResource -File $PolicyChangesFile
		Write-Output ($changes | Where-Object -Property 'State' -Value 'Resolve' -NE)

	}
}
Export-ModuleMember -Function Get-RMConfigPolicyChange


<#
	.SYNOPSIS
		A brief description of the Get-RMConfigPortalChange function.

	.DESCRIPTION
		A detailed description of the Get-RMConfigPortalChange function.

	.PARAMETER Source
		A description of the Source parameter.

	.PARAMETER Target
		A description of the Target parameter.

	.EXAMPLE
		PS C:\> Get-RMConfigPortalChange -Source $value1 -Target $value2

	.NOTES
		Additional information about the function.
#>
function Get-RMConfigPortalChange
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$Source,
		[Parameter(Mandatory = $true)]
		$Target
	)
	begin
	{
		$anchorMap = @{
			ObjectTypeDescription = "Name";
			AttributeTypeDescription = "Name";
			BindingDescription = "BoundObjectType BoundAttributeType";
			ActivityInformationConfiguration = "ActivityName";
			Set = "DisplayName";
			WorkflowDefinition = "DisplayName";
			ObjectVisualizationConfiguration = "DisplayName";
			NavigationBarConfiguration = "DisplayName";
			SearchScopeConfiguration = "DisplayName SearchScopeResultObjectType Order"
		}

		if (Test-Path -Path $Source)
		{
			$sourcePortal = ConvertTo-FIMResource -File (Resolve-Path -Path $Source)
		}
		else
		{
			Write-Error -Message "$Source does not exist" -ErrorAction Stop
		}

		if (Test-Path -Path $Target)
		{
			$targetPortal = ConvertTo-FIMResource -File (Resolve-Path -Path $Target)
		}
		else
		{
			Write-Error -Message "$Target does not exist" -ErrorAction Stop
		}
	}
	end
	{
		$joinedPolicy = Join-FIMConfig -Source $sourcePortal -Target $targetPortal -Join $anchorMap -DefaultJoin ObjectID
		$changes = $joinedPolicy | Compare-FIMConfig
		$changes | ConvertFrom-FIMResource -File $PortalChangesFile
		Write-Output ($changes | Where-Object -Property 'State' -Value 'Resolve' -NE)

	}
}
Export-ModuleMember -Function Get-RMConfigPortalChange

<#
	.SYNOPSIS
		A brief description of the Export-RMConfigSchema function.

	.DESCRIPTION
		A detailed description of the Export-RMConfigSchema function.

	.PARAMETER FilePath
		A description of the FilePath parameter.

	.PARAMETER ImportObject
		A description of the ImportObject parameter.

	.PARAMETER Append
		A description of the Append parameter.

	.PARAMETER Force
		A description of the Force parameter.

	.EXAMPLE
		PS C:\> Export-RMConfigSchema -FilePath 'Value1' -ImportObject $value2

	.NOTES
		Additional information about the function.
#>
function Export-RMConfigSchema
{
	[CmdletBinding(ConfirmImpact = 'High',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$FilePath,
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[object[]]$ImportObject,
		[switch]$Append,
		[switch]$Force
	)

	begin
	{
		try
		{
			if ([System.IO.Path]::IsPathRooted($FilePath))
			{
				$FullPath = ([System.IO.Path]::GetFullPath($FilePath))
			}
			else
			{
				$FullPath = ([System.IO.Path]::GetFullPath((Join-Path -Path $PWD -ChildPath $FilePath)))
			}

			Write-Debug -Message $FullPath

			if ($Append)
			{
				if (Test-Path -Path $FullPath)
				{
					# All good, we will read the content and find the Operations node below
				}
				else
				{
					if ($PSCmdlet.ShouldContinue('Would you like to create it?', "Can't append, file does not exist: $FullPath"))
					{
						New-RMConfigFile -Path $FullPath -Force
					}
					else
					{
						Write-Error -Message "Can't append, file does not exist: $FullPath" -ErrorAction Stop
					}
				}
			}
			else
			{
				if (Test-Path -Path $FullPath)
				{
					if ($Force -or $PSCmdlet.ShouldContinue('Would you like to overwrite it?', "File exists: $FullPath"))
					{
						New-RMConfigFile -Path $FullPath -Force
					}
					else
					{
						Write-Error -Message "File exists: $FullPath" -ErrorAction Stop
					}
				}
				else
				{
					New-RMConfigFile -Path $FullPath -Force
				}

			}

			[xml]$rmConfigFile = Get-Content -Path $FullPath
			$opsNode = Select-Xml -Xml $rmConfigFile -XPath '//Operations'
		}
		catch
		{
			throw
		}
	}
	process
	{
		try
		{
			foreach ($changeObject in $ImportObject)
			{
				$objectState = $changeObject.State.ToString()

				if ($objectState -eq 'Resolve')
				{
					continue
				}

				$newResourceOperationElement = New-ResourceOperationInternal -ImportObject $ImportObject -RefreshSchema

				Write-ChangesGeneric -ImportObject $ImportObject -Element $newResourceOperationElement -ResolveFile $SchemaChangesFile

				$opsNode.Node.AppendChild($newResourceOperationElement) | Out-Null
			}
		}
		catch
		{
			throw
		}
	}
	end
	{
		try
		{
			$rmConfigFile.Save($FullPath)
		}
		catch
		{
			throw
		}
	}
}
Export-ModuleMember -Function Export-RMConfigSchema


<#
	.SYNOPSIS
		A brief description of the Export-RMConfigPolicy function.

	.DESCRIPTION
		A detailed description of the Export-RMConfigPolicy function.

	.PARAMETER FilePath
		A description of the FilePath parameter.

	.PARAMETER ImportObject
		A description of the ImportObject parameter.

	.PARAMETER Append
		A description of the Append parameter.

	.PARAMETER Force
		A description of the Force parameter.

	.PARAMETER ResolveLive
		A description of the ResolveLive parameter.

	.EXAMPLE
		PS C:\> Export-RMConfigPolicy -FilePath 'Value1' -ImportObject $value2

	.NOTES
		Additional information about the function.
#>
function Export-RMConfigPolicy
{
	[CmdletBinding(ConfirmImpact = 'High',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$FilePath,
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[object[]]$ImportObject,
		[switch]$Append,
		[switch]$Force,
		[switch]$ResolveLive
	)

	begin
	{
		try
		{
			if ([System.IO.Path]::IsPathRooted($FilePath))
			{
				$FullPath = ([System.IO.Path]::GetFullPath($FilePath))
			}
			else
			{
				$FullPath = ([System.IO.Path]::GetFullPath((Join-Path -Path $PWD -ChildPath $FilePath)))
			}

			Write-Debug -Message $FullPath

			if ($Append)
			{
				if (Test-Path -Path $FullPath)
				{
					# All good, we will read the content and find the Operations node below
					# [xml]$rmConfigFile = Get-Content -Path $FullPath
					# $opsNode = Select-Xml -Xml $rmConfigFile -XPath '//Operations'
				}
				else
				{
					if ($PSCmdlet.ShouldContinue('Would you like to create it?', "Can't append, file does not exist: $FullPath"))
					{
						New-RMConfigFile -Path $FullPath -Force
					}
					else
					{
						Write-Error -Message "Can't append, file does not exist: $FullPath" -ErrorAction Stop
					}
				}
			}
			else
			{
				if (Test-Path -Path $FullPath)
				{
					if ($Force -or $PSCmdlet.ShouldContinue('Would you like to overwrite it?', "File exists: $FullPath"))
					{
						New-RMConfigFile -Path $FullPath -Force
					}
					else
					{
						Write-Error -Message "File exists: $FullPath" -ErrorAction Stop
					}
				}
				else
				{
					New-RMConfigFile -Path $FullPath
				}

			}

			[xml]$rmConfigFile = Get-Content -Path $FullPath
			$opsNode = Select-Xml -Xml $rmConfigFile -XPath '//Operations'
		}
		catch
		{
			throw
		}
	}
	process
	{
		try
		{
			foreach ($changeObject in $ImportObject)
			{
				$objectType = $changeObject.ObjectType
				$objectState = $changeObject.State.ToString()

				if ($objectState -eq 'Delete')
				{
					continue
				}

				$importObjectInfo = Get-ImportObjectInfo -ImportObject $changeObject

				if (-not (Test-Resolved -ImportObject $changeObject -ResolveInService $ResolveLive.IsPresent))
				{
					Write-Warning -Message ('{0} does not resolve, object not output' -f $importObjectInfo)
					continue
				}
				else
				{
					Write-Debug -Message $importObjectInfo
				}

				$newResourceOperationElement = New-ResourceOperationInternal -ImportObject $changeObject

				switch ($objectType)
				{
					"ActivityInformationConfiguration"
					{
						Write-ChangesGeneric -ImportObject $changeObject -Element $newResourceOperationElement -ResolveFile $PolicyChangesFile
					}
					"EmailTemplate"
					{
						Write-ChangesEmailTemplate -ImportObject $changeObject -Element $newResourceOperationElement
					}
					"FilterScope"
					{
						Write-ChangesGeneric -ImportObject $changeObject -Element $newResourceOperationElement -ResolveFile $PolicyChangesFile
					}

					"ManagementPolicyRule"
					{
						Write-ChangesGeneric -ImportObject $changeObject -Element $newResourceOperationElement -ResolveFile $PolicyChangesFile
					}
					"Set"
					{
						Write-ChangesSet -ImportObject $changeObject -Element $newResourceOperationElement
					}
					#"SynchronizationFilter" {}
					"SynchronizationRule"
					{
						#code
						if ($changeObject.State -eq 'Create')
						{
							$changeObject.Changes = $changeObject.Changes | Where-Object -Property AttributeName -ne -Value 'Precedence'
						}
						Write-ChangesGeneric -ImportObject $changeObject -Element $newResourceOperationElement -ResolveFile $PolicyChangesFile
					}
					"WorkflowDefinition"
					{
						Write-ChangesWorkflowDefinition -ImportObject $changeObject -Element $newResourceOperationElement
					}
					default
					{
						Write-ChangesGeneric -ImportObject $changeObject -Element $newResourceOperationElement -ResolveFile $PolicyChangesFile
					}
				}
				$opsNode.Node.AppendChild($newResourceOperationElement) | Out-Null
			}
		}
		catch
		{
			throw
		}
	}

	end
	{
		try
		{
			$rmConfigFile.Save($FullPath)
		}
		catch
		{
			throw
		}
	}
}
Export-ModuleMember -Function Export-RMConfigPolicy


<#
	.SYNOPSIS
		A brief description of the Export-RMConfigPortal function.

	.DESCRIPTION
		A detailed description of the Export-RMConfigPortal function.

	.PARAMETER FilePath
		A description of the FilePath parameter.

	.PARAMETER ImportObject
		A description of the ImportObject parameter.

	.PARAMETER Append
		A description of the Append parameter.

	.PARAMETER Force
		A description of the Force parameter.

	.PARAMETER ResolveLive
		A description of the ResolveLive parameter.

	.EXAMPLE
		PS C:\> Export-RMConfigPortal -FilePath 'Value1' -ImportObject $value2

	.NOTES
		Additional information about the function.
#>
function Export-RMConfigPortal
{
	[CmdletBinding(ConfirmImpact = 'High',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$FilePath,
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true)]
		[object[]]$ImportObject,
		[switch]$Append,
		[switch]$Force,
		[switch]$ResolveLive
	)

	begin
	{
		try
		{
			if ([System.IO.Path]::IsPathRooted($FilePath))
			{
				$FullPath = ([System.IO.Path]::GetFullPath($FilePath))
			}
			else
			{
				$FullPath = ([System.IO.Path]::GetFullPath((Join-Path -Path $PWD -ChildPath $FilePath)))
			}

			Write-Debug -Message $FullPath

			if ($Append)
			{
				if (Test-Path -Path $FullPath)
				{
					# All good, we will read the content and find the Operations node below
					# [xml]$rmConfigFile = Get-Content -Path $FullPath
					# $opsNode = Select-Xml -Xml $rmConfigFile -XPath '//Operations'
				}
				else
				{
					if ($PSCmdlet.ShouldContinue('Would you like to create it?', "Can't append, file does not exist: $FullPath"))
					{
						New-RMConfigFile -Path $FullPath -Force
					}
					else
					{
						Write-Error -Message "Can't append, file does not exist: $FullPath" -ErrorAction Stop
					}
				}
			}
			else
			{
				if (Test-Path -Path $FullPath)
				{
					if ($Force -or $PSCmdlet.ShouldContinue('Would you like to overwrite it?', "File exists: $FullPath"))
					{
						New-RMConfigFile -Path $FullPath -Force
					}
					else
					{
						Write-Error -Message "File exists: $FullPath" -ErrorAction Stop
					}
				}
				else
				{
					New-RMConfigFile -Path $FullPath
				}

			}

			[xml]$rmConfigFile = Get-Content -Path $FullPath
			$opsNode = Select-Xml -Xml $rmConfigFile -XPath '//Operations'
		}
		catch
		{
			throw
		}
	}
	process
	{
		try
		{
			foreach ($changeObject in $ImportObject)
			{
				$objectType = $changeObject.ObjectType
				$objectState = $changeObject.State.ToString()

				if ($objectState -eq 'Delete')
				{
					continue
				}

				$importObjectInfo = Get-ImportObjectInfo -ImportObject $changeObject

				if (-not (Test-Resolved -ImportObject $changeObject -ResolveInService $ResolveLive.IsPresent))
				{
					Write-Warning -Message ('{0} does not resolve, object not output' -f $importObjectInfo)
					continue
				}
				else
				{
					Write-Debug -Message $importObjectInfo
				}

				$newResourceOperationElement = New-ResourceOperationInternal -ImportObject $changeObject

				switch ($objectType)
				{
					"HomepageConfiguration"
					{
						Write-ChangesGeneric -ImportObject $changeObject -Element $newResourceOperationElement -ResolveFile $PortalChangesFile
					}
					"NavigationBarConfiguration"
					{
						Write-ChangesGeneric -ImportObject $changeObject -Element $newResourceOperationElement -ResolveFile $PortalChangesFile
					}
					"PortalUIConfiguration"
					{
						Write-ChangesGeneric -ImportObject $changeObject -Element $newResourceOperationElement -ResolveFile $PortalChangesFile
					}
					"SearchScopeConfiguration"
					{
						Write-ChangesSearchScope -ImportObject $changeObject -Element $newResourceOperationElement
					}
					"ObjectVisualizationConfiguration"
					{
						Write-ChangesRCDC -ImportObject $changeObject -Element $newResourceOperationElement
					}
					default
					{
						Write-ChangesGeneric -ImportObject $changeObject -Element $newResourceOperationElement -ResolveFile $PortalChangesFile
					}
				}
				$opsNode.Node.AppendChild($newResourceOperationElement) | Out-Null
			}
		}
		catch
		{
			throw
		}
	}

	end
	{
		try
		{
			$rmConfigFile.Save($FullPath)
		}
		catch
		{
			throw
		}
	}
}
Export-ModuleMember -Function Export-RMConfigPortal


<#
	.SYNOPSIS
		A brief description of the Resolve-UuidFromFile function.

	.DESCRIPTION
		A detailed description of the Resolve-UuidFromFile function.

	.PARAMETER ChangeFile
		A description of the ChangeFile parameter.

	.PARAMETER Uuid
		A description of the Uuid parameter.

	.EXAMPLE
		PS C:\> Resolve-UuidFromFile -ChangeFile $value1 -Uuid $value2

	.NOTES
		Additional information about the function.
#>
function Resolve-UuidFromFile
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$ChangeFile,
		[Parameter(Mandatory = $true)]
		$Uuid
	)

	if (Test-Path -Path $ChangeFile)
	{

		if ($Uuid -match '^urn:uuid:[-0-9a-f]{36}$')
		{
			$XPath = '//ImportObject/SourceObjectIdentifier[text()="{0}"]/..' -f $Uuid
		}
		elseif ($Uuid -match '^[-0-9a-f]{36}$')
		{
			$XPath = '//ImportObject/SourceObjectIdentifier[text()="urn:uuid:{0}"]/..' -f $Uuid
		}
		elseif ($Uuid -match '^<Filter')
		{
			$filterfound = $true
			[xml]$filter = $Uuid
			$toOutput = $filter.Filter.'#text'
		}
		else
		{
			Write-Error -Message "Uuid is not really a UUID! Really! $Uuid" -ErrorAction Stop
		}
	}
	else
	{
		Write-Error -Message "WTF? $ChangeFile does not exist! Wanker!" -ErrorAction Stop
	}

	if (!$filterfound)
	{
		$xml = Select-Xml -Path $ChangeFile -XPath $XPath

		if ($xml)
		{
			Write-Output ('{0}|{1}|{2}' -f $xml.Node.ObjectType, $xml.Node.AnchorPairs.JoinPair.AttributeName, $xml.Node.AnchorPairs.JoinPair.AttributeValue)
		}
		else
		{
			Write-Output $null
		}
	}
	else
	{
		Write-Output $toOutput
	}

}
Export-ModuleMember -Function Resolve-UuidFromFile


<#
	.SYNOPSIS
		Creates new empty configuration file

	.DESCRIPTION
		A detailed description of the New-RMConfigFile function.

	.PARAMETER Path
		A description of the Path parameter.

	.PARAMETER Force
		A description of the Force parameter.

	.EXAMPLE
		PS C:\> New-RMConfigFile -Path $value1

	.NOTES
		Additional information about the function.
#>
function New-RMConfigFile
{
	[CmdletBinding(SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		$Path,
		[Parameter(Position = 1)]
		[switch]$Force
	)

	if ([System.IO.Path]::IsPathRooted($Path))
	{
		$FullPath = ([System.IO.Path]::GetFullPath($Path))
	}
	else
	{
		$FullPath = ([System.IO.Path]::GetFullPath((Join-Path -Path $PWD -ChildPath $Path)))
	}

	if (Test-Path $FullPath)
	{
		if ($Force -or $PSCmdlet.ShouldContinue('Would you like to overwrite it?', "File exists: $FullPath"))
		{
			# All good, we can continue
		}
		else
		{
			Write-Error -Message "Will not overwrite $FullPath" -ErrorAction Stop
		}
	}

	# get an XmlTextWriter to create the XML
	$XmlWriter = New-Object System.XMl.XmlTextWriter($FullPath, (New-Object -TypeName System.Text.UTF8Encoding -ArgumentList $true))

	# choose a pretty formatting
	$xmlWriter.Formatting = 'Indented'
	$xmlWriter.Indentation = 2
	$XmlWriter.IndentChar = ' '

	# write the header
	$xmlWriter.WriteStartDocument()

	# Create root element
	$XmlWriter.WriteComment('Import this file with Import-RMConfig cmdlet in the Lithnet FIM/MIM Service PowerShell Module')
	$XmlWriter.WriteStartElement('Lithnet.ResourceManagement.ConfigSync')

	# Create Variables section
	$xmlWriter.WriteStartElement('Variables')
	$XmlWriter.WriteEndElement()

	# Create the 'Operations' section
	$XmlWriter.WriteStartElement('Operations')
	$xmlWriter.WriteEndElement()

	# finalize the document
	$xmlWriter.WriteEndDocument()
	$xmlWriter.Flush()
	$xmlWriter.Close()
	
	Write-Output (Get-Item -Path $FullPath)
}
Export-ModuleMember -Function New-RMConfigFile


function New-ResourceOperationInternal
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$ImportObject,
		[switch]$RefreshSchema
	)

	$objectState = $ImportObject.State.ToString()

	# Create the element
	$resOp = $rmConfigFile.CreateElement('ResourceOperation')

	# Create the attributes for the ResourceOperation element
	$opAttr = $rmConfigFile.CreateAttribute('operation')
	$rTypeAttr = $rmConfigFile.CreateAttribute('resourceType')
	$idAttr = $rmConfigFile.CreateAttribute('id')

	$rTypeAttr.Value = $ImportObject.ObjectType

	switch ($objectState)
	{
		'Create'
		{
			$opAttr.Value = 'Add Update'
			$idAttr.Value = $ImportObject.SourceObjectIdentifier
		}
		'Put'
		{
			$opAttr.Value = 'Update'
			$idAttr.Value = $ImportObject.SourceObjectIdentifier
		}
		'Delete'
		{
			$opAttr.Value = 'Delete'
			$idAttr.Value = $ImportObject.TargetObjectIdentifier
		}
		default
		{
			$opAttr.Value = 'None'
			$idAttr.Value = $ImportObject.SourceObjectIdentifier
		}
	}

	# Add the attributes to the ResourceOperation element
	$resOp.Attributes.Append($opAttr) | Out-Null
	$resOp.Attributes.Append($rTypeAttr) | Out-Null
	$resOp.Attributes.Append($idAttr) | Out-Null

	if ($RefreshSchema)
	{
		$refreshAttribute = $rmConfigFile.CreateAttribute('refresh-schema')
		$refreshAttribute.Value = 'after-operation'
		$resOp.Attributes.Append($refreshAttribute) | Out-Null
	}

	# create anchors section
	$anchorAttributesElement = $rmConfigFile.CreateElement('AnchorAttributes')
	foreach ($anchor in $ImportObject.AnchorPairs)
	{
		$anchorElement = $rmConfigFile.CreateElement('AnchorAttribute')
		$anchorElement.InnerText = $anchor.AttributeName
		$anchorAttributesElement.AppendChild($anchorElement) | Out-Null
	}

	$resOp.AppendChild($anchorAttributesElement) | Out-Null

	$attributeOperationsElement = $rmConfigFile.CreateElement('AttributeOperations')
	if ($ImportObject.State -eq 'Put')
	{
		foreach ($anchor in $ImportObject.AnchorPairs)
		{
			$attrOpElement = $rmConfigFile.CreateElement('AttributeOperation')
			$attrOpOperationAttribute = $rmConfigFile.CreateAttribute('operation')
			$attrOpOperationAttribute.Value = 'none'
			$nameAttribute = $rmConfigFile.CreateAttribute('name')
			$nameAttribute.Value = $anchor.AttributeName
			$attrOpElement.Attributes.Append($attrOpOperationAttribute) | Out-Null
			$attrOpElement.Attributes.Append($nameAttribute) | Out-Null
			$attrOpElement.InnerText = $anchor.AttributeValue
			$attributeOperationsElement.AppendChild($attrOpElement) | Out-Null
		}
	}
	$resOp.AppendChild($attributeOperationsElement) | Out-Null
	Write-Output $resOp
}

function Write-ChangesGeneric
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$ImportObject,
		[Parameter(Mandatory = $true)]
		[System.Xml.XmlElement]$Element,
		[Parameter(Mandatory = $true)]
		[string]$ResolveFile
	)

	$attrOps = $Element.SelectSingleNode('./AttributeOperations')

	# Create an AttributeOperation element for each change
	foreach ($change in $ImportObject.Changes)
	{
		$attrOpElement = $rmConfigFile.CreateElement('AttributeOperation')

		$attrOpOperationAttribute = $rmConfigFile.CreateAttribute('operation')

		if ($ImportObject.State -eq 'Create')
		{
			$attrOpOperationAttribute.Value = 'add'
		}
		else
		{
			$attrOpOperationAttribute.Value = $change.Operation.ToString().ToLowerInvariant()
		}

		$nameAttribute = $rmConfigFile.CreateAttribute('name')
		$nameAttribute.Value = $change.AttributeName
		$attrOpElement.Attributes.Append($attrOpOperationAttribute) | Out-Null
		$attrOpElement.Attributes.Append($nameAttribute) | Out-Null


		if (!$change.FullyResolved)
		{
			$typeAttribute = $rmConfigFile.CreateAttribute('type')
			$typeAttribute.Value = 'ref'
			$attrOpElement.Attributes.Append($typeAttribute) | Out-Null
			$attrOpElement.InnerText = Resolve-UuidFromFile -ChangeFile $ResolveFile -Uuid $change.AttributeValue
		}
		else
		{
			$attrOpElement.InnerText = $change.AttributeValue
		}

		$attrOps.AppendChild($attrOpElement) | Out-Null
	}
}

function Write-ChangesSearchScope
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$ImportObject,
		[Parameter(Mandatory = $true)]
		[System.Xml.XmlElement]$Element
	)

	$attrOps = $Element.SelectSingleNode('./AttributeOperations')

	# Create an AttributeOperation element for each change
	foreach ($change in $ImportObject.Changes)
	{
		$attrOpElement = $rmConfigFile.CreateElement('AttributeOperation')

		$attrOpOperationAttribute = $rmConfigFile.CreateAttribute('operation')

		if ($ImportObject.State -eq 'Create')
		{
			$attrOpOperationAttribute.Value = 'add'
		}
		else
		{
			$attrOpOperationAttribute.Value = $change.Operation.ToString().ToLowerInvariant()
		}

		$nameAttribute = $rmConfigFile.CreateAttribute('name')
		$nameAttribute.Value = $change.AttributeName
		$attrOpElement.Attributes.Append($attrOpOperationAttribute) | Out-Null
		$attrOpElement.Attributes.Append($nameAttribute) | Out-Null
		$attrOpElement.InnerText = $change.AttributeValue
		$attrOps.AppendChild($attrOpElement) | Out-Null
	}
}

function Write-ChangesEmailTemplate
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject]$ImportObject,
		[Parameter(Mandatory = $true)]
		[System.Xml.XmlElement]$Element
	)

	$attrOps = $Element.SelectSingleNode('./AttributeOperations')

	# Create an AttributeOperation element for each change
	foreach ($change in $ImportObject.Changes)
	{
		$attrOpElement = $rmConfigFile.CreateElement('AttributeOperation')

		$attrOpOperationAttribute = $rmConfigFile.CreateAttribute('operation')

		if ($ImportObject.State -eq 'Create')
		{
			$attrOpOperationAttribute.Value = 'add'
		}
		else
		{
			$attrOpOperationAttribute.Value = $change.Operation.ToString().ToLowerInvariant()
		}

		$nameAttribute = $rmConfigFile.CreateAttribute('name')
		$nameAttribute.Value = $change.AttributeName
		$attrOpElement.Attributes.Append($attrOpOperationAttribute) | Out-Null
		$attrOpElement.Attributes.Append($nameAttribute) | Out-Null


		if ($change.AttributeName -eq 'EmailBody')
		{
			$TextInfo = (Get-Culture).TextInfo

			$name = $ImportObject.AnchorPairs[0].AttributeValue
			$pName = $name -replace '[-_.]'
			Write-Debug -Message $pName

			$fName = '.\Files\{0}.emailbody' -f ($TextInfo.ToTitleCase($pName.ToLower()))
			$fName = $fName -replace ' '

			$FullPath = ([System.IO.Path]::GetFullPath((Join-Path -Path $PWD -ChildPath $fName)))

			Write-Debug -Message $FullPath

			Out-File -FilePath $FullPath -InputObject $change.AttributeValue

			$fileAttribute = $rmConfigFile.CreateAttribute('type')
			$fileAttribute.Value = 'file'
			$attrOpElement.Attributes.Append($fileAttribute) | Out-Null

			$attrOpElement.InnerText = $fName
		}
		else
		{
			$attrOpElement.InnerText = $change.AttributeValue
		}
		$attrOps.AppendChild($attrOpElement) | Out-Null
	}
}

function Write-ChangesRCDC
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject]$ImportObject,
		[Parameter(Mandatory = $true)]
		[System.Xml.XmlElement]$Element
	)

	$attrOps = $Element.SelectSingleNode('./AttributeOperations')

	# Create an AttributeOperation element for each change
	foreach ($change in $ImportObject.Changes)
	{
		$attrOpElement = $rmConfigFile.CreateElement('AttributeOperation')

		$attrOpOperationAttribute = $rmConfigFile.CreateAttribute('operation')

		if ($ImportObject.State -eq 'Create')
		{
			$attrOpOperationAttribute.Value = 'add'
		}
		else
		{
			$attrOpOperationAttribute.Value = $change.Operation.ToString().ToLowerInvariant()
		}

		$nameAttribute = $rmConfigFile.CreateAttribute('name')
		$nameAttribute.Value = $change.AttributeName
		$attrOpElement.Attributes.Append($attrOpOperationAttribute) | Out-Null
		$attrOpElement.Attributes.Append($nameAttribute) | Out-Null


		if ($change.AttributeName -eq 'ConfigurationData')
		{
			$TextInfo = (Get-Culture).TextInfo

			$name = $ImportObject.AnchorPairs[0].AttributeValue
			$pName = $name -replace '[-_.]'
			$pName = $name -replace '^urn:uuid:'

			Write-Debug -Message $pName

			$fName = '.\Files\{0}.XOML.RCDC' -f ($TextInfo.ToTitleCase($pName.ToLower()))
			$fName = $fName -replace ' '

			$FullPath = ([System.IO.Path]::GetFullPath((Join-Path -Path $PWD -ChildPath $fName)))

			Write-Debug -Message $FullPath

			Out-File -FilePath $FullPath -InputObject $change.AttributeValue

			$fileAttribute = $rmConfigFile.CreateAttribute('type')
			$fileAttribute.Value = 'file'
			$attrOpElement.Attributes.Append($fileAttribute) | Out-Null

			$attrOpElement.InnerText = $fName
		}
		elseif ($change.AttributeName -eq 'StringResources')
		{
			$TextInfo = (Get-Culture).TextInfo

			$name = $ImportObject.AnchorPairs[0].AttributeValue
			$pName = $name -replace '[-_.]'
			$pName = $name -replace '^urn:uuid:'

			Write-Debug -Message $pName

			$fName = '.\Files\{0}.Strings.RCDC' -f ($TextInfo.ToTitleCase($pName.ToLower()))
			$fName = $fName -replace ' '

			$FullPath = ([System.IO.Path]::GetFullPath((Join-Path -Path $PWD -ChildPath $fName)))

			Write-Debug -Message $FullPath

			Out-File -FilePath $FullPath -InputObject $change.AttributeValue

			$fileAttribute = $rmConfigFile.CreateAttribute('type')
			$fileAttribute.Value = 'file'
			$attrOpElement.Attributes.Append($fileAttribute) | Out-Null

			$attrOpElement.InnerText = $fName

		}
		else
		{
			$attrOpElement.InnerText = $change.AttributeValue
		}
		$attrOps.AppendChild($attrOpElement) | Out-Null
	}
}


function Write-ChangesWorkflowDefinition
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[Microsoft.ResourceManagement.Automation.ObjectModel.ImportObject]$ImportObject,
		[Parameter(Mandatory = $true)]
		[System.Xml.XmlElement]$Element
	)

	$attrOps = $Element.SelectSingleNode('./AttributeOperations')

	# Create an AttributeOperation element for each change
	foreach ($change in $ImportObject.Changes)
	{
		$attrOpElement = $rmConfigFile.CreateElement('AttributeOperation')

		$attrOpOperationAttribute = $rmConfigFile.CreateAttribute('operation')

		if ($ImportObject.State -eq 'Create')
		{
			$attrOpOperationAttribute.Value = 'add'
		}
		else
		{
			$attrOpOperationAttribute.Value = $change.Operation.ToString().ToLowerInvariant()
		}

		$nameAttribute = $rmConfigFile.CreateAttribute('name')
		$nameAttribute.Value = $change.AttributeName
		$attrOpElement.Attributes.Append($attrOpOperationAttribute) | Out-Null
		$attrOpElement.Attributes.Append($nameAttribute) | Out-Null


		if ($change.AttributeName -eq 'XOML')
		{
			$TextInfo = (Get-Culture).TextInfo

			$name = $ImportObject.AnchorPairs[0].AttributeValue
			$pName = $name -replace '[-_.:]'
			Write-Debug -Message $pName

			$fName = '.\Files\{0}.Workflow.xoml' -f ($TextInfo.ToTitleCase($pName.ToLower()))
			$fName = $fName -replace ' '

			$FullPath = ([System.IO.Path]::GetFullPath((Join-Path -Path $PWD -ChildPath $fName)))

			Write-Debug -Message $FullPath

			Out-File -FilePath $FullPath -InputObject $change.AttributeValue

			$fileAttribute = $rmConfigFile.CreateAttribute('type')
			$fileAttribute.Value = 'file'
			$attrOpElement.Attributes.Append($fileAttribute) | Out-Null

			$attrOpElement.InnerText = $fName
		}
		else
		{
			$attrOpElement.InnerText = $change.AttributeValue
		}
		$attrOps.AppendChild($attrOpElement) | Out-Null
	}
}


function Write-ChangesSet
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$ImportObject,
		[Parameter(Mandatory = $true)]
		[System.Xml.XmlElement]$Element
	)

	$attrOps = $Element.SelectSingleNode('./AttributeOperations')

	# Create an AttributeOperation element for each change
	foreach ($change in $ImportObject.Changes)
	{
		if ($ImportObject.State -eq 'Create')
		{
			$operation = 'add'
		}
		else
		{
			$operation = $change.Operation.ToString().ToLowerInvariant()
		}


		if ($change.AttributeName -eq 'ExplicitMember')
		{
			#Write-Debug -Message $change.AttributeValue
			if (!$change.FullyResolved)
			{
				$member = Resolve-UuidFromFile -ChangeFile $PolicyChangesFile -Uuid $change.AttributeValue
			}
			else
			{
				$member = $change.AttributeValue
			}

			if ($member)
			{
				$message = ' [{0}] ExplicitMember [{1}] ' -f $operation, $member
				$attrOps.AppendChild($rmConfigFile.CreateComment($message)) | Out-Null
			}
			continue
		}

		$attrOpElement = $rmConfigFile.CreateElement('AttributeOperation')

		$attrOpOperationAttribute = $rmConfigFile.CreateAttribute('operation')
		$attrOpOperationAttribute.Value = $operation
		$nameAttribute = $rmConfigFile.CreateAttribute('name')
		$nameAttribute.Value = $change.AttributeName
		$attrOpElement.Attributes.Append($attrOpOperationAttribute) | Out-Null
		$attrOpElement.Attributes.Append($nameAttribute) | Out-Null

		if ($change.AttributeName -eq 'Filter')
		{
			[xml]$filter = $change.AttributeValue
			$filterText = $filter.Filter.'#text'
			$typeAttribute = $rmConfigFile.CreateAttribute('type')
			$typeAttribute.Value = 'filter'
			$attrOpElement.Attributes.Append($typeAttribute) | Out-Null
			$attrOpElement.InnerText = $filterText
			$attrOps.AppendChild($attrOpElement) | Out-Null
			continue
		}
		else
		{
			if (!$change.FullyResolved)
			{
				$typeAttribute = $rmConfigFile.CreateAttribute('type')
				$typeAttribute.Value = 'ref'
				$attrOpElement.Attributes.Append($typeAttribute) | Out-Null
				$attrOpElement.InnerText = Resolve-UuidFromFile -ChangeFile $PolicyChangesFile -Uuid $change.AttributeValue
			}
			else
			{
				$attrOpElement.InnerText = $change.AttributeValue
			}
		}
		$attrOps.AppendChild($attrOpElement) | Out-Null
	}
}


<#
	.SYNOPSIS
		Test if object is fully resolved

	.DESCRIPTION
		A detailed description of the Test-Resolved function.

	.PARAMETER ImportObject
		A description of the ImportObject parameter.

	.PARAMETER ResolveInService
		A description of the ResolveInService parameter.

	.PARAMETER
		A description of the  parameter.

	.EXAMPLE
		PS C:\> Test-Resolved -ImportObject $value1 - $value2

	.NOTES
		Additional information about the function.
#>
function Test-Resolved
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		$ImportObject,
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[bool]$ResolveInService
	)

	$returnValue = $false
	$objectType = $ImportObject.ObjectType

	switch ($objectType)
	{
		"ActivityInformationConfiguration"
		{
			$returnValue = $true
		}
		"EmailTemplate"
		{
			$returnValue = $true
		}
		"FilterScope"
		{
			$returnValue = $true
		}
		"HomepageConfiguration"
		{
			$returnValue = $true
		}
		"ManagementPolicyRule"
		{
			$returnValue = $true
		}
		"NavigationBarConfiguration"
		{
			$returnValue = $true
		}
		"ObjectVisualizationConfiguration"
		{
			$returnValue = $true
		}
		"PortalUIConfiguration"
		{
			$returnValue = $true
		}
		"SearchScopeConfiguration"
		{
			$returnValue = $true
		}
		"Set"
		{
			$returnValue = $true
		}
		"SynchronizationFilter"
		{
			$returnValue = $true
		}
		"SynchronizationRule"
		{
			$returnValue = $true
		}
		"WorkflowDefinition"
		{
			$resolved = $true
			<#
			foreach ($c in $ImportObject.Changes)
			{
				if ($c.FullyResolved -eq $false)
				{
					$resolved = $false
				}
			}#>
			$returnValue = $resolved
		}
		default
		{
			$returnValue = $false
		}
	}

	Write-Output -InputObject $returnValue
}

<#
	.SYNOPSIS
		gets display information about an import object

	.DESCRIPTION
		gets display information about an import object, such as ObjectType and anchor attribute info

	.PARAMETER ImportObject
		A description of the ImportObject parameter.

	.EXAMPLE
				PS C:\> Get-ImportObjectInfo -ImportObject $value1

	.NOTES
		Additional information about the function.
#>
function Get-ImportObjectInfo
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		$ImportObject
	)
	$anchor = New-Object System.Collections.ArrayList

	foreach ($a in $ImportObject.AnchorPairs)
	{
		$anchor.Add(('{0} == {1}' -f $a.AttributeName, $a.AttributeValue)) | Out-Null
	}

	if ($anchor.Count -gt 1)
	{
		$anchorString = $anchor.ToArray() -join ' & '
	}
	else
	{
		$anchorString = $anchor[0].ToString()
	}
	Write-Output ('{0}: {1}' -f $ImportObject.ObjectType, $anchorString)
}






<#
	.SYNOPSIS
		A brief description of the Add-Prerequisites function.

	.DESCRIPTION
		A detailed description of the Add-Prerequisites function.

	.PARAMETER ChangesFile
		The description of a the ChangesFile parameter.

	.PARAMETER ImportObject
		The description of a the ImportObject parameter.

	.EXAMPLE
		PS C:\> Add-Prerequisites -ChangesFile 'One value' -ImportObject 32
		'This is the output'
		This example shows how to call the Add-Prerequisites function with named parameters.

	.EXAMPLE
		PS C:\> Add-Prerequisites 'One value' 32
		'This is the output'
		This example shows how to call the Add-Prerequisites function with positional parameters.

	.OUTPUTS
		System.String

	.NOTES
		For more information about advanced functions, call Get-Help with any
		of the topics in the links listed below.

	.INPUTS
		System.String,System.Int32

	.LINK
		about_functions_advanced

	.LINK
		about_comment_based_help

	.LINK
		about_functions_advanced_parameters

	.LINK
		about_functions_advanced_methods
#>
function Add-Prerequisites
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		$ChangesFile,
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 1)]
		[object[]]$ImportObject
	)

	begin
	{
		if (Test-Path -Path $ChangesFile)
		{
			Write-Debug -Message 'Changes file OK'
		}
		else
		{
			Write-Error -Message 'Changes file not found'
		}
		$regex = [regex] '[-0-9a-f]{36}'
		$blank = '00000000-0000-0000-0000-000000000000'
		$textAttributes = @('XOML', 'Filter')
		$prerequisiteArray = New-Object -TypeName System.Collections.ArrayList
	}
	process
	{
		foreach ($object in $ImportObject)
		{
			Write-Debug -Message (Get-ImportObjectInfo -ImportObject $object)
			$prerequisiteArray.Clear()

			foreach ($change in $object.Changes)
			{
				if (($change.FullyResolved -eq $false) -and ($change.AttributeName -ne 'ExplicitMember'))
				{
					$textToSearch = $change.AttributeValue

					$matchdetails = $regex.Match($textToSearch)
					while ($matchdetails.Success)
					{
						$foundUuid = $null
						if ($matchdetails.Value -ne $blank)
						{
							$foundUuid = (Resolve-UuidFromFile -ChangeFile $ChangesFile -Uuid $matchdetails.Value)
						}
						if ($foundUuid)
						{
							$parts = $foundUuid -split '\|'
							if ($parts[2] -match '^urn:uuid:[-0-9a-f]{36}')
							{
								$parts[2] = $parts[2] -replace '^urn:uuid:'
							}
							$resourceSearchString = '/{0}[{1} = "{2}"]' -f $parts[0], $parts[1], $parts[2]
							$p = New-Object PSObject -Property @{
								ChangeAttribute = $change.AttributeName
								Source = $matchdetails.Value
								Search = $resourceSearchString
								Target = $null
							}
							[void]($prerequisiteArray.Add($p))
						}
						else
						{
							if ($matchdetails.Value -ne $blank)
							{
								$resourceSearchString = '/*[ObjectID = "{0}"]' -f $matchdetails.Value
								$p = New-Object PSObject -Property @{
									ChangeAttribute = $change.AttributeName
									Source = $matchdetails.Value
									Search = $resourceSearchString
									Target = $null
								}
								[void]($prerequisiteArray.Add($p))
							}
						}
						$matchdetails = $matchdetails.NextMatch()
					}
				}
			}

			if ($prerequisiteArray.Count -gt 0)
			{
				if (Get-Member -InputObject $object -Name 'Prerequisites')
				{
					$object.Prerequisites = $prerequisiteArray.Clone()
				}
				else
				{
					Add-Member -InputObject $object -MemberType NoteProperty -Name 'Prerequisites' -Value $prerequisiteArray.Clone()
				}
			}
			Write-Output $object
		}
	}
	end
	{
		#Write-Output -InputObject $resolvedHash
	}
}

Export-ModuleMember -Function Add-Prerequisites


<#
	.SYNOPSIS
		A brief description of the Test-Prerequisites function.

	.DESCRIPTION
		A detailed description of the Test-Prerequisites function.

	.PARAMETER ImportObject
		A description of the ImportObject parameter.

	.EXAMPLE
		PS C:\> Test-Prerequisites -ImportObject $value1

	.NOTES
		Additional information about the function.
#>
function Test-Prerequisites
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0)]
		[object[]]$ImportObject
	)

	begin
	{
	}
	process
	{
		foreach ($object in $ImportObject)
		{
			$goodtogo = $true

			Write-Verbose -Message (Get-ImportObjectInfo -ImportObject $object)

			if ($object.Prerequisites)
			{
				foreach ($p in $object.Prerequisites)
				{
					$found = Search-Resources -XPath $p.Search -MaxResults 1
					if ($found)
					{
						Write-Debug -Message ('Found: {0} == {1}' -f $p.Search, $found.ObjectID.Value)
						$p.Target = $found.ObjectID.Value
					}
					else
					{
						Write-Error -Message ('Not found: {0}' -f $p.Search) -ErrorAction Continue
						$goodtogo = $false
					}
				}
			}
			else
			{
				Write-Debug -Message 'No prerequisites'
			}
			if ($goodtogo)
			{
				Write-Output $object
			}
		}
	}
	end
	{
		#Write-Output -InputObject $resolvedHash
	}
}

Export-ModuleMember -Function Test-Prerequisites


<#
	.SYNOPSIS
		A brief description of the Resolve-Prerequisites function.

	.DESCRIPTION
		A detailed description of the Resolve-Prerequisites function.

	.PARAMETER ImportObject
		A description of the ImportObject parameter.

	.EXAMPLE
		PS C:\> Resolve-Prerequisites -ImportObject $value1

	.NOTES
		Additional information about the function.
#>
function Resolve-Prerequisites
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0)]
		[object[]]$ImportObject
	)

	begin
	{
		$processed = 0
		$prereqCount = 0
	}
	process
	{
		foreach ($object in $ImportObject)
		{
			$processed++
			$goodtogo = $true

			Write-Verbose -Message (Get-ImportObjectInfo -ImportObject $object)

			if ($object.Prerequisites)
			{
				foreach ($p in $object.Prerequisites)
				{
					$prereqCount++
					switch ($p.ChangeAttribute)
					{
						'Filter'
						{
							if ($p.Target -and ($p.Source -ne $p.Target))
							{
								$filter = $object.Changes | Where-Object AttributeName -EQ 'Filter'
								if ($filter)
								{
									$filter.AttributeValue = $filter.AttributeValue -replace $p.Source, $p.Target
								}
							}
						}
						'XOML'
						{
							if ($p.Target -and ($p.Source -ne $p.Target))
							{
								$xoml = $object.Changes | Where-Object AttributeName -EQ 'XOML'
								if ($xoml)
								{
									$xoml.AttributeValue = $xoml.AttributeValue -replace $p.Source, $p.Target
								}
							}
						}
						'SearchScope'
						{
							if ($p.Target -and ($p.Source -ne $p.Target))
							{
								$scope = $object.Changes | Where-Object AttributeName -EQ 'SearchScope'
								if ($scope)
								{
									$scope.AttributeValue = $scope.AttributeValue -replace $p.Source, $p.Target
								}
								$scope.FullyResolved = $true
							}
						}
						default
						{
							Write-Debug -Message ('Resolve is looking for {0}' -f $p.ChangeAttribute)
						}
					}
				}
			}
			else
			{
				Write-Debug -Message 'No prerequisites'
			}
			Write-Output $object
		}
	}
	end
	{
		Write-Debug -Message ('Processed {0} prerequisites on {1} objects' -f $prereqCount, $processed)
	}
}

Export-ModuleMember -Function Resolve-Prerequisites


<#
	.SYNOPSIS
		creates new ResourceOperation element

	.DESCRIPTION
		A detailed description of the New-ResourceOperation function.

	.PARAMETER XmlDoc
		A description of the XmlDoc parameter.

	.PARAMETER ObjectType
		A description of the ObjectType parameter.

	.EXAMPLE
		PS C:\> New-ResourceOperation

	.NOTES
		Additional information about the function.
#>
function New-ResourceOperation
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[System.Xml.XmlDocument]$XmlDoc,
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[string]$ObjectType
	)

	$resOp = $XmlDoc.CreateElement('ResourceOperation')

	# Create the attributes for the ResourceOperation element
	$opAttr = $XmlDoc.CreateAttribute('operation')
	$opAttr.Value = "Add Update"
	$rTypeAttr = $XmlDoc.CreateAttribute('resourceType')
	$rTypeAttr.Value = $ObjectType
	$idAttr = $XmlDoc.CreateAttribute('id')
	$guid = ('urn:uuid:{0}' -f ([guid]::NewGuid().ToString()))
	$idAttr.Value = $guid

	[void]($resOp.Attributes.Append($opAttr))
	[void]($resOp.Attributes.Append($rTypeAttr))
	[void]($resOp.Attributes.Append($idAttr))

	$opsNode = $XmlDoc.SelectSingleNode('//Operations')
	[void]($opsNode.AppendChild($resOp))

	Write-Output $guid
}
Export-ModuleMember -Function New-ResourceOperation

function Add-Anchor
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[System.Xml.XmlDocument]$XmlDoc,
		[Parameter(Mandatory = $true)]
		[Alias('ID')]
		[string]$Identifier,
		[Parameter(Mandatory = $true)]
		[string]$Anchor
	)

	$search = '//ResourceOperation[@id="{0}"]' -f $Identifier
	$node = $XmlDoc.SelectSingleNode($search)
	if ($node)
	{
		$aa = $node.SelectSingleNode('./AnchorAttributes')
		if ($aa)
		{
			$new = $aa.AppendChild($XmlDoc.CreateElement('AnchorAttribute'))
			$new.InnerText = $Anchor
		}
		else
		{
			$aa = $node.AppendChild($XmlDoc.CreateElement('AnchorAttributes'))
			$new = $aa.AppendChild($XmlDoc.CreateElement('AnchorAttribute'))
			$new.InnerText = $Anchor
		}
	}
	else
	{
		Write-Error -Message ('Cannot find ResourceOperation: {0}' -f $Identifier)
	}
}
Export-ModuleMember -Function Add-Anchor

function Add-AttributeOperation
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[System.Xml.XmlDocument]$XmlDoc,
		[Parameter(Mandatory = $true)]
		[Alias('ID')]
		[string]$Identifier,
		[Parameter(Mandatory = $true)]
		[ValidateSet('none', 'add', 'replace', 'delete')]
		[string]$Operation,
		[Parameter(Mandatory = $true)]
		[string]$AttributeName,
		[ValidateSet('file', 'xmlref', 'filter', 'ref')]
		[string]$Type,
		[Parameter(Mandatory = $true)]
		$Value
	)

	$search = '//ResourceOperation[@id="{0}"]' -f $Identifier
	$node = $XmlDoc.SelectSingleNode($search)
	if ($node)
	{
		$attributeOps = $node.SelectSingleNode('./AttributeOperations')
		if (!$attributeOps)
		{
			$attributeOps = $node.AppendChild($XmlDoc.CreateElement('AttributeOperations'))
		}
		$op = $XmlDoc.CreateElement('AttributeOperation')

		$opAttr = $XmlDoc.CreateAttribute('operation')
		$opAttr.Value = $Operation.ToLowerInvariant()
		$nameAttr = $XmlDoc.CreateAttribute('name')
		$nameAttr.Value = $AttributeName
		[void]($op.Attributes.Append($opAttr))
		[void]($op.Attributes.Append($nameAttr))

		if ($PSBoundParameters.ContainsKey('Type'))
		{
			$typeAttr = $XmlDoc.CreateAttribute('type')
			$typeAttr.Value = $Type.ToLowerInvariant()
			[void]($op.Attributes.Append($typeAttr))
		}
		$op.InnerText = $Value
		[void]($attributeOps.AppendChild($op))
	}
	else
	{
		Write-Error -Message ('Cannot find ResourceOperation: {0}' -f $Identifier)
	}
}
Export-ModuleMember -Function Add-AttributeOperation

<#
	.SYNOPSIS
		Writes MIM group objects to file
	
	.DESCRIPTION
		A detailed description of the Write-RMGroup function.
	
	.PARAMETER Path
		A description of the Path parameter.
	
	.PARAMETER Group
		A description of the Group parameter.
	
	.EXAMPLE
				PS C:\> Write-RMGroup -Path 'Value1' -Group $value2
	
	.NOTES
		Additional information about the function.
#>
function Write-RMGroup
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[string]$Path,
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $true)]
		[object[]]$Group
	)
	
	begin
	{
		$excludedList = @('ComputedActor', 'ComputedMember', 'Creator', 'CreatedTime', 'DeletedTime', 'DetectedRulesList', 'DomainConfiguration', 'ExpectedRulesList', 'MVObjectID', 'ObjectID', 'ObjectSID', 'ResourceTime', 'SIDHistory')
		$filePath = New-RMConfigFile -Path $Path -Force
		[xml]$xmlDoc = Get-Content -Path $filePath
		
		
	}
	process
	{
		foreach ($grp in $Group)
		{
			Write-Debug $grp.DisplayName
			$resourceID = New-ResourceOperation -ObjectType 'Group' -XmlDoc $xmlDoc
			if ($grp.AccountName)
			{
				Add-Anchor -XmlDoc $xmlDoc -Identifier $resourceID -Anchor AccountName
			}
			$properties = Get-Member -InputObject $grp -MemberType NoteProperty
			foreach ($prp in $properties)
			{
				if (($prp.Name -notin $excludedList) -and ($grp.$($prp.Name)))
				{
					switch ($prp.Name)
					{
						'ExplicitMember'
						{
							# find the members and write them out
							
							foreach ($member in $grp.ExplicitMember)
							{
								$u = Get-Resource -ID $member
								$lookup = '{0}|AccountName|{1}' -f $u.ObjectType, $u.AccountName
								Add-AttributeOperation -XmlDoc $xmlDoc -Identifier $resourceID -Operation 'add' -AttributeName 'ExplicitMember' -Type 'ref' -Value $lookup
							}
						}
						'Filter'
						{
							[xml]$filterXML = $grp.Filter
							$filterText = $filterXML.Filter.'#text'
							Add-AttributeOperation -XmlDoc $xmlDoc -Identifier $resourceID -Operation add -AttributeName 'Filter' -Type filter -Value $filterText
							# how to parse, then replace for the new location if there are guids in it?
						}
						default
						{
							$itemType = $grp.$($prp.Name).GetType().Name
							
							switch ($itemType) {
								'UniqueIdentifier'
								{
									$u = Get-Resource -ID $grp.$($prp.Name)
									$lookup = '{0}|AccountName|{1}' -f $u.ObjectType, $u.AccountName
									Add-AttributeOperation -XmlDoc $xmlDoc -Identifier $resourceID -Operation 'add' -AttributeName $prp.Name -Type 'ref' -Value $lookup
								}
								'AttributeValueArrayList'
								{
									foreach ($item in $grp.$($prp.Name))
									{
										$iType = $item.GetType().Name
										if ($iType -eq 'UniqueIdentifier')
										{
											$u = Get-Resource -ID $item
											$lookup = '{0}|AccountName|{1}' -f $u.ObjectType, $u.AccountName
											Add-AttributeOperation -XmlDoc $xmlDoc -Identifier $resourceID -Operation 'add' -AttributeName $prp.Name -Type 'ref' -Value $lookup
										}
										else
										{
											Add-AttributeOperation -XmlDoc $xmlDoc -Identifier $resourceID -Operation add -AttributeName $prp.Name -Value $item
										}
									}
								}
								default
								{
									Add-AttributeOperation -XmlDoc $xmlDoc -Identifier $resourceID -Operation add -AttributeName $prp.Name -Value $grp.$($prp.Name)
								}
							}
						}
					}
					
				}
			}
		}
	}
	end
	{
		$xmlDoc.Save($filePath)
	}
}
Export-ModuleMember -Function Write-RMGroup

