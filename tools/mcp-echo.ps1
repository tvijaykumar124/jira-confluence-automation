[Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

function Send-McpMessage {
    param([object]$Message)

    $jsonLine = ConvertTo-Json -InputObject $Message -Depth 20 -Compress
    [Console]::Out.WriteLine($jsonLine)
    [Console]::Out.Flush()
}

while ($null -ne ($requestLine = [Console]::In.ReadLine())) {
    if ([string]::IsNullOrWhiteSpace($requestLine)) {
        continue
    }

    try {
        $request = ConvertFrom-Json -InputObject $requestLine -ErrorAction Stop
    }
    catch {
        [Console]::Error.WriteLine("Invalid JSON-RPC message: $($_.Exception.Message)")
        continue
    }

    $requestIdProperty = $request.PSObject.Properties["id"]
    $hasRequestId = $null -ne $requestIdProperty
    $requestId = if ($hasRequestId) { $requestIdProperty.Value } else { $null }

    switch ([string]$request.method) {
        "initialize" {
            $protocolVersion = [string]$request.params.protocolVersion
            if ([string]::IsNullOrWhiteSpace($protocolVersion)) {
                $protocolVersion = "2025-06-18"
            }

            Send-McpMessage @{
                jsonrpc = "2.0"
                id = $requestId
                result = @{
                    protocolVersion = $protocolVersion
                    capabilities = @{
                        tools = @{}
                    }
                    serverInfo = @{
                        name = "echo-windows"
                        version = "1.0.0"
                    }
                }
            }
        }
        "notifications/initialized" {
            continue
        }
        "ping" {
            if ($hasRequestId) {
                Send-McpMessage @{
                    jsonrpc = "2.0"
                    id = $requestId
                    result = @{}
                }
            }
        }
        "tools/list" {
            if ($hasRequestId) {
                $echoTool = @{
                    name = "echo"
                    description = "Returns the supplied message unchanged."
                    inputSchema = @{
                        type = "object"
                        properties = @{
                            message = @{
                                type = "string"
                                description = "Message to echo."
                            }
                        }
                        required = @("message")
                    }
                }

                Send-McpMessage @{
                    jsonrpc = "2.0"
                    id = $requestId
                    result = @{
                        tools = @($echoTool)
                    }
                }
            }
        }
        "tools/call" {
            if ($hasRequestId) {
                $toolName = [string]$request.params.name
                $arguments = $request.params.arguments
                $messageProperty = if ($null -ne $arguments) { $arguments.PSObject.Properties["message"] } else { $null }

                if ($toolName -ne "echo") {
                    $toolResult = @{
                        content = @(@{ type = "text"; text = "Unknown tool: $toolName" })
                        isError = $true
                    }
                }
                elseif ($null -eq $messageProperty -or $messageProperty.Value -isnot [string]) {
                    $toolResult = @{
                        content = @(@{ type = "text"; text = "The message argument must be a string." })
                        isError = $true
                    }
                }
                else {
                    $toolResult = @{
                        content = @(@{ type = "text"; text = $messageProperty.Value })
                        isError = $false
                    }
                }

                Send-McpMessage @{
                    jsonrpc = "2.0"
                    id = $requestId
                    result = $toolResult
                }
            }
        }
        "exit" {
            break
        }
        default {
            if ($hasRequestId) {
                Send-McpMessage @{
                    jsonrpc = "2.0"
                    id = $requestId
                    error = @{
                        code = -32601
                        message = "Method not found: $($request.method)"
                    }
                }
            }
        }
    }
}
