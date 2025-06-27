flutter clean
flutter build web --base-href="/ttt_pom_offline/"

Remove-Item -Recurse -Force ../gh-pages-folder/* -ErrorAction SilentlyContinue
Copy-Item -Recurse -Force build/web/* ../gh-pages-folder/

cd ../gh-pages-folder
git add .
git commit -m "Авто-деплой"
git push origin gh-pages

Start-Process "https://vladimirba.github.io/ttt_pom_offline/"
