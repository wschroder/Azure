$rg = 'arm-template-test'
$templateFilePath = "$($PSScriptRoot)\arm-template.json"
$parameterFilePath = "$($PSScriptRoot)\arm-template-parameters.json"

New-AzResourceGroupDeployment -ResourceGroupName $rg `
            -TemplateFile $templateFilePath `
            -TemplateParameterFile $parameterFilePath