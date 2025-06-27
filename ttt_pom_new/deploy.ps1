# -------- deploy.ps1 --------
$projectPath = "C:\Users\vldmr\ttt_pom_new"
$deployPath = "C:\Users\vldmr\gh-pages-folder"
$buildPath = "$projectPath\build\web"
$ghRepoUrl = "https://github.com/VladimirBa/ttt_pom_offline.git"

# Переход в проект
cd $projectPath

# Очистка и сборка
flutter clean
flutter build web --base-href="/ttt_pom_offline/"

# Проверка сборки
if (!(Test-Path "$buildPath\index.html")) {
    Write-Host "❌ Сборка не удалась: отсутствует index.html"
    exit 1
}

# Очистка и копирование
Remove-Item -Recurse -Force "$deployPath\*" -ErrorAction SilentlyContinue
Copy-Item -Recurse -Force "$buildPath\*" "$deployPath"

# Пуш в gh-pages
cd $deployPath
if (!(Test-Path ".git")) {
    git init
    git remote add origin $ghRepoUrl
    git checkout -b gh-pages
}
git add .
git commit -m "Автодеплой $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push -u origin gh-pages --force

# Открытие сайта
Start-Process "https://vladimirba.github.io/ttt_pom_offline/"
# -------- /deploy.ps1 --------
