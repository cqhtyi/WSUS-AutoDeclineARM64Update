$wsus = Get-WsusServer
$allUpdates = $wsus.GetUpdates() | Where-Object { -not $_.IsDeclined }
$arm64List = @()

foreach($u in $allUpdates)
{
    $title = $u.Title.ToLower()
    if ($title -match "arm64" -and $title -notmatch "x64|amd64")
    {
        $arm64List += [PSCustomObject]@{
            UpdateId = $u.Id.UpdateId
            Revision = $u.Id.RevisionNumber
        }
    }
}

if ($arm64List.Count -gt 0)
{
    foreach($item in $arm64List)
    {
        $wu = Get-WsusUpdate -UpdateId $item.UpdateId -RevisionNumber $item.Revision
        if($wu -and -not $wu.Update.IsDeclined)
        {
            Deny-WsusUpdate -Update $wu
        }
    }
    Invoke-WsusServerCleanup -CleanupUnneededContentFiles -CleanupObsoleteUpdates
}
