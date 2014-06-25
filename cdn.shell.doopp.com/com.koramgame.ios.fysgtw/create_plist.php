<?php //-*-coding:utf-8;mode:php-mode;-*-

$package_name = array(	"com.koramgame.ios.fysgtw",
						"com.koramgame.android.fysgtw" );

$update_source = array(	"http://cdn.shell.doopp.com/com.koramgame.ios.fysgtw/",
						"http://cdn.shell.doopp.com/com.koramgame.android.fysgtw/" );

$upgrade_version = "1.11";

function getUpgradePlist($root_dir, $now_dir)
{
    $ret = "";
    $dir_handle = @opendir($now_dir);
    while (($file = readdir($dir_handle)) !== false)
    {
        if($file{0}=='.' || $file=='create_plist.php' || $file=='last_version.plist') {
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

$dir_name = dirname(__FILE__);

$upgrade_plist = "@package_name";
$first_loop = true;
foreach($package_name as $name) {
    $upgrade_plist .= $first_loop ? " ".$name : ", " . $name;
    $first_loop = false;
}

$upgrade_plist .= "\n@update_source";
$first_loop = true;
foreach($update_source as $source) {
    $upgrade_plist .= $first_loop ? " ".$source : ", " . $source;
    $first_loop = false;
}

$upgrade_plist .= "\n@version 1.11\n";

$upgrade_plist .= getUpgradePlist($dir_name, $dir_name);

file_put_contents($dir_name . DIRECTORY_SEPARATOR . "last_version.plist", $upgrade_plist);



