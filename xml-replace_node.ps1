###############################################################################
# Edits an XML file to remove an existing node and replace it with a new one. #
#                                                                             #
# The example below adds an Element to an IIS config file.                    #
###############################################################################

# Specify the path to the XML file
$xmlPath = "c:\windows\system32\inetsrv\config\applicationHost.config"

# Parse the XML file into a variable
[xml]$xml = Get-Content -Path $xmlPath

# New XML elements to add
[xml]$xFrameXml = @"
            <customHeaders>
                <add name="X-Frame-Options" value="SAMEORIGIN" />
            </customHeaders>
"@

# Locate the correct node/s and loop through, removing any existing child nodes and adding the new XML above
foreach($node in $xml.SelectNodes('/configuration/system.webServer/httpProtocol/customHeaders')){
    $node.ParentNode.AppendChild($xml.ImportNode($xFrameXml.customHeaders, $true));
    $node.ParentNode.RemoveChild($node);

}

# Don't forget to save! If you're testing, make sure to change this to a different path
$xml.Save($xmlPath);
