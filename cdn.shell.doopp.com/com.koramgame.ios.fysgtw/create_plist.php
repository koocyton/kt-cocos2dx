<?php //-*-coding:utf-8;mode:php-mode;-*-

$package_name = array(	"com.koramgame.ios.fysgtw",
						"com.koramgame.android.fysgtw" );

$update_source = array(	"http://static1.kunlun.com/test-game1/com.koramgame.ios.fysgtw/",
						"http://static1.kunlun.com/test-game1/com.koramgame.android.fysgtw/" );

function getUpgradePlist($root_dir, $now_dir)
{
    $ret = "";
    $dir_handle = @opendir($now_dir);
    while (($file = readdir($dir_handle)) !== false)
    {
        if($file{0}=='.' || $file=='create_plist.php' || $file=='last_version.plist' || $file=='rsync_cdn.bat') {
            continue;
        }
        $file = $now_dir . DIRECTORY_SEPARATOR . $file;
        if (filetype($file)=="dir") {
            $ret .= getUpgradePlist($root_dir, $file);
        }
        else {
            $start = 1 + strlen($root_dir);
            $ret .= "\n" . str_replace("\\", "/", substr($file, $start) ." ". md5_file($file) ." ". filesize($file));
        }
    }
    closedir($dir_handle);
    return $ret;
}

/***********************************************************/

$root_dir = dirname(__FILE__);

$package_name_plist = "@package_name";
$first_loop = true;
foreach($package_name as $name) {
    $package_name_plist .= $first_loop ? " ".$name : ", " . $name;
    $first_loop = false;
}

$compare_version = "";
$root_dir_handle = @opendir($root_dir);
while (($version = readdir($root_dir_handle)) !== false)
{
	if($version{0}=='.' || filetype($version)!="dir") {
		continue;
	}
	$compare_version = ($compare_version=="") ? $version : version_compare($compare_version, $version)==-1 
											  ? $version : $compare_version;
	$upgrade_plist = $package_name_plist . "\n@update_source";
	$first_loop = true;
	foreach($update_source as $source) {
		$upgrade_plist .= $first_loop ? " ".$source . $version : ", " . $source . $version;
		$first_loop = false;
	}
	$upgrade_plist .= "\n@version " . $version . "\n";
	$version_dir = $root_dir . DIRECTORY_SEPARATOR . $version;
	$upgrade_plist .= getUpgradePlist($version_dir, $version_dir);
	file_put_contents($root_dir . DIRECTORY_SEPARATOR . $version . ".plist", $upgrade_plist);
}
copy($root_dir.DIRECTORY_SEPARATOR.$compare_version.".plist", $root_dir.DIRECTORY_SEPARATOR."last_version.plist");

closedir($root_dir_handle);
