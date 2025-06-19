# Получаем количество существующих файлов combined_code_ttt_pom_*.txt
$count = (Get-ChildItem -Path C:\Users\vldmr\Desktop\Temp.Files\ -Filter combined_code_ttt_pom_*.txt).Count

# Увеличиваем счетчик на 1
$count++

# Создаем имя файла с номером сохранения
$newFileName = "combined_code_ttt_pom_$count.txt"

# Копируем содержимое combined_code_ttt_pom.txt в новый файл
Get-Content -Path C:\Users\vldmr\Desktop\Temp.Files\combined_code_ttt_pom.txt | Out-File -FilePath C:\Users\vldmr\Desktop\Temp.Files\$newFileName -Encoding UTF8

# Добавляем разделители и содержимое файлов в новый файл
Get-ChildItem -Path C:\Users\vldmr\ttt_pom\lib -Recurse -Include *.dart -ErrorAction SilentlyContinue | ForEach-Object {
    "=================================================" | Out-File -FilePath C:\Users\vldmr\Desktop\Temp.Files\$newFileName -Append -Encoding UTF8
    $_.Name | Out-File -FilePath C:\Users\vldmr\Desktop\Temp.Files\$newFileName -Append -Encoding UTF8
    "=================================================" | Out-File -FilePath C:\Users\vldmr\Desktop\Temp.Files\$newFileName -Append -Encoding UTF8
    Get-Content $_.FullName | Out-File -FilePath C:\Users\vldmr\Desktop\Temp.Files\$newFileName -Append -Encoding UTF8
}
tree /f /a C:\Users\vldmr\ttt_pom\lib > C:\Users\vldmr\Desktop\Temp.Files\lib_structure_ttt_pom.txt