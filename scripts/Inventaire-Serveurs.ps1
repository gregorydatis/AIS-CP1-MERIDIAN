New-Item -ItemType Directory -Path C:\Inventaire -Force | Out-Null
$filtre = 'OperatingSystem -like "*Server*"'
$serveurs = Get-ADComputer -Filter $filtre -Properties OperatingSystem, LastLogonDate
$inventaire = foreach ($s in $serveurs) {
 $os = Get-CimInstance Win32_OperatingSystem -ComputerName $s.Name -ErrorAction SilentlyContinue
 [PSCustomObject]@{
 Nom = $s.Name
 Systeme = $s.OperatingSystem
 Version = $os.Version
 DernierBoot = $os.LastBootUpTime
 DerniereConn = $s.LastLogonDate
 }
}
$inventaire | Export-Csv C:\Inventaire\serveurs.csv -NoTypeInformation -Encoding UTF8
New-Item -ItemType Directory -Path C:\Inventaire -Force | Out-Null

# 1. Inventaire des serveurs (script du livret)
$filtre = 'OperatingSystem -like "*Server*"'
$serveurs = Get-ADComputer -Filter $filtre -Properties OperatingSystem, LastLogonDate
$inventaire = foreach ($s in $serveurs) {
    $os = Get-CimInstance Win32_OperatingSystem -ComputerName $s.Name -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        Nom          = $s.Name
        Systeme      = $s.OperatingSystem
        Version      = $os.Version
        DernierBoot  = $os.LastBootUpTime
        DerniereConn = $s.LastLogonDate
    }
}
$inventaire | Export-Csv C:\Inventaire\serveurs.csv -NoTypeInformation -Encoding UTF8

# 2. Adaptation : comptes ordinateurs sans connexion depuis 90 jours (ou jamais connectés)
$seuil = (Get-Date).AddDays(-90)
$inactifs = Get-ADComputer -Filter * -Properties OperatingSystem, LastLogonDate, Enabled |
    Where-Object { -not $_.LastLogonDate -or $_.LastLogonDate -lt $seuil } |
    Select-Object Name, OperatingSystem, LastLogonDate, Enabled, DistinguishedName
$inactifs | Export-Csv C:\Inventaire\ordinateurs-inactifs.csv -NoTypeInformation -Encoding UTF8

# 3. Liste complète des ordinateurs AD (pour comparer avec GLPI)
Get-ADComputer -Filter * -Properties OperatingSystem, LastLogonDate |
    Select-Object Name, OperatingSystem, LastLogonDate |
    Export-Csv C:\Inventaire\ordinateurs-ad.csv -NoTypeInformation -Encoding UTF8

Write-Host "Serveurs : $($inventaire.Count) - Inactifs 90 j : $(@($inactifs).Count)"
