 
#This is small automation PowerShell script to merge several Excel worksheets to new one.
#Under Microsoft Windows 10.
#Created date: 2019-08-10
#Created by Tommas Huang

#Get a list of files to copy from
$Files = GCI 'C:\Users\TommasHuang\Desktop\excel\' | ?{$_.Extension -Match "xlsx?"} | select -ExpandProperty FullName

#Launch Excel, and make it do as its told (supress confirmations)
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $True
$Excel.DisplayAlerts = $False

#Open up a new workbook
$Dest = $Excel.Workbooks.Add()

#Loop through files, opening each, selecting the Used range, and only grabbing the first 6 columns of it. 
#Then find next available row on the destination worksheet and paste the data
ForEach($File in $Files[0..4]){
    $Source = $Excel.Workbooks.Open($File,$true,$true)
    If(($Dest.ActiveSheet.UsedRange.Count -eq 1) -and ([String]::IsNullOrEmpty($Dest.ActiveSheet.Range("A1").Value2))){ #If there is only 1 used cell and it is blank select A1
        [void]$source.ActiveSheet.Range("A1","K$(($Source.ActiveSheet.UsedRange.Rows|Select -Last 1).Row)").Copy()
        [void]$Dest.Activate()
        [void]$Dest.ActiveSheet.Range("A1").Select()
    }Else{ #If there is data go to the next empty row and select Column A
        [void]$source.ActiveSheet.Range("A1","K$(($Source.ActiveSheet.UsedRange.Rows|Select -Last 1).Row)").Copy()
        [void]$Dest.Activate()
        [void]$Dest.ActiveSheet.Range("A$(($Dest.ActiveSheet.UsedRange.Rows|Select -last 1).row+1)").Select()
    }
    [void]$Dest.ActiveSheet.Paste()
    $Source.Close()
}
$Dest.SaveAs("C:\Users\TommasHuang\Desktop\Book1.xlsx",51)
$Dest.close()
$Excel.Quit()