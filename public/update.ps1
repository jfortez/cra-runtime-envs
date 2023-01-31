function Get-VariablesFromData {
  param (
    [string[]]$data
  )

  $result = ''
  foreach ($line in $data) {
   if ($line -match '.*:\s*".*"') {
      $match = [regex]::Match($line, '(.*):\s*"(.*)"')
      $key = $match.Groups[1].Value.Trim().Replace('"', '')
      $value = $match.Groups[2].Value.Trim()
      $result+= $key+':'+'"'+$value+'", '
      # $result += '$env:' + $key + '=' + '"' + $value + '"' + '; '
    }
    if ($line -match '.*=".*"') {
      $match = [regex]::Match($line, '(.*)="(.*)"')
      $key = $match.Groups[1].Value.Trim().Replace('"', '')
      $value = $match.Groups[2].Value.Trim().Replace('"', '')
      $result+= $key+':'+'"'+$value+'", '
      # $result += '$env:' + $key + '=' + '"' + $value + '"' + '; '
    }
  }

  $result = $result.Trim()
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


# concat variables $newVars + $oldVars
$vars = $newVars + ' ' + $oldVars

# remove repeat variables
$uniqueVars = $vars -split ', ' | Select-Object -Unique
$uniqueVars = $uniqueVars -join ', '


#remove variables that doesn't match starting with "REACT_APP_[VAR]=[VALUE]"
$allowedVars = $uniqueVars -split ', ' | Where-Object { $_ -match 'REACT_APP_.*' } 
$allowedVars = $allowedVars -join ', '


# remove env.js and re-create env.js

$envContent = 'window.env = { ' + $allowedVars + ' };'
$envContent | Out-File -FilePath .\env.js -Encoding UTF8 -Force

# show message like: env.js updated, { $allowedVars }
Write-Output "envs UPDATED =  { $allowedVars }"









