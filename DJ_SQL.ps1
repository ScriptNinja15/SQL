Function DJ_Get-SQLdatabase
{
    <#
    .DESCRIPTION
        Gets all SQL databases on particular server
    .EXAMPLE
        DJ_Get-SQLdatabase -Server some_server
    .NOTES
        Author: Delonte JOhnson
    #>
    
    [CmdletBinding()]
    
    Param
    (
        [parameter(Mandatory=$true)][string] $Server
    )

    #Load neccessary assembly
    Add-Type -AssemblyName System.Data

    #Create new SQL connection
    $sqlconnection = New-Object -TypeName System.Data.SqlClient.SqlConnection("Server=$server; Database=master; Integrated Security=$true")

    #Create new SQL Adapter to send SQL commands
    $sqladatper = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter
   
    #Create new SQL Dataset to return SQL data
    $dataset = New-Object -TypeName System.Data.DataSet

    #Open connection to database
    $sqlconnection.Open()

    #Insert data into database
    $sqlcmd = New-Object -TypeName System.Data.SqlClient.SqlCommand('select * from sys.databases', $sqlconnection)

    $sqladatper.SelectCommand = $sqlcmd
    [void]$sqladatper.Fill($dataset)

    #Close connnection to database
    $sqlconnection.Close()

    #Output queried data
    $dataset.Tables.Rows | Select @{l='Name';e={$_.name}}, @{l='Created';e={$_.create_date}}, @{l='Server'; e={$server}} 

}

Function DJ_Get-SQLtable
{
    <#
    .DESCRIPTION
        Gets all tables for particular SQL database
    .EXAMPLE
        DJ_Get-SQLtable -Server some_server -Table some_table
    .NOTES
        Author: Delonte JOhnson
    #>
    
    [CmdletBinding()]
    
    Param
    (
        [parameter(Mandatory=$true)][string] $Server,
        [parameter(Mandatory=$true)][string] $Table
    )

    #Load neccessary assembly
    Add-Type -AssemblyName System.Data

    #Create new SQL connection
    $sqlconnection = New-Object -TypeName System.Data.SqlClient.SqlConnection("Server=$server; Database=master; Integrated Security=$true")

    #Create new SQL Adapter to send SQL commands
    $sqladatper = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter
   
    #Create new SQL Dataset to return SQL data
    $dataset = New-Object -TypeName System.Data.DataSet

    #Open connection to database
    $sqlconnection.Open()

    #Insert data into database
    $sqlcmd = New-Object -TypeName System.Data.SqlClient.SqlCommand("select * from $table.INFORMATION_SCHEMA.TABLES", $sqlconnection)

    $sqladatper.SelectCommand = $sqlcmd
    [void]$sqladatper.Fill($dataset)

    #Close connnection to database
    $sqlconnection.Close()

    #Output queried data
    $dataset.Tables.Rows | Select @{l='Database'; e={$_.TABLE_CATALOG}}, @{l='Schema'; e={$_.TABLE_SCHEMA}}, @{l='Name'; e={$_.TABLE_NAME}}  
}

Function DJ_Invoke-SQLselect
{
    <#
    .DESCRIPTION
        Invokes SQL select statement on particular database
    .EXAMPLE
        DJ_Invoke-SQLselect -Server some_server -Database some_database -SQLselect "SELECT * FROM some_table"
    .EXAMPLE
        "SELECT * FROM some_table" | DJ_Invoke-SQLselect -Server Some_Server -Database Some_Database
    .NOTES
        Author: Delonte JOhnson
    #>
    
    [CmdletBinding()]
    
    Param
    (
        [parameter(Mandatory=$true)][string] $Server,
        [parameter(Mandatory=$true)][string] $Database,
        [parameter(Mandatory=$true, ValueFromPipeline=$true)][string] $SQLselect
    )

    #Load neccessary assembly
    Add-Type -AssemblyName System.Data

    #Create new SQL connection
    $sqlconnection = New-Object -TypeName System.Data.SqlClient.SqlConnection("Server=$server; Database=$database; Integrated Security=$true")

    #Create new SQL Adapter to send SQL commands
    $sqladatper = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter
   
    #Create new SQL Dataset to return SQL data
    $dataset = New-Object -TypeName System.Data.DataSet

    #Open connection to database
    $sqlconnection.Open()

    #Insert data into database
    $sqlcmd = New-Object -TypeName System.Data.SqlClient.SqlCommand("$SQLselect", $sqlconnection)

    $sqladatper.SelectCommand = $sqlcmd
    [void]$sqladatper.Fill($dataset)

    #Close connnection to database
    $sqlconnection.Close()

    #Output queried data
    $dataset.Tables.Rows
}

Function DJ_Invoke-SQLinsert
{
    <#
    .DESCRIPTION
        Invokes SQL insert statement on particular database
    .EXAMPLE
        DJ_Invoke-SQLinsert -Server some_server -Database some_database -SQLinsert "INSERT INTO some_table (field1, field2, field3) VALUES ('value1', 'value2', 'value3')"
    .EXAMPLE
        "INSERT INTO some_table (field1, field2, field3) VALUES ('value1', 'value2', 'value3')" | DJ_Invoke-SQLinsert -Server some_server -Database some_database
    .NOTES
        Author: Delonte JOhnson
    #>
    
    [CmdletBinding()]
    
    Param
    (
        [parameter(Mandatory=$true)][string] $Server,
        [parameter(Mandatory=$true)][string] $Database,
        [parameter(Mandatory=$true, ValueFromPipeline=$true)][string] $SQLinsert
    )

    #Load neccessary assembly
    Add-Type -AssemblyName System.Data

    #Create new SQL connection
    $sqlconnection = New-Object -TypeName System.Data.SqlClient.SqlConnection("Server=$server; Database=$database; Integrated Security=$true")

    #Create new SQL Adapter to send SQL commands
    $sqladatper = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter
   
    #Create new SQL Dataset to return SQL data
    $dataset = New-Object -TypeName System.Data.DataSet

    #Open connection to database
    $sqlconnection.Open()

    #Insert data into database
    $sqlcmd = New-Object -TypeName System.Data.SqlClient.SqlCommand("$SQLinsert", $sqlconnection)
 
    $sqladatper.InsertCommand = $sqlcmd
    $result = $sqlcmd.ExecuteNonQuery()
 
    #Close connnection to database
    $sqlconnection.Close()

    #Output success message
    If($result)
    {
        Write-Output 'Command successfully executed!'
    }
    
}

Function DJ_Invoke-SQLupdate
{
    <#
    .DESCRIPTION
        Invokes SQL update statement on particular database
    .EXAMPLE
        DJ_Invoke-SQLupdate -Server some_server -Database some_database -SQLupdate "UPDATE some_table SET some_field WHERE some_field='some_value'"
    .EXAMPLE
        "UPDATE some_table SET some_field WHERE some_field='some_value'" | DJ_Invoke-SQLupdate -Server some_server -Database some_database
    .NOTES
        Author: Delonte JOhnson
    #>
    
    [CmdletBinding()]
    
    Param
    (
        [parameter(Mandatory=$true)][string] $Server,
        [parameter(Mandatory=$true)][string] $Database,
        [parameter(Mandatory=$true, ValueFromPipeline=$true)][string] $SQLupdate
    )

    #Load neccessary assembly
    Add-Type -AssemblyName System.Data

    #Create new SQL connection
    $sqlconnection = New-Object -TypeName System.Data.SqlClient.SqlConnection("Server=$server; Database=$database; Integrated Security=$true")

    #Create new SQL Adapter to send SQL commands
    $sqladatper = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter
   
    #Create new SQL Dataset to return SQL data
    $dataset = New-Object -TypeName System.Data.DataSet

    #Open connection to database
    $sqlconnection.Open()

    #Insert data into database
    $sqlcmd = New-Object -TypeName System.Data.SqlClient.SqlCommand("$SQLupdate", $sqlconnection)
 
    $sqladatper.UpdateCommand = $sqlcmd
    $result = $sqlcmd.ExecuteNonQuery()
 
    #Close connnection to database
    $sqlconnection.Close()

    #Output success message
    If($result)
    {
        Write-Output 'Command successfully executed!'
    }
}

Function DJ_Invoke-SQLdelete
{
    <#
    .DESCRIPTION
        Invokes SQL delete statement on particular database
    .EXAMPLE
        DJ_Invoke-SQLdelete -Server some_server -Database some_database -SQLdelete "DELETE FROM some_table WHERE some_field='some_value'"
    .EXAMPLE
        "DELETE FROM some_table WHERE some_field='some_value'" | DJ_Invoke-SQLdelete -Server some_server -Database some_database
    .NOTES
        Author: Delonte JOhnson
    #>
    
    [CmdletBinding()]
    
    Param
    (   
        [parameter(Mandatory=$true)][string] $Server,
        [parameter(Mandatory=$true)][string] $Database,
        [parameter(Mandatory=$true, ValueFromPipeline=$true)][string] $SQLdelete
    )

    #Load neccessary assembly
    Add-Type -AssemblyName System.Data

    #Create new SQL connection
    $sqlconnection = New-Object -TypeName System.Data.SqlClient.SqlConnection("Server=$server; Database=$database; Integrated Security=$true")

    #Create new SQL Adapter to send SQL commands
    $sqladatper = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter
   
    #Create new SQL Dataset to return SQL data
    $dataset = New-Object -TypeName System.Data.DataSet

    #Open connection to database
    $sqlconnection.Open()

    #Insert data into database
    $sqlcmd = New-Object -TypeName System.Data.SqlClient.SqlCommand("$SQLdelete", $sqlconnection)
 
    $sqladatper.DeleteCommand = $sqlcmd
    $result = $sqlcmd.ExecuteNonQuery()
 
    #Close connnection to database
    $sqlconnection.Close()

    #Output success message
    If($result)
    {
        Write-Output 'Command successfully executed!'
    }
}