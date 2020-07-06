param([string]$Path='C:\Test\')
  
$SameSizeFiles  = gci -Path $Path -File -Recurse | Select FullName, Length | Group-Object Length | ? {$_.Count -gt 1} #the list of files with same size
$MatchingFiles=@()
$GroupNdx=1
Foreach($SizeGroup in ($SameSizeFiles | Select Group)){
    For($FromNdx = 0; $FromNdx -lt $SizeGroup.Group.Count - 1; $FromNdx++){
        For($ToNdx = $FromNdx + 1; $ToNdx -lt $SizeGroup.Group.Count; $ToNdx++){
            If( (fc.exe /A $SizeGroup.Group[$FromNdx].FullName $SizeGroup.Group[$ToNdx].FullName)){
                $MatchingFiles += [pscustomobject]@{File=$SizeGroup.Group[$FromNdx].FullName; Match = $SizeGroup.Group[$ToNdx].FullName }
            }
        }
    }
    Write-Progress -Activity "Finding Duplicates" -status  "Processing group $GroupNdx of $($SameSizeFiles.Count)" -PercentComplete ($GroupNdx / $SameSizeFiles.Count * 100)
    $GroupNdx += 1
}
$MatchingFiles