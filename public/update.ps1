function Get-VariablesFromData {
  param (
    [string[]]$data
  )

  $result = @()

  foreach ($line in $data) {
   if ($line -match '.*:\s*".*"') {
      $match = [regex]::Match($line, '(.*):\s*"(.*)"')
      $key = $match.Groups[1].Value.Trim().Replace('"', '')
      $value = $match.Groups[2].Value.Trim()
      $result+= $key+':'+$value
      
    }
    if ($line -match '.*=".*"') {
      $match = [regex]::Match($line, '(.*)="(.*)"')
      $key = $match.Groups[1].Value.Trim().Replace('"', '')
      $value = $match.Groups[2].Value.Trim().Replace('"', '')
      $result+= $key+':'+$value
    }
  }
  return $result
}



#get old variables
$envContent = Get-Content .\env.js
$envContent = $envContent -replace 'window.env = {', '' -replace '};', '' -replace '\n', ''
$envArray = $envContent.Split(',')

#get new Variables from vars.txt
$varsContent = Get-Content .\vars.txt
$varsContent = $varsContent -replace '\n', ','
$varsArray = $varsContent.Split(',')


$oldVars = Get-VariablesFromData -data $envArray 

$newVars = Get-VariablesFromData -data $varsArray


#remove duplicates and old values and concat in one variable


$result = @{}
foreach ($nv in $newVars) {
  $nvSplit = $nv -split ':', 2
  if (!$result.ContainsKey($nvSplit[0]) -or $result[$nvSplit[0]] -eq $nvSplit[1]) {
    $result[$nvSplit[0]] = $nvSplit[1]
  }
}

foreach ($ov in $oldVars) {
  $ovSplit = $ov -split ':', 2
  if (!$result.ContainsKey($ovSplit[0]) -or $result[$ovSplit[0]] -eq $ovSplit[1]) {
    $result[$ovSplit[0]] = $ovSplit[1]
  }
}

$resultString = $result.GetEnumerator() | 
                ForEach-Object { '{0}:"{1}"' -f $_.Key, $_.Value }

# convert resultString to string
$variables = $resultString -join ', '

# #remove variables that doesn't match starting with "REACT_APP_[VAR]=[VALUE]"
$allowedVars = $variables -split ', ' | Where-Object { $_ -match 'REACT_APP_.*' } 
$allowedVars = $allowedVars -join ', '

$allowedVars

# remove env.js and re-create env.js

$envContent = 'window.env = { ' + $allowedVars + ' };'
$envContent | Out-File -FilePath .\env.js -Encoding UTF8 -Force

# show message like: env.js updated, { $allowedVars }
Write-Output "envs UPDATED =  { $allowedVars }"

pause







