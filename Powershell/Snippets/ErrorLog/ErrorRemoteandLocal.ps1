<#
LOCAL
#>
Get-EventLog -LogName System -EntryType Error


<#
REMOTE

Invoke-Commmand -ComputerName COMPUTER -ScriptBlock
{
    Get-EventLog -LogName System -EntryType Error
}
#>
