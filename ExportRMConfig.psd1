﻿<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.2.119
	 Created on:   	2016-04-18 5:50 PM
	 Created by:   	 
	 Organization: 	 
	 Filename:     	ExportRMConfig.psd1
	 -------------------------------------------------------------------------
	 Module Manifest
	-------------------------------------------------------------------------
	 Module Name: ExportRMConfig
	===========================================================================
#>

@{
	
	# Script module or binary module file associated with this manifest
	ModuleToProcess = 'ExportRMConfig.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.0.0.0'
	
	# ID used to uniquely identify this module
	GUID = '4b3a9b14-fac7-44f8-b48b-3a86b89cb625'
	
	# Author of this module
	Author = 'James Booth'
	
	# Company or vendor of this module
	CompanyName = 'BoothBilt'
	
	# Copyright statement for this module
	Copyright = '(c) 2016. All rights reserved.'
	
	# Description of the functionality provided by this module
	Description = 'Module that leverages the FIMAutomation snap-in and the LithnetRMA module to write FIM/MIM configuration information to XML file.'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '3.0'
	
	# Name of the Windows PowerShell host required by this module
	PowerShellHostName = ''
	
	# Minimum version of the Windows PowerShell host required by this module
	PowerShellHostVersion = ''
	
	# Minimum version of the .NET Framework required by this module
	DotNetFrameworkVersion = '3.5'
	
	# Minimum version of the common language runtime (CLR) required by this module
	CLRVersion = '3.5'
	
	# Processor architecture (None, X86, Amd64, IA64) required by this module
	ProcessorArchitecture = 'None'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @('LithnetRMA')
	
	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies = @()
	
	# Script files (.ps1) that are run in the caller's environment prior to
	# importing this module
	ScriptsToProcess = @()
	
	# Type files (.ps1xml) to be loaded when importing this module
	TypesToProcess = @()
	
	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @()
	
	# Modules to import as nested modules of the module specified in
	# ModuleToProcess
	NestedModules = @()
	
	# Functions to export from this module
	FunctionsToExport = '*'
	
	# Cmdlets to export from this module
	CmdletsToExport = '*'
	
	# Variables to export from this module
	VariablesToExport = '*'
	
	# Aliases to export from this module
	AliasesToExport = '*'
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			# Tags = @()
			
			# A URL to the license for this module.
			# LicenseUri = ''
			
			# A URL to the main website for this project.
			# ProjectUri = ''
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}







