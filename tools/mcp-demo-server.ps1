param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("calculate", "get_time")]
    [string]$Tool
)

[Console]::InputEncoding = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

function Send-McpMessage {
    param([object]$Message)

    $jsonLine = ConvertTo-Json -InputObject $Message -Depth 20 -Compress
    [Console]::Out.WriteLine($jsonLine)
    [Console]::Out.Flush()
}

function New-ToolError {
    param([string]$Message)

    return @{
        content = @(@{ type = "text"; text = $Message })
        isError = $true
    }
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
                        name = "${Tool}-windows"
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
                if ($Tool -eq "calculate") {
                    $toolDefinition = @{
                        name = "calculate"
                        description = "Perform basic arithmetic on two numbers."
                        inputSchema = @{
                            type = "object"
                            properties = @{
                                a = @{ type = "number"; description = "First number." }
                                b = @{ type = "number"; description = "Second number." }
                                operation = @{
                                    type = "string"
                                    enum = @("add", "subtract", "multiply", "divide")
                                    description = "Arithmetic operation to perform."
                                }
                            }
                            required = @("a", "b", "operation")
                        }
                    }
                }
                else {
                    $toolDefinition = @{
                        name = "get_time"
                        description = "Return the current local date and time with its timezone offset."
                        inputSchema = @{
                            type = "object"
                            properties = @{}
                        }
                    }
                }

                Send-McpMessage @{
                    jsonrpc = "2.0"
                    id = $requestId
                    result = @{
                        tools = @($toolDefinition)
                    }
                }
            }
        }
        "tools/call" {
            if ($hasRequestId) {
                $requestedTool = [string]$request.params.name
                $arguments = $request.params.arguments

                if ($requestedTool -ne $Tool) {
                    $toolResult = New-ToolError -Message "Unknown tool: $requestedTool"
                }
                elseif ($Tool -eq "get_time") {
                    $currentTime = [DateTimeOffset]::Now.ToString(
                        "yyyy-MM-dd HH:mm:ss zzz",
                        [Globalization.CultureInfo]::InvariantCulture
                    )
                    $toolResult = @{
                        content = @(@{ type = "text"; text = $currentTime })
                        isError = $false
                    }
                }
                else {
                    $aProperty = if ($null -ne $arguments) { $arguments.PSObject.Properties["a"] } else { $null }
                    $bProperty = if ($null -ne $arguments) { $arguments.PSObject.Properties["b"] } else { $null }
                    $operationProperty = if ($null -ne $arguments) { $arguments.PSObject.Properties["operation"] } else { $null }

                    $validA = $null -ne $aProperty -and $aProperty.Value -is [ValueType] -and $aProperty.Value -isnot [bool]
                    $validB = $null -ne $bProperty -and $bProperty.Value -is [ValueType] -and $bProperty.Value -isnot [bool]
                    $validOperation = $null -ne $operationProperty -and $operationProperty.Value -is [string]

                    if (-not $validA -or -not $validB -or -not $validOperation) {
                        $toolResult = New-ToolError -Message "Arguments must include numeric a and b values and a supported operation."
                    }
                    else {
                        $a = [double]$aProperty.Value
                        $b = [double]$bProperty.Value
                        $operation = [string]$operationProperty.Value
                        $calculationError = $null

                        switch ($operation) {
                            "add" { $calculationResult = $a + $b }
                            "subtract" { $calculationResult = $a - $b }
                            "multiply" { $calculationResult = $a * $b }
                            "divide" {
                                if ($b -eq 0) {
                                    $calculationError = "Cannot divide by zero."
                                }
                                else {
                                    $calculationResult = $a / $b
                                }
                            }
                            default { $calculationError = "Unsupported operation: $operation" }
                        }

                        if ($null -ne $calculationError) {
                            $toolResult = New-ToolError -Message $calculationError
                        }
                        else {
                            $resultText = ([double]$calculationResult).ToString(
                                "G",
                                [Globalization.CultureInfo]::InvariantCulture
                            )
                            $toolResult = @{
                                content = @(@{ type = "text"; text = $resultText })
                                isError = $false
                            }
                        }
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
