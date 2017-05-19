Param([string]$VcpkgRoot = "")

$ErrorActionPreference = "Stop"

if (!$VcpkgRoot) {
    $VcpkgRoot = ".."
}

$VcpkgRoot = Resolve-Path $VcpkgRoot

if (!(Test-Path "$VcpkgRoot\.vcpkg-root")) {
    throw "Invalid vcpkg instance, did you forget -VcpkgRoot?"
}

Set-Content -Path "$PSScriptRoot\maintainers\cmake-helpers.md" -Value "<!-- Run regenerate.ps1 to extract documentation from scripts\cmake\*.cmake -->`n`n# CMake Helpers for Portfiles"

ls "$VcpkgRoot\scripts\cmake\*.cmake" | % {
    $contents = Get-Content $_ `
    | ? { $_ -match "^## |^##`$" } `
    | % { $_ -replace "^## ?","" }

    if ($contents) {
        Set-Content -Path "$PSScriptRoot\maintainers\$($_.BaseName).md" -Value "$($contents -join "`n")`n`n### Source`n[https://github.com/Microsoft/vcpkg/blob/master/scripts/cmake/$($_.Name)]()"
        "- [$($_.BaseName -replace "_","\_")]($($_.BaseName).md)" `
        | Out-File -Enc Ascii -Append -FilePath "$PSScriptRoot\maintainers\cmake-helpers.md"
    }
}
