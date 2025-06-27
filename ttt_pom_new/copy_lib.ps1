# Определение путей
$source = "C:\Users\vldmr\ttt_pom_new\lib"
$destinationBase = "C:\Users\vldmr\Desktop\libFiles"

# Генерация уникального имени для новой папки
$count = 1
while (Test-Path "$destinationBase\lib_$count") {
    $count++
}

$newFolder = "$destinationBase\lib_$count"
Copy-Item -Path $source -Destination $newFolder -Recurse -Force
Write-Host "Папка скопирована в: $newFolder"