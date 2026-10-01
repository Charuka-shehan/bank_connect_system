$files = Get-ChildItem -Path "src/main/java/com/lankatrust/smartbank/controller/*.java"
$out = [System.Collections.Generic.List[string]]::new()
foreach ($f in $files) {
    $lines = Get-Content $f.FullName
    $out.Add("`n========================================================")
    $out.Add("CONTROLLER: $($f.Name)")
    $baseMapping = ""
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()
        if ($line.StartsWith("@RequestMapping")) {
            $baseMapping = $line
            $out.Add("BASE: $baseMapping")
        }
        if ($line -match '^@(GetMapping|PostMapping|PutMapping|DeleteMapping|PatchMapping)') {
            $methodAnn = $line
            $preAuth = ""
            if ($i -gt 0 -and $lines[$i-1].Trim().StartsWith("@PreAuthorize")) {
                $preAuth = $lines[$i-1].Trim()
            }
            $sig = ""
            for ($j = $i + 1; $j -lt [Math]::Min($i + 5, $lines.Count); $j++) {
                if ($lines[$j].Trim() -match 'public\s+.*\(') {
                    $sig = $lines[$j].Trim()
                    break
                }
            }
            $out.Add("  $methodAnn | $preAuth | $sig")
        }
    }
}
[System.IO.File]::WriteAllLines("scratch/all_endpoints.txt", $out)
