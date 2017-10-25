###############################################################################
# Edits an XML file to add a node and replace it with a new one.              #
#                                                                             #
# The example below adds an Element to an IIS config file.                    #
###############################################################################

# Specify the path to the XML file
$xmlPath = "c:\windows\system32\inetsrv\config\applicationHost.config"

# Parse the XML file into a variable
[xml]$xml = Get-Content -Path $xmlPath

# New XML elements to add
[xml]$xFrameXml = @"
        <rewrite>
            <rules>
                <rule name="HTTP to HTTPS redirect" stopProcessing="true">
                    <match url="(.*)" />
                    <conditions>
                        <add input="{HTTPS}" pattern="off" ignoreCase="true" />
                    </conditions>
                    <action type="Redirect" url="https://{HTTP_HOST}/{R:1}" redirectType="Permanent" />
                </rule>
            </rules>
            <outboundRules>
                <rule name="Add Strict-Transport-Security when HTTPS" enabled="true">
                    <match serverVariable="RESPONSE_Strict_Transport_Security" pattern=".*" />
                    <conditions>
                        <add input="{HTTPS}" pattern="on" ignoreCase="true" />
                    </conditions>
                    <action type="Rewrite" value="max-age=31536000" />
                </rule>
            </outboundRules>
        </rewrite>
"@

$rewrite = $xml.configuration."system.webServer".rewrite

if ($rewrite -neq $null) {
    $node.ParentNode.AppendChild($xml.ImportNode($rewriteXml."system.webServer"));
}

# Don't forget to save! If you're testing, make sure to change this to a different path
$xml.Save($xmlPath);
