# Solicitar al usuario el nombre de la base de datos
$databaseName = Read-Host "Ingresa el nombre de la base de datos"

# Leer el contenido del archivo input.txt
$lines = Get-Content -Path "input.txt"

# Crear un arreglo para almacenar las primeras palabras
$firstWords = @()

# Iterar sobre cada línea
foreach ($line in $lines) {
    # Buscar la primera palabra entre comillas
    $word = $line -replace '^.*?"(.*?)".*$', '$1'
    $firstWords += $word
}

# Guardar las primeras palabras en un archivo output.txt
$firstWords | Out-File -FilePath "output.txt"

Write-Host "Proceso completado. Las primeras palabras se han guardado en 'output.txt'."

# Leer el contenido del archivo input.txt
$lines = Get-Content -Path "output.txt"

# Inicializar el arreglo para almacenar las líneas modificadas
$newLines = @()

# Iterar sobre cada palabra en las líneas
for ($i = 0; $i -lt $lines.Length; $i++) {
    $words = $lines[$i] -split '","'

    # Iterar sobre cada palabra en la línea actual
    foreach ($word in $words) {
        # Limpiar la palabra y construir la línea SQL
        $cleanedWord = $word -replace '["\s]', ''
        $newLine = "``$cleanedWord`` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,"
        $newLines += $newLine
    }
}

# Guardar las líneas modificadas en un archivo txt
$newLines | Out-File -FilePath "outputSQL.txt"

Write-Host "Proceso completado. Las líneas modificadas se han guardado en 'output.sql'."

# Leer la plantilla de la sentencia SQL
$template = Get-Content -Path "template.sql" -Raw

# Reemplazar la variable $VARIABLES$ con las líneas generadas
$variablesPart = $newLines -join [Environment]::NewLine
$modifiedTemplate = $template -replace '\$VARIABLES\$', $variablesPart

# Reemplazar la variable $DATABASE$ con el nombre de la base de datos
$modifiedTemplate = $modifiedTemplate -replace '\$DATABASE\$', $databaseName

# Guardar la sentencia SQL modificada en un archivo output.sql
$modifiedTemplate | Out-File -FilePath "output.sql"

Write-Host "Proceso completado. La sentencia SQL modificada se ha guardado en 'output.sql'."
