<?php //-*-coding:utf-8;mode:php-mode;-*-

$package_name = array(	"com.koramgame.ios.fysgtw",
						"com.koramgame.android.fysgtw" );

$update_source = array(	"http://static1.kunlun.com/test-game1/com.koramgame.ios.fysgtw/" );

function getUpgradePlist($root_dir, $now_dir)
{
    $ret = "";
    $dir_handle = @opendir($now_dir);
    while (($file = readdir($dir_handle)) !== false)
    {
        if($file{0}=='.' || $file=='create_flist.php' || $file=='last_version.flist') {
            continue;
        }
		if (substr($file, -3)=="php") {
			$txt_file = substr($file, 0, -3) . "txt";
			rename($now_dir . DIRECTORY_SEPARATOR . $file, $now_dir . DIRECTORY_SEPARATOR . $txt_file);
			$file = $txt_file;
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

$launch_web_version = "";
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
	file_put_contents($root_dir . DIRECTORY_SEPARATOR . $version . ".flist", $upgrade_plist);

	$launch_web_version .= '<a class="btn" href="lytest://com.doopp.qc2dx/?v='.$version.'">'.$version.'</a>';
}
copy($root_dir.DIRECTORY_SEPARATOR.$compare_version.".flist", $root_dir.DIRECTORY_SEPARATOR."last_version.flist");

closedir($root_dir_handle);


$launch_web = $root_dir . DIRECTORY_SEPARATOR . "launch.html";

$launch_web_html = <<<EOF
<!DOCTYPE html>
<html lang="zh-cn" >
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="format-detection" content="telephone=no"/>
<meta name="apple-mobile-web-app-status-bar-style" content="white" />
<title> Kunlun.com </title>
<style>
* { margin: 0; padding: 0; }
html, body { height: 100%; }
body, label, input, textarea, select, button {font-family: "Helvetica Neue",Arial,sans-serif;}
body {overflow-y: scroll;background-color: #ffffff;font-size: 14px; margin: 0;padding: 0;}
label, input, textarea, select {font-size: 13px;line-height: 20px;margin: 0;}
.nav {width: 100%;height: 40px;background-color: #252525;text-align:center;color:#fff;line-height:40px;}
.btn {height: 30px; line-height: 30px; width: 100%;background-color: #ffffff;border-bottom: 1px solid #252525;color: #222222;display: inline-block;}
</style>
</head>
<body>
<div>
<div class="nav">com.koramgame.ios.fysgtw</div>
{$launch_web_version}
</div>
</body>
</html>
EOF;

file_put_contents($launch_web, $launch_web_html );