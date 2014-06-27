@echo off
set RSYNC_PASSWORD=e6e0BHf8zpLY
rsync -avF --delete-after --exclude="rsync_cdn.bat" --exclude="create_plist.php" . "rsync://static_test_game1@42.62.23.98/static_test_game1/"
@echo http://static1.kunlun.com/test-game1/last_version.plist
pause